import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/models/absence.dart';
import 'package:myapp/models/member.dart';

void main() {
  group('Absence Model Tests', () {
    test('Should create an Absence object from valid JSON', () {
      final json = {
        "id": "1",
        "userId": "123",
        "startDate": "2023-01-15T10:00:00.000Z",
        "endDate": "2023-01-20T17:00:00.000Z",
        "type": "Vacation",
        "memberNote": "Going on a trip",
        "status": "Requested",
        "admitterId": "456",
        "admitterNote": "Looks good"
      };

      final absence = Absence.fromJson(json);

      expect(absence.id, '1');
      expect(absence.userId, '123');
      expect(absence.startDate, DateTime.parse("2023-01-15T10:00:00.000Z"));
      expect(absence.endDate, DateTime.parse("2023-01-20T17:00:00.000Z"));
      expect(absence.type, 'Vacation');
      expect(absence.memberNote, 'Going on a trip');
      expect(absence.status, 'Requested');
      expect(absence.admitterId, '456');
      expect(absence.admitterNote, 'Looks good');
    });

    test('Should handle nullable fields correctly in Absence object', () {
      final json = {
        "id": "2",
        "userId": "789",
        "startDate": "2023-02-01T09:00:00.000Z",
        "endDate": "2023-02-01T17:00:00.000Z",
        "type": "Sickness",
        "status": "Confirmed",
      };

      final absence = Absence.fromJson(json);

      expect(absence.id, '2');
      expect(absence.userId, '789');
      expect(absence.startDate, DateTime.parse("2023-02-01T09:00:00.000Z"));
      expect(absence.endDate, DateTime.parse("2023-02-01T17:00:00.000Z"));
      expect(absence.type, 'Sickness');
      expect(absence.memberNote, isNull);
      expect(absence.status, 'Confirmed');
      expect(absence.admitterId, isNull);
      expect(absence.admitterNote, isNull);
    });
  });

  group('Member Model Tests', () {
    test('Should create a Member object from valid JSON', () {
      final json = {
        "id": "123",
        "name": "John Doe",
      };

      final member = Member.fromJson(json);

      expect(member.id, '123');
      expect(member.name, 'John Doe');
    });
  });
}