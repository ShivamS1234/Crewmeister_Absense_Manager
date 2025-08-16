import 'package:myapp/models/member.dart';

class Absence {
  final int id;
  final int userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String type;
  final String? memberNote;
  // final String status;
  final int? admitterId;
  final String? admitterNote;
  Member? member;
  final DateTime? confirmedAt;
  final String? image;
  final String? rejectionReason;
  final DateTime createdAt;
  final int crewId;
  final DateTime? rejectedAt;

  Absence({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    required this.type,
    this.memberNote,
    this.member,
    // required this.status,
    this.admitterId,
    this.admitterNote,
    this.image,
    this.confirmedAt,
    this.rejectionReason,
    required this.createdAt,
    required this.crewId,
    this.rejectedAt,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'] as int,
      userId: json['userId'] as int,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      type: json['type'] as String,
      memberNote: json['memberNote'] as String?,
      // status: json['status'] as String,
      admitterId: json['admitterId'] as int?,
      admitterNote: json['admitterNote'] as String?,
      // member: null, // We will link the member in the DataService
      image: json['image'] as String?,
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
