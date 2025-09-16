/// ViewModel: IOU Detail
///
/// Author: Lim Kai Zhe
/// Created: 14 Sep 2025
///
/// Responsibilities:
/// - Fetch a single IOU entry by ID using [GetIOUById] use case.
/// - Expose state as [AsyncValue<IOUEntry?>] for the UI.
/// - Acts as a thin orchestration layer between domain and presentation.
/// - Future-proof: ready to support edit/remove operations.
///
/// Design notes:
/// - Extends [AutoDisposeFamilyAsyncNotifier] with [String] as parameter.
/// - Family provider: `iouDetailViewModelProvider(id)`.
/// - Keeps business logic in domain; only orchestrates use case calls here.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_expense_tracker/features/iou/domain/domain.dart';
import 'package:the_expense_tracker/features/iou/ui/providers.dart';

/// AsyncNotifier for a single IOU entry.
///
/// - Parameter: [id] passed at provider creation.
/// - Exposes [AsyncValue<IOUEntry?>].
/// - Returns `null` if entry not found.
class IOUDetailViewModel
    extends AutoDisposeFamilyAsyncNotifier<IOUEntry?, String> {
  @override
  Future<IOUEntry?> build(String id) async {
    if (id.trim().isEmpty) {
      return Future.error(ArgumentError("ID must not be empty"));
    }

    final getById = ref.read(getIOUByIdProvider);
    final entry = await getById.execute(id);
    return entry; // may be null if not found
  }

  /// Reloads the IOU entry by ID.
  Future<void> refresh() async {
    state = const AsyncLoading();
    final getById = ref.read(getIOUByIdProvider);
    state = await AsyncValue.guard(() => getById.execute(arg));
  }
}

/// Family provider for IOU detail.
///
/// Usage:
/// ```dart
/// final detail = ref.watch(iouDetailViewModelProvider(entryId));
/// ```
final iouDetailViewModelProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      IOUDetailViewModel,
      IOUEntry?,
      String
    >(IOUDetailViewModel.new);
