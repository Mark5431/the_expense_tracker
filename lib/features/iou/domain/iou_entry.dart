/// IOUEntry entity.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// Represents an expense record in the IOU system. Each entry tracks
/// who paid, the total amount, and how the cost is shared among participants.
///
/// # Design Notes
/// - Immutable entity: all fields are final.
/// - Includes audit fields (`createdAt`, `updatedAt`) for corporate traceability.
/// - Participant shares are validated to ensure they sum correctly.
/// - Equality is based on [id].
library;

import 'package:uuid/uuid.dart';
import 'money_value.dart';
import 'participant.dart';
import 'participant_share.dart';

class IOUEntry {
  /// Unique identifier for the IOU entry.
  final String id;

  /// Short description of the expense.
  final String description;

  /// Total monetary amount of this IOU entry.
  final MoneyValue amount;

  /// Date when the expense occurred.
  final DateTime date;

  /// The participant who paid the expense.
  final Participant payer;

  /// List of shares assigned to participants.
  final List<ParticipantShare> shares;

  /// Audit: when the entry was created.
  final DateTime createdAt;

  /// Audit: when the entry was last updated.
  final DateTime updatedAt;

  /// Private constructor to enforce controlled instantiation.
  const IOUEntry._({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.payer,
    required this.shares,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor with validation.
  factory IOUEntry({
    required String description,
    required MoneyValue amount,
    required DateTime date,
    required Participant payer,
    required List<ParticipantShare> shares,
  }) {
    if (description.trim().isEmpty) {
      throw ArgumentError("Description cannot be empty");
    }
    if (shares.isEmpty) {
      throw ArgumentError("IOU entry must have at least one participant share");
    }

    final totalShares = shares.fold<int>(0, (sum, s) => sum + s.amount.cents);

    if (totalShares != amount.cents) {
      throw ArgumentError(
        "Sum of participant shares ($totalShares cents) "
        "must equal total amount (${amount.cents} cents)",
      );
    }

    final now = DateTime.now();

    return IOUEntry._(
      id: const Uuid().v4(),
      description: description.trim(),
      amount: amount,
      date: date,
      payer: payer,
      shares: List.unmodifiable(shares),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Returns a copy with optional field overrides.
  IOUEntry copyWith({
    String? description,
    MoneyValue? amount,
    DateTime? date,
    Participant? payer,
    List<ParticipantShare>? shares,
  }) {
    final newShares = shares ?? this.shares;

    if (amount != null) {
      final totalShares = newShares.fold<int>(
        0,
        (sum, s) => sum + s.amount.cents,
      );
      if (totalShares != amount.cents) {
        throw ArgumentError(
          "Sum of participant shares ($totalShares cents) "
          "must equal total amount (${amount.cents} cents)",
        );
      }
    }

    return IOUEntry._(
      id: id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      payer: payer ?? this.payer,
      shares: List.unmodifiable(newShares),
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// Equality is based on [id] only.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is IOUEntry && other.id == id);

  @override
  int get hashCode => id.hashCode;

  /// Human-readable representation.
  @override
  String toString() =>
      "IOUEntry(id: $id, desc: $description, amount: $amount, payer: ${payer.name}, date: $date)";
}
