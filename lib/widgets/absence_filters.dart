import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/absence_state.dart';

class AbsenceFilters extends ConsumerWidget {
  const AbsenceFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(absenceTypeFilterProvider);
    final selectedDate = ref.watch(dateFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownButtonFormField<String?>(
            decoration: const InputDecoration(labelText: 'Filter by Type'),
            value: selectedType,
            items: const [
              DropdownMenuItem<String?>(
                value: null,
                child: Text('All Types'),
              ),
              DropdownMenuItem<String>(
                value: 'Vacation',
                child: Text('Vacation'),
              ),
              DropdownMenuItem<String>(
                value: 'Sickness',
                child: Text('Sickness'),
              ),
              // Add other absence types if needed
            ],
            onChanged: (value) {
              ref.read(absenceTypeFilterProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                ref.read(dateFilterProvider.notifier).state = pickedDate;
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Filter by Date',
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? 'Select Date'
                        : "${selectedDate.toLocal()}".split(' ')[0],
                  ),
                  if (selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ref.read(dateFilterProvider.notifier).state =
                            null;
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}