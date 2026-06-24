class MedicationModel {
  final String id;
  final String name;
  final String? dosage;
  final String? form;
  final String? status;
  final int quantity;
  final int threshold;
  final double? price;
  final String? frequency;
  final String? batchNumber;
  final DateTime? expiryDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<String, dynamic> raw;

  const MedicationModel({
    required this.id,
    this.name = '',
    this.dosage,
    this.form,
    this.status,
    this.quantity = 0,
    this.threshold = 0,
    this.price,
    this.frequency,
    this.batchNumber,
    this.expiryDate,
    this.startDate,
    this.endDate,
    this.raw = const {},
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
      return null;
    }

    return MedicationModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      dosage: json['dosage']?.toString(),
      form: json['form']?.toString(),
      status: json['status']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      threshold: (json['threshold'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble(),
      frequency: json['frequency']?.toString(),
      batchNumber: json['batch_number']?.toString(),
      expiryDate: parseDate(json['expiry_date']),
      startDate: parseDate(json['start_date']),
      endDate: parseDate(json['end_date']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'name': name,
      'dosage': dosage,
      'form': form,
      'status': status,
      'quantity': quantity,
      'threshold': threshold,
      'price': price,
      'frequency': frequency,
      'batch_number': batchNumber,
      'expiry_date': expiryDate?.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    });
}
