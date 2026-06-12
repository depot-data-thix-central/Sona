// lib/services/admin_news_service.dart
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thix_id/supabase/supabase_config.dart';

class AdminNewsService {
  static const String table = 'news_articles';
  static const String coverBucketDefault = 'news_images';
  static const String videosBucketDefault = 'news_videos';
  
  // ✅ AJOUTÉ: Limites et constantes
  static const int defaultLimit = 50;
  static const int maxLimit = 200;

  final SupabaseClient _client;

  AdminNewsService({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  // ============================================================
  // LISTE DES ARTICLES
  // ============================================================

  Future<List<Map<String, dynamic>>> listNews({
    String? category,
    String? status,
    bool? isFeatured,
    bool? isBreaking,
    int limit = defaultLimit,
    bool ascending = false,
  }) async {
    try {
      debugPrint('📰 AdminNewsService.listNews: chargement des articles...');
      
      var query = _client.from(table).select('*');
      
      // ✅ AJOUTÉ: Filtres optionnels
      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }
      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }
      if (isFeatured != null) {
        query = query.eq('is_featured', isFeatured);
      }
      if (isBreaking != null) {
        query = query.eq('is_breaking', isBreaking);
      }
      
      final res = await query
          .order('published_at', ascending: ascending)
          .limit(limit.clamp(1, maxLimit));
      
      if (res is List) {
        debugPrint('✅ AdminNewsService.listNews: ${res.length} articles chargés');
        return res.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('❌ AdminNewsService.listNews error: $e');
      rethrow;
    }
  }

  // ✅ NOUVELLE MÉTHODE: Récupérer un article par ID
  Future<Map<String, dynamic>?> getNewsById(String id) async {
    try {
      final res = await _client
          .from(table)
          .select('*')
          .eq('id', id)
          .maybeSingle();
      
      if (res == null) return null;
      return res as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ AdminNewsService.getNewsById error: $e');
      return null;
    }
  }

  // ✅ NOUVELLE MÉTHODE: Récupérer les articles publiés
  Future<List<Map<String, dynamic>>> getPublishedNews({int limit = defaultLimit}) async {
    return await listNews(status: 'published', limit: limit);
  }

  // ✅ NOUVELLE MÉTHODE: Récupérer les articles en brouillon
  Future<List<Map<String, dynamic>>> getDraftNews({int limit = defaultLimit}) async {
    return await listNews(status: 'draft', limit: limit);
  }

  // ✅ NOUVELLE MÉTHODE: Récupérer les articles à la une
  Future<List<Map<String, dynamic>>> getFeaturedNews({int limit = defaultLimit}) async {
    return await listNews(isFeatured: true, status: 'published', limit: limit);
  }

  // ============================================================
  // CRÉATION / MISE À JOUR D'ARTICLE
  // ============================================================

  Future<String> upsertNews({
    String? id,
    required String title,
    String? summary,
    required String category,
    String? source,
    String? severity,
    required String content,
    bool isFeatured = false,
    String? imageUrl,
    String? videoUrl,
    bool isBreaking = false,
    String status = 'published',
    DateTime? publishedAt,
  }) async {
    // ✅ AJOUTÉ: Validation des données
    if (title.trim().isEmpty) {
      throw Exception('Le titre de l\'article est requis');
    }
    if (content.trim().isEmpty) {
      throw Exception('Le contenu de l\'article est requis');
    }
    if (category.trim().isEmpty) {
      throw Exception('La catégorie de l\'article est requise');
    }

    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final publishDate = (publishedAt ?? DateTime.now()).toUtc().toIso8601String();
      
      final data = <String, dynamic>{
        'title': title.trim(),
        'summary': summary?.trim(),
        'category': category.trim(),
        'content': content.trim(),
        'is_featured': isFeatured,
        'is_breaking': isBreaking,
        'status': status,
        'updated_at': now,
        if (source != null && source.trim().isNotEmpty) 'source': source.trim(),
        if (severity != null && severity.trim().isNotEmpty) 'severity': severity.trim(),
        if (imageUrl != null && imageUrl.trim().isNotEmpty) 'image_url': imageUrl.trim(),
        if (videoUrl != null && videoUrl.trim().isNotEmpty) 'video_url': videoUrl.trim(),
      };

      debugPrint('📝 AdminNewsService.upsertNews: ${id == null ? "Création" : "Mise à jour"} de "$title"');

      if (id == null || id.isEmpty) {
        // Création
        data['created_at'] = now;
        data['published_at'] = publishDate;
        data['views_count'] = 0;
        
        final res = await _client.from(table).insert(data).select().single();
        final newsId = res['id'].toString();
        debugPrint('✅ AdminNewsService.upsertNews: Article créé avec ID $newsId');
        return newsId;
      } else {
        // Mise à jour
        await _client.from(table).update(data).eq('id', id);
        debugPrint('✅ AdminNewsService.upsertNews: Article $id mis à jour');
        return id;
      }
    } catch (e) {
      debugPrint('❌ AdminNewsService.upsertNews error: $e');
      rethrow;
    }
  }

