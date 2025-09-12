/// Unit tests for [IOULedger].
///
/// Author: Lim Kai Zhe
/// Created: 2 Sep 2025
///
/// These tests validate the behavior of the IOULedger aggregate root:
/// - Starts empty and supports rehydration
/// - Allows adding entries while preventing duplicates
/// - Allows removing entries while enforcing existence
/// - Supports lookup by ID and participant
/// - Exposes entries immutably
///
/// # Test Strategy
/// - Pure unit tests (no external dependencies).
/// - Given/When/Then naming convention for clarity.
/// - Organized into groups by ledger method.
/// - Ensures aggregate invariants (e.g. no duplicates, consistent retrieval).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:the_expense_tracker/features/iou/domain/iou_entry.dart';
import 'package:the_expense_tracker/features/iou/domain/iou_ledger.dart';
import 'package:the_expense_tracker/features/iou/domain/money_value.dart';
import 'package:the_expense_tracker/features/iou/domain/participant.dart';
import 'package:the_expense_tracker/features/iou/domain/participant_share.dart';

void main() {
  // Common fixtures
  final alice = Participant.create('Alice');
  final bob = Participant.create('Bob');

  IOUEntry buildEntry({
    required String description,
    required int cents,
    required Participant payer,
    required List<ParticipantShare> shares,
  }) {
    return IOUEntry(
      description: description,
      amount: MoneyValue(cents, 'MYR'),
      date: DateTime(2025, 8, 26),
      payer: payer,
      shares: shares,
    );
  }

  group('IOULedger.empty', () {
    test('starts with no entries', () {
      // GIVEN a new empty ledger
      final ledger = IOULedger.empty();

      // THEN entries list is empty and unmodifiable
      expect(ledger.entries, isEmpty);
      expect(
        () => ledger.entries.add(
          buildEntry(
            description: 'Hacking',
            cents: 100,
            payer: alice,
            shares: [ParticipantShare(alice, MoneyValue(100, 'MYR'))],
          ),
        ),
        throwsUnsupportedError,
      );
    });
  });

  group('IOULedger.createEntry', () {
    test('adds a new entry successfully', () {
      // GIVEN an empty ledger
      final ledger = IOULedger.empty();
      final entry = buildEntry(
        description: 'Lunch',
        cents: 1000,
        payer: alice,
        shares: [
          ParticipantShare(alice, MoneyValue(600, 'MYR')),
          ParticipantShare(bob, MoneyValue(400, 'MYR')),
        ],
      );

      // WHEN adding the entry
      ledger.createEntry(entry);

      // THEN ledger contains the entry
      expect(ledger.entries.length, 1);
      expect(ledger.entries.first.description, 'Lunch');
    });

    test('throws when adding duplicate entry by ID', () {
      // GIVEN a ledger with one entry
      final ledger = IOULedger.empty();
      final entry = buildEntry(
        description: 'Dinner',
        cents: 500,
        payer: alice,
        shares: [ParticipantShare(alice, MoneyValue(500, 'MYR'))],
      );
      ledger.createEntry(entry);

      // WHEN adding the same entry again
      // THEN expect ArgumentError
      expect(() => ledger.createEntry(entry), throwsArgumentError);
    });
  });

  group('IOULedger.removeEntry', () {
    test('removes an existing entry', () {
      // GIVEN a ledger with one entry
      final ledger = IOULedger.empty();
      final entry = buildEntry(
        description: 'Coffee',
        cents: 300,
        payer: bob,
        shares: [ParticipantShare(bob, MoneyValue(300, 'MYR'))],
      );
      ledger.createEntry(entry);

      // WHEN removing the entry
      ledger.removeEntry(entry);

      // THEN ledger is empty again
      expect(ledger.entries, isEmpty);
    });

    test('throws when removing non-existent entry', () {
      // GIVEN an empty ledger
      final ledger = IOULedger.empty();
      final fakeEntry = buildEntry(
        description: 'Nonexistent',
        cents: 100,
        payer: alice,
        shares: [ParticipantShare(alice, MoneyValue(100, 'MYR'))],
      );

      // WHEN/THEN expect StateError
      expect(() => ledger.removeEntry(fakeEntry), throwsStateError);
    });
  });

  group('IOULedger.findById', () {
    test('finds entry by ID', () {
      // GIVEN a ledger with one entry
      final ledger = IOULedger.empty();
      final entry = buildEntry(
        description: 'Trip',
        cents: 2000,
        payer: alice,
        shares: [
          ParticipantShare(alice, MoneyValue(1000, 'MYR')),
          ParticipantShare(bob, MoneyValue(1000, 'MYR')),
        ],
      );
      ledger.createEntry(entry);

      // WHEN looking up by ID
      final found = ledger.findById(entry.id);

      // THEN the entry is returned
      expect(found, equals(entry));
    });

    test('throws when ID not found', () {
      // GIVEN an empty ledger
      final ledger = IOULedger.empty();

      // WHEN/THEN expect StateError
      expect(() => ledger.findById('fake-id'), throwsStateError);
    });
  });

  group('IOULedger.findByParticipant', () {
    test('returns entries involving given participant', () {
      // GIVEN a ledger with multiple entries
      final ledger = IOULedger.empty();
      final aliceOnly = buildEntry(
        description: 'Solo Meal',
        cents: 500,
        payer: alice,
        shares: [ParticipantShare(alice, MoneyValue(500, 'MYR'))],
      );
      final bobInvolved = buildEntry(
        description: 'Shared Taxi',
        cents: 800,
        payer: bob,
        shares: [
          ParticipantShare(alice, MoneyValue(400, 'MYR')),
          ParticipantShare(bob, MoneyValue(400, 'MYR')),
        ],
      );
      ledger.createEntry(aliceOnly);
      ledger.createEntry(bobInvolved);

      // WHEN searching for Bob
      final results = ledger.findByParticipant(bob.id);

      // THEN only entries involving Bob are returned
      expect(results.length, 1);
      expect(results.first.description, 'Shared Taxi');
    });
  });
}
