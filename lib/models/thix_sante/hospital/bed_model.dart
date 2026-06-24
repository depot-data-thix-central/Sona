class BedModel {
  final String id;
  final String number;
  final String roomNumber;
  final String ward;
  final String service;
  final String status;
  final String? patientId;
  final String? patientName;
  final Map<String, dynamic> raw;

  const BedModel({
    required this.id,
    this.number = '',
    this.roomNumber = '',
    this.ward = '',
    this.service = '',
    this.status = '',
    this.patientId,
    this.patientName,
    this.raw = const {},
  });

  factory BedModel.fromJson(Map<String, dynamic> json) {
    return BedModel(
      id: (json['id'] ?? '').toString(),
      number: (json['number'] ?? json['bed_number'] ?? '').toString(),
      roomNumber: (json['room_number'] ?? '').toString(),
      ward: (json['ward'] ?? '').toString(),
      service: (json['service'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      patientId: json['patient_id']?.toString(),
      patientName: json['patient_name']?.toString(),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'number': number,
      'room_number': roomNumber,
      'ward': ward,
      'service': service,
      'status': status,
      'patient_id': patientId,
      'patient_name': patientName,
    });
}
