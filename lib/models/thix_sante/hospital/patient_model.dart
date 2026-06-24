class PatientModel {
  final String id;
  final String fullName;
  final String name;
  final String? email;
  final String? phone;
  final String? phoneNumber;
  final String? status;
  final String? hospitalId;
  final String? thixId;
  final String? gender;
  final String? bloodType;
  final String? address;
  final String? allergies;
  final String? emergencyContact;
  final String? medicalHistory;
  final DateTime? birthDate;
  final Map<String, dynamic> raw;

  const PatientModel({
    required this.id,
    this.fullName = '',
    this.name = '',
    this.email,
    this.phone,
    this.phoneNumber,
    this.status,
    this.hospitalId,
    this.thixId,
    this.gender,
    this.bloodType,
    this.address,
    this.allergies,
    this.emergencyContact,
    this.medicalHistory,
    this.birthDate,
    this.raw = const {},
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
      return null;
    }

    final full = (json['full_name'] ?? json['name'] ?? '').toString();
    return PatientModel(
      id: (json['id'] ?? '').toString(),
      fullName: full,
      name: full,
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      phoneNumber: json['phone_number']?.toString() ?? json['phone']?.toString(),
      status: json['status']?.toString(),
      hospitalId: json['hospital_id']?.toString(),
      thixId: json['thix_id']?.toString(),
      gender: json['gender']?.toString(),
      bloodType: json['blood_type']?.toString(),
      address: json['address']?.toString(),
      allergies: json['allergies']?.toString(),
      emergencyContact: json['emergency_contact']?.toString(),
      medicalHistory: json['medical_history']?.toString(),
      birthDate: parseDate(json['birth_date']),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'full_name': fullName,
      'name': name,
      'email': email,
      'phone': phone,
      'phone_number': phoneNumber,
      'status': status,
      'hospital_id': hospitalId,
      'thix_id': thixId,
      'gender': gender,
      'blood_type': bloodType,
      'address': address,
      'allergies': allergies,
      'emergency_contact': emergencyContact,
      'medical_history': medicalHistory,
      'birth_date': birthDate?.toIso8601String(),
    });
}
