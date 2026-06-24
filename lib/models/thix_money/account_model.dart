class AccountModel {
  final String id;
  final String? label;
  final String? currency;
  final double balance;
  final Map<String, dynamic> raw;

  const AccountModel({
    required this.id,
    this.label,
    this.currency,
    this.balance = 0,
    this.raw = const {},
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: (json['id'] ?? '').toString(),
      label: json['label']?.toString(),
      currency: json['currency']?.toString(),
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({'id': id, 'label': label, 'currency': currency, 'balance': balance});
}
