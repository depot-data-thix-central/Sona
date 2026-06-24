class ExamModel {
  final String id;
  final String? patientId;
  final String? patientName;
  final String? doctorName;
  final String? type;
  final String? priority;
  final String? status;
  final String? notes;
  final String? result;
  final String? referenceRange;
  final bool isAbnormal;
  final DateTime? date;
  final Map<String, dynamic> raw;

  class ExamModel {
    final String id;
    final String? patientId;
    final String? patientName;
    final String? doctorName;
    final String? type;
    final String? priority;
    final String? status;
    final String? notes;
    final String? result;
    final String? referenceRange;
    final bool isAbnormal;
    final DateTime? date;
    final Map<String, dynamic> raw;

    const ExamModel({
      required this.id,
      this.patientId,
      this.patientName,
      this.doctorName,
      this.type,
      this.priority,
      this.status,
      this.notes,
      this.result,
      this.referenceRange,
      this.isAbnormal = false,
      this.date,
      this.raw = const {},
    });

    factory ExamModel.fromJson(Map<String, dynamic> json) {
      return ExamModel(
        id: (json['id'] ?? '').toString(),
        patientId: json['patient_id']?.toString(),
        patientName: json['patient_name']?.toString(),
        doctorName: json['doctor_name']?.toString(),
        type: json['type']?.toString(),
        priority: json['priority']?.toString(),
        status: json['status']?.toString(),
        notes: json['notes']?.toString(),
        result: json['result']?.toString(),
        referenceRange: json['reference_range']?.toString(),
        isAbnormal: json['is_abnormal'] == true,
        date: json['date'] is String ? DateTime.tryParse(json['date'] as String) : null,
        raw: Map<String, dynamic>.from(json),
      );
    }

    Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
      ..addAll({
        'id': id,
        'patient_id': patientId,
        'patient_name': patientName,
        'doctor_name': doctorName,
        'type': type,
        'priority': priority,
        'status': status,
        'notes': notes,
        'result': result,
        'reference_range': referenceRange,
        'is_abnormal': isAbnormal,
        'date': date?.toIso8601String(),
      });
  }
    this.date,
    this.raw = const {},
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: (json['id'] ?? '').toString(),
      patientId: json['patient_id']?.toString(),
      patientName: json['patient_name']?.toString(),
      doctorName: json['doctor_name']?.toString(),
      type: json['type']?.toString(),
      priority: json['priority']?.toString(),
      status: json['status']?.toString(),
      notes: json['notes']?.toString(),
      result: json['result']?.toString(),
      referenceRange: json['reference_range']?.toString(),
      isAbnormal: json['is_abnormal'] == true,
      date: json['date'] is String ? DateTime.tryParse(json['date'] as String) : null,
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'patient_id': patientId,
      'patient_name': patientName,
      'doctor_name': doctorName,
      'type': type,
      'priority': priority,
      'status': status,
      'notes': notes,
      'result': result,
      'reference_range': referenceRange,
      'is_abnormal': isAbnormal,
      'date': date?.toIso8601String(),
    });
}
