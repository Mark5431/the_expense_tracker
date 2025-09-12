/// Use case: Add a new IOU entry.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// Responsibilities:
/// - Validate basic business rules.
/// - Delegate domain invariants to [IOULedger].
/// - Persist the updated ledger via repository.
library;

import 'package:the_expense_tracker/core/error/domain_exceptions.dart';

import '../iou_repository.dart';
import '../iou_entry.dart';
import '../iou_ledger.dart';

class AddIOU {
  final IOURepository _repository;

  AddIOU(this._repository);

  /// Executes the use case.
  /// Throws [ArgumentError] if validation fails.
  Future<void> execute(IOUEntry entry) async {
    // Basic input validation (fast-fail).
    if (entry.amount.cents <= 0) {
      throw const DomainValidationFailure("Amount must be greater than 0");
    }
    if (entry.shares.isEmpty) {
      throw const DomainValidationFailure(
        "At least one participant is required",
      );
    }

    // Load current state of ledger from repo.
    final currentEntries = await _repository.getAll();
    final ledger = IOULedger.fromEntries(currentEntries);

    // Enforce domain invariants via aggregate root.
    ledger.createEntry(entry);

    // Persist changes.
    await _repository.add(entry);
  }
}
