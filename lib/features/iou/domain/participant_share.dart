/// ParticipantShare entity.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// Represents the portion of a monetary value assigned to a specific
/// participant. Ensures immutability, type safety, and prevents invalid
/// negative amounts.
///
/// # Design Notes
/// - Each share is tied to a [Participant] and a [MoneyValue].
/// - Enforces non-negative values.
/// - Equality is based on both participant and amount.
library;

import 'money_value.dart';
import 'participant.dart';

class ParticipantShare {
  /// The participant this share belongs to.
  final Participant participant;

  /// The monetary value of this participant's share.
  final MoneyValue amount;

  /// Private constructor to enforce validation.
  const ParticipantShare._({required this.participant, required this.amount});

  /// Creates a [ParticipantShare] with validation.
  ///
  /// Throws [ArgumentError] if [amount] is negative.
  factory ParticipantShare(Participant participant, MoneyValue amount) {
    if (amount.cents < 0) {
      throw ArgumentError("Participant share cannot be negative");
    }
    return ParticipantShare._(participant: participant, amount: amount);
  }

  /// Returns a copy of this share with optional overrides.
  ParticipantShare copyWith({Participant? participant, MoneyValue? amount}) {
    return ParticipantShare(
      participant ?? this.participant,
      amount ?? this.amount,
    );
  }

  /// Equality is based on both participant and amount.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParticipantShare &&
          other.participant == participant &&
          other.amount == amount);

  @override
  int get hashCode => Object.hash(participant, amount);

  /// Human-readable formatting.
  /// Example: `Alice → MYR 25.50`.
  @override
  String toString() => "${participant.name} → $amount";
}
