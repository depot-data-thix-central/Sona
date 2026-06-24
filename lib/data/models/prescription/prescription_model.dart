class PrescriptionModel {
  final String id;
  final Map<String, dynamic> raw;

  const PrescriptionModel({required this.id, this.raw = const {}});

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(id: (json['id'] ?? '').toString(), raw: Map<String, dynamic>.from(json));
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)..addAll({'id': id});
}
