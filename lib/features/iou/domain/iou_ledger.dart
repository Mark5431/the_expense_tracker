/// IOULedger aggregate root.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// Represents the collection of all [IOUEntry] records in the system.
/// Provides controlled methods for creation, removal, and retrieval.
///
/// # Design Notes
/// - Entries are immutable once added.
/// - Prevents duplicate entries by [IOUEntry.id].
/// - Encapsulates internal state with an unmodifiable view.
/// - Acts as the aggregate root of the "ledger" bounded context.
library;

import 'iou_entry.dart';

class IOULedger {
  final List<IOUEntry> _entries;

  /// Private constructor for rehydration.
  IOULedger._(this._entries); // ignore: unused_element

  /// Creates a new empty ledger.
  IOULedger.empty() : _entries = [];

  /// Rebuild a ledger from persisted entries (rehydration).
  factory IOULedger.fromEntries(List<IOUEntry> entries) {
    final ledger = IOULedger.empty();
    for (final entry in entries) {
      ledger.createEntry(entry); // still enforces invariants
    }
    return ledger;
  }

  /// Returns an unmodifiable list of all IOU entries.
  List<IOUEntry> get entries => List.unmodifiable(_entries);

  /// Adds a new [IOUEntry] to the ledger.
  ///
  /// Throws [ArgumentError] if an entry with the same ID already exists.
  void createEntry(IOUEntry entry) {
    if (_entries.any((e) => e.id == entry.id)) {
      throw ArgumentError('IOUEntry with id ${entry.id} already exists.');
    }
    _entries.add(entry);
  }

  /// Removes an existing [IOUEntry] from the ledger.
  ///
  /// Throws [StateError] if the entry is not found.
  void removeEntry(IOUEntry entry) {
    final removed = _entries.remove(entry);
    if (!removed) {
      throw StateError('IOUEntry with id ${entry.id} not found in ledger.');
    }
  }

  /// Finds an [IOUEntry] by ID.
  ///
  /// Throws [StateError] if not found.
  IOUEntry findById(String id) => _entries.firstWhere((e) => e.id == id);

  /// Returns all entries involving a specific participant.
  List<IOUEntry> findByParticipant(String participantId) => _entries
      .where(
        (e) =>
            e.payer.id == participantId ||
            e.shares.any((s) => s.participant.id == participantId),
      )
      .toList();
}
