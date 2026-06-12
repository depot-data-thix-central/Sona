// lib/providers/feed_provider.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import '../services/network_service.dart';
import '../models/network_post.dart';

class FeedProvider extends ChangeNotifier {
  final NetworkService _networkService;
  final SupabaseClient? _supabase;
  
  List<NetworkPost> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _currentFeedType = 'smart';
  String? _error;
  
  // ✅ AJOUT: Real-time listening
  RealtimeChannel? _realtimeChannel;
  Timer? _autoRefreshTimer;
  DateTime? _lastRefresh;
  
  FeedProvider(this._networkService, {SupabaseClient? supabase}) : _supabase = supabase;
  
  // Getters
  List<NetworkPost> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get currentFeedType => _currentFeedType;
  String? get error => _error;
  
  // ============================================================
  // INITIALISATION REALTIME
  // ============================================================
  
  /// ✅ CORRIGÉ: Démarre l'écoute realtime et le polling
  void initRealtime() {
    debugPrint('🎙️ FeedProvider: Initialisation realtime...');
    
    _setupRealtimeListener();
    _setupAutoRefresh();
  }
  
  /// ✅ Configuration du listener Realtime Supabase
  void _setupRealtimeListener() {
    try {
      if (_supabase == null) {
        debugPrint('❌ FeedProvider: Supabase client manquant');
        return;
      }
      
      _realtimeChannel = _supabase!
          .channel('public:posts')
          .onInsert((payload) {
            debugPrint('📬 [REALTIME] Nouvelle publication détectée!');
            _onPostInserted(payload.newRecord);
          })
          .onUpdate((payload) {
            debugPrint('📝 [REALTIME] Publication mise à jour');
            _onPostUpdated(payload.newRecord);
          })
          .onDelete((payload) {
            debugPrint('🗑️ [REALTIME] Publication supprimée');
            _onPostDeleted(payload.oldRecord);
          });
      
      _realtimeChannel!.subscribe((status, err) {
        if (err != null) {
          debugPrint('❌ FeedProvider Realtime error: $err');
        } else if (status == RealtimeSubscriptionStatus.subscribed) {
          debugPrint('✅ FeedProvider: Realtime connecté');
        }
      });
    } catch (e) {
      debugPrint('❌ FeedProvider _setupRealtimeListener error: $e');
    }
  }
  
