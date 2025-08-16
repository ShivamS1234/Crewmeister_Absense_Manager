import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/services/data_service.dart'; // Replace 'myapp' with your project name

import 'data_service_test.mocks.dart'; // Generated mock file

@GenerateMocks([AssetBundle])
void main() {
  group('DataService', () {
    late MockAssetBundle mockAssetBundle;
    late DataService dataService;

    setUp(() {
      mockAssetBundle = MockAssetBundle();
      dataService = DataService();
    });

    test('loadAbsences should load and parse data correctly', () async {
      // Mock data for absences and members
      const absencesJson = '''
        [
          {
            "id": "1",
            "userId": "user1",
            "startDate": "2023-10-26",
            "endDate": "2023-10-28",
            "type": "Vacation",
            "memberNote": "Family trip",
            "status": "Confirmed",
            "admitterId": "admin1",
            "admitterNote": "Approved"
          },
          {
            "id": "2",
            "userId": "user2",
            "startDate": "2023-11-01",
            "endDate": "2023-11-01",
            "type": "Sickness",
            "memberNote": null,
            "status": "Requested",
            "admitterId": null,
            "admitterNote": null
          }
        ]
      ''';

      const membersJson = '''
        [
          {"id": "user1", "name": "John Doe"},
          {"id": "user2", "name": "Jane Smith"}
        ]
      ''';

      // Stub the loadString method of the mock AssetBundle
      when(
        mockAssetBundle.loadString('assets/absences.json'),
      ).thenAnswer((_) async => absencesJson);
      when(
        mockAssetBundle.loadString('assets/members.json'),
      ).thenAnswer((_) async => membersJson);

      final absences = await dataService.loadAbsences();

      expect(absences.length, 2);

      // Test the first absence
      expect(absences[0].id, '1');
      expect(absences[0].userId, 'user1');
      expect(absences[0].startDate, DateTime.parse('2023-10-26'));
      expect(absences[0].endDate, DateTime.parse('2023-10-28'));
      expect(absences[0].type, 'Vacation');
      expect(absences[0].memberNote, 'Family trip');
      expect(absences[0].status, 'Confirmed');
      expect(absences[0].admitterId, 'admin1');
      expect(absences[0].admitterNote, 'Approved');
      expect(
        absences[0].member?.name,
        'John Doe',
      ); // Check if member name is matched

      // Test the second absence
      expect(absences[1].id, '2');
      expect(absences[1].userId, 'user2');
      expect(absences[1].startDate, DateTime.parse('2023-11-01'));
      expect(absences[1].endDate, DateTime.parse('2023-11-01'));
      expect(absences[1].type, 'Sickness');
      expect(absences[1].memberNote, null);
      expect(absences[1].status, 'Requested');
      expect(absences[1].admitterId, null);
      expect(absences[1].admitterNote, null);
      expect(
        absences[1].member?.name,
        'Jane Smith',
      ); // Check if member name is matched
    });

    test('loadAbsences should handle missing member data', () async {
      const absencesJson = '''
        [
          {
            "id": "1",
            "userId": "user1",
            "startDate": "2023-10-26",
            "endDate": "2023-10-28",
            "type": "Vacation",
            "memberNote": null,
            "status": "Confirmed",
            "admitterId": null,
            "admitterNote": null
          },
          {
            "id": "2",
            "userId": "user_missing",
            "startDate": "2023-11-01",
            "endDate": "2023-11-01",
            "type": "Sickness",
            "memberNote": null,
            "status": "Requested",
            "admitterId": null,
            "admitterNote": null
          }
        ]
      ''';

      const membersJson = '''
        [
          {"id": "user1", "name": "John Doe"}
        ]
      ''';

      when(
        mockAssetBundle.loadString('assets/absences.json'),
      ).thenAnswer((_) async => absencesJson);
      when(
        mockAssetBundle.loadString('assets/members.json'),
      ).thenAnswer((_) async => membersJson);

      final absences = await dataService.loadAbsences();

      expect(absences.length, 2);
      expect(absences[0].member?.name, 'John Doe');
      expect(
        absences[1].member?.name,
        'Unknown Member',
      ); // Should handle missing member
    });

    test('loadAbsences should throw an exception on invalid JSON', () async {
      const invalidJson = '''
        [
          {
            "id": "1",
            "userId": "user1",
            "startDate": "2023-10-26",
            "endDate": "2023-10-28",
            "type": "Vacation",
            "memberNote": "Family trip",
            "status": "Confirmed",
            "admitterId": "admin1",
            "admitterNote": "Approved"
          }
      '''; // Missing closing bracket

      const membersJson = '''
        [
          {"id": "user1", "name": "John Doe"}
        ]
      ''';

      when(
        mockAssetBundle.loadString('assets/absences.json'),
      ).thenAnswer((_) async => invalidJson);
      when(
        mockAssetBundle.loadString('assets/members.json'),
      ).thenAnswer((_) async => membersJson);

      expect(() => dataService.loadAbsences(), throwsA(isA<FormatException>()));
    });

    test('loadAbsences should throw an exception on missing files', () async {
      when(
        mockAssetBundle.loadString('assets/absences.json'),
      ).thenThrow(FlutterError('Unable to load asset'));
      when(
        mockAssetBundle.loadString('assets/members.json'),
      ).thenAnswer((_) async => '[]'); // Return empty list for members

      expect(() => dataService.loadAbsences(), throwsA(isA<FlutterError>()));
    });
  });
}
