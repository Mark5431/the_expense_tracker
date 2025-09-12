/// Unit tests for [IOUEntry].
///
/// Author: Lim Kai Zhe
/// Created: 1 Sep 2025
///
/// These tests validate the behavior of the IOUEntry domain entity:
/// - Enforces description non-empty constraint
/// - Enforces participant shares match total amount
/// - Allows valid creation with correct invariants
/// - Supports immutability and `copyWith` updates
///
/// # Test Strategy
/// - Pure unit tests (no external dependencies).
/// - Given/When/Then naming convention for clarity.
/// - Organized into groups by entity method.
/// - Ensures domain invariants act as guardrails.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:the_expense_tracker/features/iou/domain/iou_entry.dart';
import 'package:the_expense_tracker/features/iou/domain/money_value.dart';
import 'package:the_expense_tracker/features/iou/domain/participant.dart';
import 'package:the_expense_tracker/features/iou/domain/participant_share.dart';

void main() {
  // Common fixtures to reuse across tests
  final payer = Participant.create('Alice');
  final friend = Participant.create('Bob');

  group('IOUEntry factory', () {
    test('creates valid entry when shares equal amount', () {
      // GIVEN valid inputs
      final amount = MoneyValue(1000, 'MYR');
      final shares = [
        ParticipantShare(payer, MoneyValue(600, 'MYR')),
        ParticipantShare(friend, MoneyValue(400, 'MYR')),
      ];

      // WHEN constructing
      final entry = IOUEntry(
        description: 'Dinner',
        amount: amount,
        date: DateTime(2025, 8, 26),
        payer: payer,
        shares: shares,
      );

      // THEN entry is created with correct properties
      expect(entry.description, 'Dinner');
      expect(entry.amount.cents, 1000);
      expect(entry.shares.length, 2);
      expect(entry.payer.name, 'Alice');
    });

    test('throws when description is empty', () {
      // GIVEN empty description
      final amount = MoneyValue(500, 'MYR');
      final shares = [ParticipantShare(payer, MoneyValue(500, 'MYR'))];

      // WHEN/THEN expect ArgumentError
      expect(
        () => IOUEntry(
          description: '   ',
          amount: amount,
          date: DateTime(2025, 8, 26),
          payer: payer,
          shares: shares,
        ),
        throwsArgumentError,
      );
    });

    test('throws when shares do not sum to amount', () {
      // GIVEN mismatch between shares and amount
      final amount = MoneyValue(1000, 'MYR');
      final shares = [
        ParticipantShare(payer, MoneyValue(800, 'MYR')),
        ParticipantShare(friend, MoneyValue(100, 'MYR')),
      ];

      // WHEN/THEN expect ArgumentError
      expect(
        () => IOUEntry(
          description: 'Trip',
          amount: amount,
          date: DateTime(2025, 8, 26),
          payer: payer,
          shares: shares,
        ),
        throwsArgumentError,
      );
    });
  });

  group('IOUEntry.copyWith', () {
    test('creates new entry with updated description', () {
      // GIVEN an existing entry
      final entry = IOUEntry(
        description: 'Dinner',
        amount: MoneyValue(1000, 'MYR'),
        date: DateTime(2025, 8, 26),
        payer: payer,
        shares: [ParticipantShare(payer, MoneyValue(1000, 'MYR'))],
      );

      // WHEN copyWith updates description
      final updated = entry.copyWith(description: 'Lunch');

      // THEN original remains unchanged, new has updated description
      expect(entry.description, 'Dinner');
      expect(updated.description, 'Lunch');
      expect(updated.id, entry.id); // ID is preserved
    });

    test('throws when new shares do not match updated amount', () {
      // GIVEN an existing entry
      final entry = IOUEntry(
        description: 'Dinner',
        amount: MoneyValue(1000, 'MYR'),
        date: DateTime(2025, 8, 26),
        payer: payer,
        shares: [ParticipantShare(payer, MoneyValue(1000, 'MYR'))],
      );

      // WHEN copyWith sets amount mismatch
      final badShares = [ParticipantShare(payer, MoneyValue(900, 'MYR'))];

      // THEN expect validation failure
      expect(
        () =>
            entry.copyWith(amount: MoneyValue(1000, 'MYR'), shares: badShares),
        throwsArgumentError,
      );
    });
  });
}
