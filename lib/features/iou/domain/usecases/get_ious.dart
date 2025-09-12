/// Use case: Get all IOU entries.
///
/// Author: Lim Kai Zhe
/// Created: 6 Sep 2025
///
/// Responsibilities:
/// - Retrieve all [IOUEntry] records via repository.
/// - Wraps repository call for consistency and testability.
/// - Keeps the application layer decoupled from persistence details.
///
/// # Design Notes
/// - Does not apply business rules (ledger enforces invariants on write).
/// - Future-proofing: if later we want filters/sorting, add them here.
library;

import '../iou_repository.dart';
import '../iou_entry.dart';

class GetIOUs {
  final IOURepository _repository;

  GetIOUs(this._repository);

  /// Executes the use case.
  Future<List<IOUEntry>> execute() {
    return _repository.getAll();
  }
}
