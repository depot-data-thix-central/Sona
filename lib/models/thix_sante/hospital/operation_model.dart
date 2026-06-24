class OperationModel {
  final String id;
  final String? type;
  final String? status;
  final String? patientName;
  final String? surgeonName;
  final String? room;
  final DateTime? scheduledDate;
  final Map<String, dynamic> raw;

  class OperationModel {
    final String id;
    final String? type;
    final String? status;
    final String? patientName;
    final String? surgeonName;
    final String? room;
    final DateTime? scheduledDate;
    final Map<String, dynamic> raw;

    const OperationModel({
      required this.id,
      this.type,
      this.status,
      this.patientName,
      this.surgeonName,
      this.room,
      this.scheduledDate,
      this.raw = const {},
    });

    factory OperationModel.fromJson(Map<String, dynamic> json) {
      return OperationModel(
        id: (json['id'] ?? '').toString(),
        type: json['type']?.toString(),
        status: json['status']?.toString(),
        patientName: json['patient_name']?.toString(),
        surgeonName: json['surgeon_name']?.toString(),
        room: json['room']?.toString(),
        scheduledDate: json['scheduled_date'] is String
            ? DateTime.tryParse(json['scheduled_date'] as String)
            : null,
        raw: Map<String, dynamic>.from(json),
      );
    }

    Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
      ..addAll({
        'id': id,
        'type': type,
        'status': status,
        'patient_name': patientName,
        'surgeon_name': surgeonName,
        'room': room,
        'scheduled_date': scheduledDate?.toIso8601String(),
      });
  }
    return OperationModel(
      id: (json['id'] ?? '').toString(),
      type: json['type']?.toString(),
      status: json['status']?.toString(),
      patientName: json['patient_name']?.toString(),
      surgeonName: json['surgeon_name']?.toString(),
      room: json['room']?.toString(),
      scheduledDate: json['scheduled_date'] is String
          ? DateTime.tryParse(json['scheduled_date'] as String)
          : null,
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(raw)
    ..addAll({
      'id': id,
      'type': type,
      'status': status,
      'patient_name': patientName,
      'surgeon_name': surgeonName,
      'room': room,
      'scheduled_date': scheduledDate?.toIso8601String(),
    });
}
