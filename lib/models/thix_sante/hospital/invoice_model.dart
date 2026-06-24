class InvoiceModel {
  final String id;
  final String? number;
  final String? patientId;
  final String? patientName;
  final String status;
  final double amount;
  final String? notes;
  final List<dynamic> items;
  final DateTime? date;
  final Map<String, dynamic> raw;

  class InvoiceModel {
    final String id;
    final String? number;
    final String? patientId;
    final String? patientName;
    final String status;
    final double amount;
    final String? notes;
    final List<dynamic> items;
    final DateTime? date;
    final Map<String, dynamic> raw;

    const InvoiceModel({
      required this.id,
      this.number,
      this.patientId,
      this.patientName,
      this.status = '',
      this.amount = 0,
      this.notes,
      this.items = const [],
      this.date,
      this.raw = const {},
    });

    factory InvoiceModel.fromJson(Map<String, dynamic> json) {
      final dateStr = json['date']?.toString() ?? json['created_at']?.toString();
      return InvoiceModel(
        id: (json['id'] ?? '').toString(),
        number: json['number']?.toString(),
        patientId: json['patient_id']?.toString(),
        patientName: json['patient_name']?.toString(),
        status: (json['status'] ?? '').toString(),
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        notes: json['notes']?.toString(),
        items: json['items'] is List ? List<dynamic>.from(json['items'] as List) : const [],
        date: dateStr != null && dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null,
        raw: Map<String, dynamic>.from(json),
      );
    }

    Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
      ..addAll({
        'id': id,
        'number': number,
        'patient_id': patientId,
        'patient_name': patientName,
        'status': status,
        'amount': amount,
        'notes': notes,
        'items': items,
        'date': date?.toIso8601String(),
      });
  }

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date']?.toString() ?? json['created_at']?.toString();
    return InvoiceModel(
      id: (json['id'] ?? '').toString(),
      number: json['number']?.toString(),
      patientId: json['patient_id']?.toString(),
      patientName: json['patient_name']?.toString(),
      status: (json['status'] ?? '').toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      notes: json['notes']?.toString(),
      items: json['items'] is List ? List<dynamic>.from(json['items'] as List) : const [],
      date: dateStr != null && dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null,
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'number': number,
      'patient_id': patientId,
      'patient_name': patientName,
      'status': status,
      'amount': amount,
      'notes': notes,
      'items': items,
      'date': date?.toIso8601String(),
    });
}
