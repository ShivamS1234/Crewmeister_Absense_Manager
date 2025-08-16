import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/absence.dart';
import '../models/member.dart';

class DataService {

  Future<List<Absence>> loadAbsences() async {
    try {
      final String absencesString = await rootBundle.loadString(
        'assets/absences.json',
      );
      final List<dynamic> absencesJson = jsonDecode(absencesString)['payload'];

      final String membersString = await rootBundle.loadString(
        'assets/members.json',
      );
      final List<dynamic> membersJson = jsonDecode(membersString)['payload'];

      final List<Member> members = membersJson
 .map((json) => Member.fromJson(json))
          .toList();
      final Map<String, Member> memberMap = {
 for (var member in members) member.userId.toString(): member,
      };

      final List<Absence> absences = absencesJson.map((json) {
        final absence = Absence.fromJson(json);
 final member = memberMap[absence.userId.toString()];
 absence.member = member; // Assign the found member to the Absence object
        return absence;
      }).toList();
      return absences;
    } catch (e) {
      print('Error loading data: $e');
      rethrow; // Re-throw the error to be handled by the calling code (e.g., in the Riverpod provider)
    }
  }

 // You might want a separate method to get members if needed elsewhere
  Future<List<Member>> loadMembers() async {
    try {
      final String membersString = await rootBundle.loadString(
        'assets/json/members.json',
      );
      final List<dynamic> membersJson = jsonDecode(membersString)['payload'];
 final List<Member> members = membersJson.map((json) => Member.fromJson(json)).toList();
      return members;
    } catch (e) {
      print('Error loading members: $e');
      rethrow;
    }
  }
}
