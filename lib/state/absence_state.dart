import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/absence.dart';
import '../services/data_service.dart';

/// Provider for the DataService.
final dataServiceProvider = Provider<DataService>((ref) {
  return DataService();
});

/// FutureProvider that loads the list of absences from the DataService.
final absencesProvider = FutureProvider<List<Absence>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.loadAbsences();
});

/// StateProvider for the current page number (1-based).
final currentPageProvider = StateProvider<int>((ref) => 1);

final itemsPerPageProvider = Provider<int>((ref) => 10);

/// StateProvider for the absence type filter.
final absenceTypeFilterProvider = StateProvider<String?>((ref) => null);

/// StateProvider for the date filter.
final dateFilterProvider = StateProvider<DateTime?>((ref) => null);

/// Provider that returns a filtered list of absences based on the selected type and date.
final filteredAbsencesProvider = Provider<AsyncValue<List<Absence>>>((ref) {
  final absencesAsyncValue = ref.watch(absencesProvider);
  final selectedType = ref.watch(absenceTypeFilterProvider);
  final selectedDate = ref.watch(dateFilterProvider);

  return absencesAsyncValue
      .whenData((absences) {
        if (selectedType == null && selectedDate == null) {
          return absences;
        }

        return absences.where((absence) {
          bool typeMatch = selectedType == null || absence.type == selectedType;
          bool dateMatch =
              selectedDate == null ||
              (absence.startDate.isBefore(
                    selectedDate.add(const Duration(days: 1)),
                  ) &&
                  absence.endDate.isAfter(
                    selectedDate.subtract(const Duration(days: 1)),
                  ));

          return typeMatch && dateMatch;
        }).toList();
      })
      .when(
        data: (absences) {
          final currentPage = ref.watch(currentPageProvider);
          final itemsPerPage = ref.watch(itemsPerPageProvider);
          final startIndex = (currentPage - 1) * itemsPerPage;
          final endIndex = startIndex + itemsPerPage;
          return AsyncValue.data(
            absences.sublist(startIndex, endIndex.clamp(0, absences.length)),
          );
        },
        loading: () => AsyncValue.loading(),
        error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
      );
});

/// Provider that returns the total number of filtered absences.
final totalFilteredAbsencesProvider = Provider<AsyncValue<int>>((ref) {
  final filteredAbsencesAsyncValue = ref.watch(filteredAbsencesProvider);
  return filteredAbsencesAsyncValue.whenData((absences) => absences.length);
});
