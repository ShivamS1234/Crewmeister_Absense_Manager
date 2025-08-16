import 'package:myapp/models/member.dart';

class Absence {
  final int id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String? memberNote;
  final String status;
  final String? admitterId;
  final String? admitterNote;
  Member? member; // Add this field to store the associated Member object
  final DateTime? confirmedAt;
  final DateTime createdAt;
  final int crewId;
  final DateTime? rejectedAt;

  Absence({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.memberNote,
    this.member, // Add this to the constructor
    required this.status,
    this.admitterId,
    this.admitterNote,
    this.confirmedAt,
    required this.createdAt,
    required this.crewId,
    this.rejectedAt,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'] as int,
      userId: json['userId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      type: json['type'] as String,
      memberNote: json['memberNote'] as String?,
      status: json['status'] as String,
      admitterId: json['admitterId'] as String?,
      admitterNote: json['admitterNote'] as String?,
      // member: null, // We will link the member in the DataService
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      crewId: json['crewId'] as int,
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.parse(json['rejectedAt'] as String)
          : null,
    );
  }
}
