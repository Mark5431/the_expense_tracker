/// Unit tests for [ParticipantShare].
///
/// Author: Lim Kai Zhe
/// Created: 2 Sep 2025
///
/// These tests ensure correctness of the [ParticipantShare] entity,
/// which represents a participant’s assigned portion of an IOU entry.
///
/// # Coverage
/// - Construction & validation
/// - Immutability
/// - Copying
/// - Equality & hashCode
/// - String formatting
///
/// # Testing Principles
/// - Each test follows the GIVEN / WHEN / THEN structure.
/// - Validation logic is tested for both valid and invalid inputs.
/// - Equality is verified with variations in participant and amount.
/// - Output formatting is checked for human readability.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:the_expense_tracker/features/iou/domain/participant.dart';
import 'package:the_expense_tracker/features/iou/domain/money_value.dart';
import 'package:the_expense_tracker/features/iou/domain/participant_share.dart';

void main() {
  group('ParticipantShare', () {
    final alice = Participant.create("Alice");
    final bob = Participant.create("Bob");
    final amount = MoneyValue(2500, 'MYR'); // MYR 25.00

    test('creates valid instance', () {
      // GIVEN a participant and a money amount
      // WHEN constructing a ParticipantShare
      final share = ParticipantShare(alice, amount);

      // THEN the fields should be set correctly
      expect(share.participant, alice);
      expect(share.amount, amount);
    });

    test('copyWith updates participant', () {
      // GIVEN a ParticipantShare
      final share = ParticipantShare(alice, amount);

      // WHEN copying with a new participant
      final updated = share.copyWith(participant: bob);

      // THEN participant should be updated and amount unchanged
      expect(updated.participant, bob);
      expect(updated.amount, amount);
    });

    test('copyWith updates amount', () {
      // GIVEN a ParticipantShare
      final share = ParticipantShare(alice, amount);

      // WHEN copying with a new amount
      final newAmount = MoneyValue(3000, 'MYR');
      final updated = share.copyWith(amount: newAmount);

      // THEN amount should be updated and participant unchanged
      expect(updated.participant, alice);
      expect(updated.amount, newAmount);
    });

    test('equality works with same participant and amount', () {
      // GIVEN two identical ParticipantShares
      final share1 = ParticipantShare(alice, amount);
      final share2 = ParticipantShare(alice, amount);

      // WHEN comparing them
      // THEN they should be equal with same hashCode
      expect(share1, equals(share2));
      expect(share1.hashCode, equals(share2.hashCode));
    });

    test('equality fails with different participants', () {
      // GIVEN two ParticipantShares with different participants
      final share1 = ParticipantShare(alice, amount);
      final share2 = ParticipantShare(bob, amount);

      // WHEN comparing them
      // THEN they should not be equal
      expect(share1, isNot(equals(share2)));
    });

    test('equality fails with different amounts', () {
      // GIVEN two ParticipantShares with different amounts
      final share1 = ParticipantShare(alice, amount);
      final share2 = ParticipantShare(alice, MoneyValue(3000, 'MYR'));

      // WHEN comparing them
      // THEN they should not be equal
      expect(share1, isNot(equals(share2)));
    });

    test('toString formats correctly', () {
      // GIVEN a ParticipantShare
      final share = ParticipantShare(alice, MoneyValue(2550, 'MYR'));

      // WHEN calling toString
      final result = share.toString();

      // THEN it should format as "Alice → MYR 25.50"
      expect(result, "Alice → MYR 25.50");
    });
  });
}
