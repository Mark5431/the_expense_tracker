/// Use case: Get IOU entry by ID.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// Uses [IOULedger] for consistency & future-proofing.
/// Repository remains persistence-only.
library;

import 'package:the_expense_tracker/core/error/domain_exceptions.dart';

import '../iou_repository.dart';
import '../iou_entry.dart';
import '../iou_ledger.dart';

class GetIOUById {
  final IOURepository _repository;

  GetIOUById(this._repository);

  /// Executes the use case.
  ///
  /// - Throws [DomainValidationFailure] if ID is empty/whitespace.
  /// - Returns `null` if not found.
  Future<IOUEntry?> execute(String id) async {
    if (id.trim().isEmpty) {
      throw const DomainValidationFailure("ID must not be empty.");
    }

    final currentEntries = await _repository.getAll();
    final ledger = IOULedger.fromEntries(currentEntries);

    try {
      return ledger.findById(id);
    } on StateError {
      return null;
    }
  }
}
