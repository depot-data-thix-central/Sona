class Event {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? address;
  final String? organizerName;
  final String? contactPhone;
  final String? location;
  final String? city;
  final String? category;
  final String status;
  final double price;
  final int capacity;
  final int likesCount;
  final int remainingTickets;
  final bool isFeatured;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isLiked;
  final bool isSaved;
  final int viewsCount;
  final Map<String, dynamic> raw;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.address,
    this.organizerName,
    this.contactPhone,
    this.location,
    this.city,
    this.category,
    this.status = '',
    this.price = 0,
    this.capacity = 0,
    this.likesCount = 0,
    this.remainingTickets = 0,
    this.isFeatured = false,
    this.startDate,
    this.endDate,
    this.isLiked = false,
    this.isSaved = false,
    this.viewsCount = 0,
    this.raw = const {},
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
      return null;
    }

    return Event(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: json['image_url']?.toString(),
      address: json['address']?.toString(),
      organizerName: json['organizer_name']?.toString(),
      contactPhone: json['contact_phone']?.toString(),
      location: json['location']?.toString(),
      city: json['city']?.toString(),
      category: json['category']?.toString(),
      status: (json['status'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      remainingTickets: (json['remaining_tickets'] as num?)?.toInt() ?? 0,
      isFeatured: json['is_featured'] == true,
      startDate: parseDate(json['start_date']),
      endDate: parseDate(json['end_date']),
      isLiked: json['is_liked'] == true,
      isSaved: json['is_saved'] == true,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      raw: Map<String, dynamic>.from(json),
    );
  }

  bool get isFree => price <= 0;
  bool get isUpcoming => startDate != null && startDate!.isAfter(DateTime.now());
  bool get isPastEvent => endDate != null && endDate!.isBefore(DateTime.now());
  String get shortDate {
    final d = startDate;
    if (d == null) return '';
    return '${d.day}/${d.month}';
  }

  String get formattedDate {
    final d = startDate;
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String get timeRange {
    final s = startDate;
    if (s == null) return '';
    final e = endDate;
    String fmt(DateTime dt) => '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return e == null ? fmt(s) : '${fmt(s)} - ${fmt(e)}';
  }

  String get formattedPrice => isFree ? 'Gratuit' : '${price.toStringAsFixed(0)} FCFA';

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'address': address,
      'organizer_name': organizerName,
      'contact_phone': contactPhone,
      'location': location,
      'city': city,
      'category': category,
      'status': status,
      'price': price,
      'capacity': capacity,
      'likes_count': likesCount,
      'remaining_tickets': remainingTickets,
      'is_featured': isFeatured,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_liked': isLiked,
      'is_saved': isSaved,
      'views_count': viewsCount,
    });
}

class EventBooking {
  final String id;
  final String eventId;
  final String userId;
  final int quantity;
  final String? eventTitle;
  final String? eventImageUrl;
  final String? eventLocation;
  final DateTime? eventDate;
  final String? ticketCode;
  final int ticketQuantity;
  final double totalPrice;
  final String? status;
  final Map<String, dynamic> raw;

  const EventBooking({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.quantity,
    this.eventTitle,
    this.eventImageUrl,
    this.eventLocation,
    this.eventDate,
    this.ticketCode,
    this.ticketQuantity = 0,
    this.totalPrice = 0,
    this.status,
    this.raw = const {},
  });

  factory EventBooking.fromJson(Map<String, dynamic> json) {
    return EventBooking(
      id: (json['id'] ?? '').toString(),
      eventId: (json['event_id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      eventTitle: json['event_title']?.toString(),
      eventImageUrl: json['event_image_url']?.toString(),
      eventLocation: json['event_location']?.toString(),
      eventDate: json['event_date'] is String
          ? DateTime.tryParse(json['event_date'] as String)
          : null,
      ticketCode: json['ticket_code']?.toString(),
      ticketQuantity: (json['ticket_quantity'] as num?)?.toInt() ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString(),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'event_id': eventId,
      'user_id': userId,
      'quantity': quantity,
      'event_title': eventTitle,
      'event_image_url': eventImageUrl,
      'event_location': eventLocation,
      'event_date': eventDate?.toIso8601String(),
      'ticket_code': ticketCode,
      'ticket_quantity': ticketQuantity,
      'total_price': totalPrice,
      'status': status,
    });
}
