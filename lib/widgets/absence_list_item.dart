import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/absence.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsenceListItem extends StatelessWidget {
  final Absence absence;

  const AbsenceListItem({Key? key, required this.absence}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This function will generate an iCal content string for the absence
    void generateICAL() async {
      final String icalContent =
          '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Absence Manager//EN
BEGIN:VEVENT
DTSTAMP:${DateFormat("yyyyMMdd'T'HHmmss'Z'").format(DateTime.now().toUtc())}
UID:${absence.id}@absencemanager.com
DTSTART:${DateFormat("yyyyMMdd").format(absence.startDate)}
DTEND:${DateFormat("yyyyMMdd").format(absence.endDate.add(const Duration(days: 1)))}
SUMMARY:${absence.member?.name ?? 'Absence'} - ${absence.type}
DESCRIPTION:Status: ${absence.status}\\nMember Note: ${absence.memberNote ?? 'N/A'}\\nAdmitter Note: ${absence.admitterNote ?? 'N/A'}
END:VEVENT
END:VCALENDAR''';

      // Encode the iCal content for a data URL
      final String encodedIcalContent = Uri.encodeComponent(icalContent);
      final String dataUrl =
          'data:text/calendar;charset=utf-8,$encodedIcalContent';

      try {
        if (await canLaunch(dataUrl)) {
          await launch(dataUrl);
        } else {
          throw 'Could not launch $dataUrl';
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error launching iCal data URL: $e');
      }
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String period =
        '${formatter.format(absence.startDate)} to ${formatter.format(absence.endDate)}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Member: ${absence.member?.name ?? 'N/A'}', // Assuming memberName is added to Absence model
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text('Type: ${absence.type}'),
                      const SizedBox(height: 4.0),
                      Text('Period: $period'),
                      const SizedBox(height: 4.0),
                      Text('Status: ${absence.status}'),
                      if (absence.memberNote != null &&
                          absence.memberNote!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('Member Note: ${absence.memberNote}'),
                        ),
                      absence.admitterNote != null &&
                              absence.admitterNote!.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Admitter Note: ${absence.admitterNote}',
                              ),
                            )
                          : Text(
                              'Member: ${absence.member?.name ?? 'N/A'}', // Access member name from the associated Member object
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const SizedBox(height: 4.0),
                      Text('Type: ${absence.type}'),
                      const SizedBox(height: 4.0),
                      Text('Period: $period'),
                      const SizedBox(height: 4.0),
                      Text('Status: ${absence.status}'),
                      if (absence.memberNote != null &&
                          absence.memberNote!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('Member Note: ${absence.memberNote}'),
                        ),
                      if (absence.admitterNote != null &&
                          absence.admitterNote!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('Admitter Note: ${absence.admitterNote}'),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: generateICAL,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
