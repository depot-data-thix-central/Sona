class TransactionModel {
  final String id;
  final double amount;
  final String? type;
  final String? reference;
  final DateTime? createdAt;
  final Map<String, dynamic> raw;

  const TransactionModel({
    required this.id,
    required this.amount,
    this.type,
    this.reference,
    this.createdAt,
    this.raw = const {},
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: (json['id'] ?? '').toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      type: json['type']?.toString(),
      reference: json['reference']?.toString(),
      createdAt: json['created_at'] is String
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'amount': amount,
      'type': type,
      'reference': reference,
      'created_at': createdAt?.toIso8601String(),
    });
}
