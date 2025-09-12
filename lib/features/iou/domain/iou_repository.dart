/// IOU Repository interface.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// Defines the contract for accessing and persisting [IOUEntry] objects.
///
/// # Design Notes
/// - Abstracts away the underlying data source (memory, database, API).
/// - Promotes testability and dependency inversion.
/// - All methods are asynchronous to accommodate I/O-bound operations.
/// - Provides both "pull" (Future) and "push" (Stream) access patterns.
///
/// Implementations:
/// - InMemoryIOURepository (development/testing)
/// - SqlIOURepository (production, relational DB)
/// - ApiIOURepository (remote service)
library;

import 'iou_entry.dart';

/// Contract for IOU persistence.
abstract class IOURepository {
  /// Retrieves all [IOUEntry] records once.
  Future<List<IOUEntry>> getAll();

  /// Watches all [IOUEntry] records in real-time.
  ///
  /// Emits a new list whenever entries change.
  Stream<List<IOUEntry>> watchAll();

  /// Persists a new [IOUEntry].
  Future<void> add(IOUEntry entry);

  /// Retrieves a single [IOUEntry] by [id].
  ///
  /// Returns `null` if no entry exists with the given ID.
  Future<IOUEntry?> getById(String id);

  /// Removes an [IOUEntry] by [id].
  Future<void> remove(String id);

  /// Updates an existing [IOUEntry].
  ///
  /// Throws [ArgumentError] if the entry does not exist.
  Future<void> update(IOUEntry entry);
}
