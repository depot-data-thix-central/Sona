class NewsArticle {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final String? summary;
  final String? category;
  final bool isPublished;
  final bool isFeatured;
  final bool isBreaking;
  final bool isLiked;
  final bool isSaved;
  final int viewsCount;
  final DateTime? publishedAt;
  final Map<String, dynamic> raw;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    this.summary,
    this.category,
    this.isPublished = false,
    this.isFeatured = false,
    this.isBreaking = false,
    this.isLiked = false,
    this.isSaved = false,
    this.viewsCount = 0,
    this.publishedAt,
    this.raw = const {},
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      imageUrl: json['image_url']?.toString(),
      videoUrl: json['video_url']?.toString(),
      summary: json['summary']?.toString(),
      category: json['category']?.toString(),
      isPublished: json['is_published'] == true,
      isFeatured: json['is_featured'] == true,
      isBreaking: json['is_breaking'] == true,
      isLiked: json['is_liked'] == true,
      isSaved: json['is_saved'] == true,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      publishedAt: json['published_at'] is String
          ? DateTime.tryParse(json['published_at'] as String)
          : null,
      raw: Map<String, dynamic>.from(json),
    );
  }

  String get status {
    if (isPublished) return 'published';
    return 'draft';
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'summary': summary,
      'category': category,
      'is_published': isPublished,
      'is_featured': isFeatured,
      'is_breaking': isBreaking,
      'is_liked': isLiked,
      'is_saved': isSaved,
      'views_count': viewsCount,
      'published_at': publishedAt?.toIso8601String(),
    });
}
