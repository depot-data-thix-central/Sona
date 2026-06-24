class StaffModel {
  final String id;
  final String fullName;
  final String role;
  final String status;
  final String? specialty;
  final String? service;
  final String? email;
  final String? phoneNumber;
  final String? registrationNumber;
  final Map<String, dynamic> raw;

  const StaffModel({
    required this.id,
    this.fullName = '',
    this.role = '',
    this.status = '',
    this.specialty,
    this.service,
    this.email,
    this.phoneNumber,
    this.registrationNumber,
    this.raw = const {},
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['full_name'] ?? json['name'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      specialty: json['specialty']?.toString(),
      service: json['service']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      registrationNumber: json['registration_number']?.toString(),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'full_name': fullName,
      'role': role,
      'status': status,
      'specialty': specialty,
      'service': service,
      'email': email,
      'phone_number': phoneNumber,
      'registration_number': registrationNumber,
    });
}
