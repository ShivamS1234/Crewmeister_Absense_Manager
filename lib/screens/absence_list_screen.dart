import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/state/absence_state.dart';
import 'package:myapp/widgets/absence_list_item.dart';
import 'package:myapp/widgets/absence_filters.dart';

class AbsenceListScreen extends ConsumerWidget {
  const AbsenceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final absencesAsyncValue = ref.watch(filteredAbsencesProvider);
    final currentPage = ref.watch(currentPageProvider);
    final totalAbsences = ref.watch(totalFilteredAbsencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Absence Manager')),
      body: Column(
        children: [
          const AbsenceFilters(),
          absencesAsyncValue.when(
            loading: () => const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Expanded(
              child: Center(
                child: Text('Error loading absences: ${error.toString()}'),
              ),
            ),
            data: (absences) {
              if (absences.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text('No absences found with the selected filters.'),
                  ),
                );
              }

              final itemsPerPage = ref.watch(itemsPerPageProvider);
              final totalPages = ((totalAbsences.value ?? 0) / itemsPerPage)
                  .ceil();

              return Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total Absences: ${totalAbsences.value}'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: absences.length,
                        itemBuilder: (context, index) {
                          final absence = absences[index];
                          return AbsenceListItem(absence: absence);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: currentPage > 1
                                ? () => ref
                                      .read(currentPageProvider.notifier)
                                      .state--
                                : null,
                            child: const Text('Previous Page'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text('Page $currentPage of $totalPages'),
                          ),
                          ElevatedButton(
                            onPressed: currentPage < totalPages
                                ? () => ref
                                      .read(currentPageProvider.notifier)
                                      .state++
                                : null,
                            child: const Text('Next Page'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
