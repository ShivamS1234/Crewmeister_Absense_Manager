class Member {
  final int id;
  final String name;
  final int crewId;
  final String image;
  final int userId;

  Member({
    required this.id,
    required this.name,
    required this.crewId,
    required this.image,
    required this.userId,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as int,
      name: json['name'] as String,
      crewId: json['crewId'] as int,
      image: json['image'] as String,
      userId: json['userId'] as int,
    );
  }
}