  /// ✅ Configuration du polling automatique (refresh toutes les 5 secondes)
  void _setupAutoRefresh() {
    _autoRefreshTimer?.cancel();
    
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      // Ne recharger que si pas de chargement en cours
      if (!_isLoading) {
        await _autoRefresh();
      }
    });
    
    debugPrint('✅ FeedProvider: Auto-refresh activé (5s)');
  }
  
  /// ✅ Refresh automatique silencieux
  Future<void> _autoRefresh() async {
    try {
      final now = DateTime.now();
      if (_lastRefresh != null && 
          now.difference(_lastRefresh!).inSeconds < 3) {
        return; // Éviter les refresh trop fréquents
      }
      
      _lastRefresh = now;
      
      late List<NetworkPost> newPosts;
      
      switch (_currentFeedType) {
        case 'smart':
          newPosts = await _networkService.getSmartFeed(limit: 20);
          break;
        case 'popular':
          final allPosts = await _networkService.getFeedPosts(limit: 50);
          allPosts.sort((a, b) => b.likesCount.compareTo(a.likesCount));
          newPosts = allPosts.take(20).toList();
          break;
        default:
          newPosts = await _networkService.getFeedPosts(limit: 20);
      }
      
      // Vérifier s'il y a de nouvelles publications
      if (newPosts.isNotEmpty && 
          (newPosts.length > _posts.length || 
           newPosts.first.id != _posts.firstOrNull?.id)) {
        debugPrint('🔄 [AUTO-REFRESH] ${newPosts.length} posts détectés');
        _posts = newPosts;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ FeedProvider _autoRefresh error: $e');
    }
  }
  
  /// ✅ Quand une nouvelle publication est insérée
  void _onPostInserted(Map<String, dynamic> record) {
    try {
      debugPrint('📬 Ajout du nouveau post au feed');
      // Recharger le feed pour obtenir le post complet avec les infos utilisateur
      loadFeed(feedType: _currentFeedType);
    } catch (e) {
      debugPrint('❌ FeedProvider _onPostInserted error: $e');
    }
  }
  
  /// ✅ Quand une publication est mise à jour
  void _onPostUpdated(Map<String, dynamic> record) {
    try {
      final postId = record['id'] as String?;
      if (postId == null) return;
      
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        debugPrint('📝 Mise à jour du post $postId');
        // Recharger le post complet
        loadFeed(feedType: _currentFeedType);
      }
    } catch (e) {
      debugPrint('❌ FeedProvider _onPostUpdated error: $e');
    }
  }
  
  /// ✅ Quand une publication est supprimée
  void _onPostDeleted(Map<String, dynamic> record) {
    try {
      final postId = record['id'] as String?;
      if (postId == null) return;
      
      debugPrint('🗑️ Suppression du post $postId');
      _posts.removeWhere((p) => p.id == postId);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ FeedProvider _onPostDeleted error: $e');
    }
  }
  
  // ============================================================
  // CHARGEMENT DU FEED
  // ============================================================
  
  Future<void> loadFeed({String? feedType, int limit = 20}) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      if (feedType != null) _currentFeedType = feedType;
      
      debugPrint('📥 FeedProvider: Chargement du feed ($feedType)...');
      
      late List<NetworkPost> newPosts;
      
      switch (_currentFeedType) {
        case 'smart':
          newPosts = await _networkService.getSmartFeed(limit: limit);
          break;
        case 'popular':
          final allPosts = await _networkService.getFeedPosts(limit: 50);
          allPosts.sort((a, b) => b.likesCount.compareTo(a.likesCount));
          newPosts = allPosts.take(limit).toList();
          break;
        default:
          newPosts = await _networkService.getFeedPosts(limit: limit);
      }
      
      _posts = newPosts;
      _hasMore = newPosts.length >= limit;
      _lastRefresh = DateTime.now();
      
      debugPrint('✅ FeedProvider: ${_posts.length} posts chargés');
      
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ FeedProvider loadFeed error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// ✅ Pull-to-refresh manuel
  Future<void> refreshFeed() async {
    debugPrint('🔄 FeedProvider: Refresh manuel...');
    await loadFeed(feedType: _currentFeedType);
  }
  
  // ============================================================
  // CRÉATION DE POST
  // ============================================================
  
  Future<bool> createPost(String content, List<String> images) async {
    try {
      debugPrint('📝 FeedProvider: création du post...');
      
      final postId = await _networkService.createPost(content, images);
      
      if (postId.isEmpty) {
        debugPrint('❌ FeedProvider: pas d\'ID retourné');
        return false;
      }
      
      debugPrint('✅ FeedProvider: post créé avec ID: $postId');
      
      // Recharger tout le feed
      await loadFeed(feedType: _currentFeedType);
      debugPrint('🔄 FeedProvider: feed rechargé, ${_posts.length} posts');
      
      return true;
    } catch (e) {
      debugPrint('❌ FeedProvider createPost error: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // ============================================================
  // INTERACTIONS (LIKE, COMMENTAIRE)
  // ============================================================
  
  /// ✅ CORRIGÉ - Version simplifiée sans utiliser les paramètres manquants
  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    
    final post = _posts[index];
    final dynamicPost = post as dynamic;
    final wasLiked = dynamicPost.isLikedByCurrentUser ?? false;
    
    // Mise à jour optimiste
    final updatedPost = post.copyWith(
      likesCount: wasLiked ? post.likesCount - 1 : post.likesCount + 1,
    );
    
    _posts[index] = updatedPost;
    notifyListeners();
    
    try {
      if (wasLiked) {
        await _networkService.unlikePost(postId);
      } else {
        await _networkService.likePost(postId);
      }
    } catch (e) {
      // Revert on error
      _posts[index] = post;
      notifyListeners();
      debugPrint('❌ FeedProvider toggleLike error: $e');
    }
  }
  
  Future<void> addComment(String postId, String comment) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    
    final post = _posts[index];
    
    // Optimistic update
    final updatedPost = post.copyWith(
      commentsCount: post.commentsCount + 1,
    );
    _posts[index] = updatedPost;
    notifyListeners();
    
    try {
      await _networkService.addComment(postId, comment);
      // Recharger pour avoir les commentaires à jour
      await loadFeed(feedType: _currentFeedType);
    } catch (e) {
      // Revert on error
      _posts[index] = post;
      notifyListeners();
      debugPrint('❌ FeedProvider addComment error: $e');
    }
  }
  
  // ============================================================
  // SAUVEGARDER
  // ============================================================
  
  Future<void> savePost(String postId) async {
    try {
      await _networkService.savePost(postId);
      debugPrint('✅ FeedProvider: post $postId sauvegardé');
    } catch (e) {
      debugPrint('❌ FeedProvider savePost error: $e');
      rethrow;
    }
  }
  
  // ============================================================
  // PARTAGER
  // ============================================================
  
  Future<void> sharePost(String postId) async {
    try {
      await _networkService.sharePost(postId);
      debugPrint('✅ FeedProvider: post $postId partagé');
    } catch (e) {
      debugPrint('❌ FeedProvider sharePost error: $e');
      rethrow;
    }
  }
  
  // ============================================================
  // SUPPRIMER
  // ============================================================
  
  Future<void> deletePost(String postId) async {
    try {
      await _networkService.deletePost(postId);
      debugPrint('✅ FeedProvider: post $postId supprimé');
      
      // Recharger le feed après suppression
      await loadFeed(feedType: _currentFeedType);
    } catch (e) {
      debugPrint('❌ FeedProvider deletePost error: $e');
      rethrow;
    }
  }
  
  // ============================================================
  // SIGNALER
  // ============================================================
  
  Future<void> reportPost(String postId, String reason) async {
    try {
      await _networkService.reportPost(postId, reason);
      debugPrint('✅ FeedProvider: post $postId signalé pour: $reason');
    } catch (e) {
      debugPrint('❌ FeedProvider reportPost error: $e');
      rethrow;
    }
  }
  
  // ============================================================
  // ÉPINGLER / REPOSTER
  // ============================================================
  
  Future<void> pinPost(String postId) async {
    try {
      await _networkService.pinPost(postId);
      debugPrint('✅ FeedProvider: post $postId épinglé');
    } catch (e) {
      debugPrint('❌ FeedProvider pinPost error: $e');
      rethrow;
    }
  }
  
  Future<void> repost(String postId, String comment) async {
    try {
      await _networkService.repost(postId, comment);
      debugPrint('✅ FeedProvider: post $postId reposté');
      await loadFeed(feedType: _currentFeedType);
    } catch (e) {
      debugPrint('❌ FeedProvider repost error: $e');
      rethrow;
    }
  }
  
  // ============================================================
  // UTILITAIRES
  // ============================================================
  
  void clearPosts() {
    _posts = [];
    _error = null;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// ✅ Nettoyage lors de la destruction
  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}
