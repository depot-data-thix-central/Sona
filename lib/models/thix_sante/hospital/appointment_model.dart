class AppointmentModel {
  final String id;
  final DateTime? date;
  final String? time;
  final String status;
  final String? patientName;
  final String? doctorName;
  final String? specialty;
  final String? notes;
  final Map<String, dynamic> raw;

  const AppointmentModel({
    required this.id,
    this.date,
    this.time,
    this.status = '',
    this.patientName,
    this.doctorName,
    this.specialty,
    this.notes,
    this.raw = const {},
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date']?.toString() ?? json['appointment_date']?.toString();
    return AppointmentModel(
      id: (json['id'] ?? '').toString(),
      date: dateStr != null && dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null,
      time: json['time']?.toString(),
      status: (json['status'] ?? '').toString(),
      patientName: json['patient_name']?.toString(),
      doctorName: json['doctor_name']?.toString(),
      specialty: json['specialty']?.toString(),
      notes: json['notes']?.toString(),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'date': date?.toIso8601String(),
      'time': time,
      'status': status,
      'patient_name': patientName,
      'doctor_name': doctorName,
      'specialty': specialty,
      'notes': notes,
    });
}
