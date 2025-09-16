/// ViewModel: IOU List
///
/// Author: Lim Kai Zhe
/// Created: 14 Sep 2025
///
/// Responsibilities:
/// - Load IOU entries from the domain layer via the [GetIOUs] use case.
/// - Expose async load state to the UI as [AsyncValue<List<IOUEntry>>].
/// - Provide computed, presentation-friendly totals (grouped by currency).
///
/// Design notes:
/// - Uses Riverpod's `AsyncNotifier` pattern (no codegen required here).
/// - ViewModel stays thin: it orchestrates use-case calls and maps domain
///   objects to values convenient for the UI. Domain invariants remain in
///   domain layer.
/// - Totals are grouped by currency to avoid mixing currencies.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_expense_tracker/features/iou/domain/domain.dart';
import 'package:the_expense_tracker/features/iou/ui/providers.dart';

/// AsyncNotifier that holds the IOU entries list.
///
/// - `state` is an [AsyncValue<List<IOUEntry>>], which the UI can watch.
/// - Use [refresh] to force reload.
/// - Use [totalsByCurrency] to get aggregated totals per currency.
class IOUListViewModel extends AsyncNotifier<List<IOUEntry>> {
  IOUListViewModel();

  /// Called by Riverpod when the provider is first read.
  /// Loads the IOUs via the GetIOUs use case.
  @override
  Future<List<IOUEntry>> build() async {
    final getIOUs = ref.read(getIOUsProvider);
    // Guard: ensure we return an empty list instead of null in all cases.
    final entries = await getIOUs.execute();
    return entries;
  }

  /// Force a refresh of the list.
  /// Sets state to loading and re-fetches via the use case.
  Future<void> refresh() async {
    state = const AsyncLoading();
    final getIOUs = ref.read(getIOUsProvider);
    state = await AsyncValue.guard(() => getIOUs.execute());
  }

  /// Convenience accessor to the current AsyncValue for UI usage.
  AsyncValue<List<IOUEntry>> get entries => state;

  /// Aggregate totals grouped by currency.
  ///
  /// Returns a map where the key is the ISO currency code (e.g. "MYR")
  /// and the value is a MoneyValue representing the summed cents for that currency.
  ///
  /// If the current state is loading or error, returns an empty map.
  Map<String, MoneyValue> get totalsByCurrency {
    return state.maybeWhen(
      data: (entries) {
        final Map<String, int> centsByCurrency = {};
        for (final e in entries) {
          final currency = e.amount.currency;
          centsByCurrency[currency] =
              (centsByCurrency[currency] ?? 0) + e.amount.cents;
        }
        // Convert to MoneyValue map
        return centsByCurrency.map(
          (currency, cents) => MapEntry(currency, MoneyValue(cents, currency)),
        );
      },
      orElse: () => <String, MoneyValue>{},
    );
  }

  /// Convenience helper: total for a specific currency (returns null if absent).
  MoneyValue? totalForCurrency(String currency) {
    final key = currency.trim().toUpperCase();
    return totalsByCurrency[key];
  }
}

/// Provider exposing the IOUListViewModel as an AsyncNotifierProvider.
/// Widgets should `ref.watch(iouListViewModelProvider)` to observe state.
final iouListViewModelProvider =
    AsyncNotifierProvider<IOUListViewModel, List<IOUEntry>>(
      () => IOUListViewModel(),
    );