  // ============================================================
  // MISE À JOUR DE L'IMAGE DE COUVERTURE
  // ============================================================

  Future<void> updateCoverImage({
    required String newsId,
    required String bucket,
    required String storagePath,
  }) async {
    if (newsId.trim().isEmpty) {
      throw Exception('ID d\'article requis');
    }
    
    try {
      debugPrint('🖼️ AdminNewsService.updateCoverImage: Article $newsId');
      
      await _client.from(table).update({
        'image_url': _getPublicUrl(bucket, storagePath),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', newsId);
      
      debugPrint('✅ AdminNewsService.updateCoverImage: Image mise à jour');
    } catch (e) {
      debugPrint('❌ AdminNewsService.updateCoverImage error: $e');
      rethrow;
    }
  }

  // ============================================================
  // SUPPRESSION D'ARTICLE
  // ============================================================

  Future<void> deleteNews({required String id}) async {
    final newsId = id.trim();
    if (newsId.isEmpty) {
      throw Exception('ID d\'article requis');
    }
    
    try {
      debugPrint('🗑️ AdminNewsService.deleteNews: Suppression de l\'article $newsId');
      
      await _client.from(table).delete().eq('id', newsId);
      
      debugPrint('✅ AdminNewsService.deleteNews: Article supprimé');
    } catch (e) {
      debugPrint('❌ AdminNewsService.deleteNews error: $e');
      rethrow;
    }
  }

  // ============================================================
  // CHANGEMENT DE STATUT
  // ============================================================

  // ✅ NOUVELLE MÉTHODE: Publier un article
  Future<void> publishNews(String id) async {
    try {
      await _client.from(table).update({
        'status': 'published',
        'published_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', id);
      debugPrint('📢 AdminNewsService.publishNews: Article $id publié');
    } catch (e) {
      debugPrint('❌ AdminNewsService.publishNews error: $e');
      rethrow;
    }
  }

  // ✅ NOUVELLE MÉTHODE: Dépublier un article
  Future<void> unpublishNews(String id) async {
    try {
      await _client.from(table).update({
        'status': 'draft',
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', id);
      debugPrint('📢 AdminNewsService.unpublishNews: Article $id dépublié');
    } catch (e) {
      debugPrint('❌ AdminNewsService.unpublishNews error: $e');
      rethrow;
    }
  }

  // ✅ NOUVELLE MÉTHODE: Mettre à la une
  Future<void> setAsFeatured(String id, {bool featured = true}) async {
    try {
      await _client.from(table).update({
        'is_featured': featured,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', id);
      debugPrint('⭐ AdminNewsService.setAsFeatured: Article $id ${featured ? "à la une" : "retiré de la une"}');
    } catch (e) {
      debugPrint('❌ AdminNewsService.setAsFeatured error: $e');
      rethrow;
    }
  }

  // ✅ NOUVELLE MÉTHODE: Mettre en breaking news
  Future<void> setAsBreaking(String id, {bool breaking = true}) async {
    try {
      await _client.from(table).update({
        'is_breaking': breaking,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', id);
      debugPrint('🚨 AdminNewsService.setAsBreaking: Article $id ${breaking ? "breaking" : "normal"}');
    } catch (e) {
      debugPrint('❌ AdminNewsService.setAsBreaking error: $e');
      rethrow;
    }
  }

  // ============================================================
  // UPLOAD
  // ============================================================

  Future<String?> uploadImage(String filePath) async {
    try {
      final currentUserId = _client.auth.currentUser?.id;
      if (currentUserId == null) {
        debugPrint('❌ AdminNewsService.uploadImage: Utilisateur non connecté');
        return null;
      }

      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('❌ AdminNewsService.uploadImage: Fichier introuvable');
        return null;
      }
      
      final bytes = await file.readAsBytes();
      final extension = filePath.split('.').last;
      final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(6)}.$extension';
      final storagePath = '$currentUserId/$fileName';
      
      await _client.storage
          .from(coverBucketDefault)
          .uploadBinary(storagePath, bytes);
      
      final publicUrl = _client.storage.from(coverBucketDefault).getPublicUrl(storagePath);
      debugPrint('✅ AdminNewsService.uploadImage: Image uploadée');
      return publicUrl;
    } catch (e) {
      debugPrint('❌ AdminNewsService.uploadImage error: $e');
      return null;
    }
  }

  Future<String?> uploadVideo(String filePath) async {
    try {
      final currentUserId = _client.auth.currentUser?.id;
      if (currentUserId == null) {
        debugPrint('❌ AdminNewsService.uploadVideo: Utilisateur non connecté');
        return null;
      }

      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('❌ AdminNewsService.uploadVideo: Fichier introuvable');
        return null;
      }
      
      final bytes = await file.readAsBytes();
      final extension = filePath.split('.').last;
      final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(6)}.$extension';
      final storagePath = '$currentUserId/$fileName';
      
      await _client.storage
          .from(videosBucketDefault)
          .uploadBinary(storagePath, bytes);
      
      final publicUrl = _client.storage.from(videosBucketDefault).getPublicUrl(storagePath);
      debugPrint('✅ AdminNewsService.uploadVideo: Vidéo uploadée');
      return publicUrl;
    } catch (e) {
      debugPrint('❌ AdminNewsService.uploadVideo error: $e');
      return null;
    }
  }

  // ✅ NOUVELLE MÉTHODE: Upload d'image multiple
  Future<List<String>> uploadMultipleImages(List<String> filePaths) async {
    final List<String> urls = [];
    for (final path in filePaths) {
      final url = await uploadImage(path);
      if (url != null) {
        urls.add(url);
      }
    }
    debugPrint('✅ AdminNewsService.uploadMultipleImages: ${urls.length} images uploadées');
    return urls;
  }

  // ============================================================
  // STATISTIQUES
  // ============================================================

  // ✅ NOUVELLE MÉTHODE: Statistiques des articles
  Future<Map<String, int>> getStats() async {
    try {
      final articles = await listNews(limit: maxLimit);
      
      final published = articles.where((e) => e['status'] == 'published').length;
      final drafts = articles.where((e) => e['status'] == 'draft').length;
      final featured = articles.where((e) => e['is_featured'] == true).length;
      final breaking = articles.where((e) => e['is_breaking'] == true).length;
      
      // Compter par catégorie
      final Map<String, int> categories = {};
      for (var article in articles) {
        final cat = article['category']?.toString() ?? 'non catégorisé';
        categories[cat] = (categories[cat] ?? 0) + 1;
      }
      
      return {
        'total': articles.length,
        'published': published,
        'drafts': drafts,
        'featured': featured,
        'breaking': breaking,
        'categories': categories.length,
      };
    } catch (e) {
      debugPrint('❌ AdminNewsService.getStats error: $e');
      return {
        'total': 0,
        'published': 0,
        'drafts': 0,
        'featured': 0,
        'breaking': 0,
        'categories': 0,
      };
    }
  }

  // ============================================================
  // MÉTHODES UTILITAIRES
  // ============================================================

  String _getPublicUrl(String bucket, String path) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  // ✅ NOUVELLE MÉTHODE: Vérifier si un article existe
  Future<bool> newsExists(String id) async {
    try {
      final res = await _client
          .from(table)
          .select('id')
          .eq('id', id)
          .maybeSingle();
      return res != null;
    } catch (e) {
      debugPrint('❌ AdminNewsService.newsExists error: $e');
      return false;
    }
  }

  // ✅ NOUVELLE MÉTHODE: Dupliquer un article
  Future<String> duplicateNews(String id) async {
    final original = await getNewsById(id);
    if (original == null) {
      throw Exception('Article original introuvable');
    }
    
    final newTitle = '${original['title']} (Copie)';
    
    return await upsertNews(
      title: newTitle,
      summary: original['summary'],
      category: original['category'],
      content: original['content'],
      source: original['source'],
      severity: original['severity'],
      status: 'draft', // Mettre en brouillon par défaut
    );
  }

  // ✅ NOUVELLE MÉTHODE: Incrémenter les vues
  Future<void> incrementViews(String id) async {
    try {
      final article = await getNewsById(id);
      if (article != null) {
        final currentViews = article['views_count'] as int? ?? 0;
        await _client.from(table).update({
          'views_count': currentViews + 1,
        }).eq('id', id);
      }
    } catch (e) {
      debugPrint('❌ AdminNewsService.incrementViews error: $e');
    }
  }

  // ✅ NOUVELLE MÉTHODE: Vérifier la connexion
  Future<bool> checkConnection() async {
    try {
      await _client.from(table).select('id').limit(1);
      return true;
    } catch (e) {
      debugPrint('❌ AdminNewsService.checkConnection error: $e');
      return false;
    }
  }
}
