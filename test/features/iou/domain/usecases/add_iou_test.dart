/// Unit tests for [AddIOU] use case.
///
/// Author: Lim Kai Zhe
/// Created: 2 Sep 2025
///
/// These tests validate the AddIOU application logic:
/// - Validates basic business rules
/// - Delegates duplicate prevention to IOULedger
/// - Persists via repository
///
/// # Test Strategy
/// - Mock repository to isolate use case
/// - GIVEN/WHEN/THEN naming for clarity
/// - Covers validation, success, duplicate handling, persistence
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_expense_tracker/core/error/domain_exceptions.dart';
import 'package:the_expense_tracker/features/iou/domain/iou_entry.dart';
import 'package:the_expense_tracker/features/iou/domain/money_value.dart';
import 'package:the_expense_tracker/features/iou/domain/participant.dart';
import 'package:the_expense_tracker/features/iou/domain/participant_share.dart';
import 'package:the_expense_tracker/features/iou/domain/usecases/add_iou.dart';

import '../../../../mocks/mock_iou_repository.dart';

void main() {
  // Fixtures
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

  late MockIOURepository mockRepo;
  late AddIOU usecase;

  setUp(() {
    mockRepo = MockIOURepository();
    usecase = AddIOU(mockRepo);
  });

  group('AddIOU.execute', () {
    test('throws when amount is <= 0', () async {
      // GIVEN an entry with invalid amount
      final entry = buildEntry(
        description: 'Invalid',
        cents: 0,
        payer: alice,
        shares: [ParticipantShare(alice, MoneyValue(0, 'MYR'))],
      );

      // WHEN/THEN expect DomainValidationFailure
      expect(
        () => usecase.execute(entry),
        throwsA(isA<DomainValidationFailure>()),
      );
    });

    test('adds a valid entry successfully', () async {
      // GIVEN a valid entry and empty repo
      final entry = buildEntry(
        description: 'Lunch',
        cents: 1000,
        payer: alice,
        shares: [
          ParticipantShare(alice, MoneyValue(600, 'MYR')),
          ParticipantShare(bob, MoneyValue(400, 'MYR')),
        ],
      );
      when(() => mockRepo.getAll()).thenAnswer((_) async => []);
      when(() => mockRepo.add(entry)).thenAnswer((_) async {});

      // WHEN executing
      await usecase.execute(entry);

      // THEN repo.add called with entry
      verify(() => mockRepo.add(entry)).called(1);
    });

    test('throws when adding a duplicate entry', () async {
      // GIVEN repo already has the entry
      final entry = buildEntry(
        description: 'Dinner',
        cents: 500,
        payer: alice,
        shares: [ParticipantShare(alice, MoneyValue(500, 'MYR'))],
      );
      when(() => mockRepo.getAll()).thenAnswer((_) async => [entry]);

      // WHEN/THEN expect ArgumentError from ledger
      expect(() => usecase.execute(entry), throwsArgumentError);
    });
  });
}
