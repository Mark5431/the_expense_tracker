/// Unit tests for [GetIOUById] use case.
///
/// Author: Lim Kai Zhe
/// Created: 6 Sep 2025
///
/// These tests validate the GetIOUById application logic:
/// - Validates non-empty ID input
/// - Delegates lookup via repository -> ledger
/// - Handles both found and not found cases
///
/// # Test Strategy
/// - Mock repository to isolate use case
/// - GIVEN/WHEN/THEN naming for clarity
/// - Pure unit tests, no side effects
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_expense_tracker/core/error/domain_exceptions.dart';
import 'package:the_expense_tracker/features/iou/domain/iou_entry.dart';
import 'package:the_expense_tracker/features/iou/domain/money_value.dart';
import 'package:the_expense_tracker/features/iou/domain/participant.dart';
import 'package:the_expense_tracker/features/iou/domain/participant_share.dart';
import 'package:the_expense_tracker/features/iou/domain/usecases/get_iou_by_id.dart';

import '../../../../mocks/mock_iou_repository.dart';

void main() {
  // Fixtures
  final alice = Participant.create('Alice');

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
  late GetIOUById usecase;

  setUp(() {
    mockRepo = MockIOURepository();
    usecase = GetIOUById(mockRepo);
  });

  group('GetIOUById.execute', () {
    test('throws when ID is empty', () async {
      // GIVEN empty ID
      const id = '   ';

      // WHEN/THEN expect DomainValidationFailure
      expect(
        () => usecase.execute(id),
        throwsA(isA<DomainValidationFailure>()),
      );
    });

    test('returns entry when found', () async {
      // GIVEN repo has entries including one with matching ID
      final entry = buildEntry(
        description: 'Groceries',
        cents: 1200,
        payer: alice,
        shares: [ParticipantShare(alice, MoneyValue(1200, 'MYR'))],
      );
      when(() => mockRepo.getAll()).thenAnswer((_) async => [entry]);

      // WHEN executing
      final result = await usecase.execute(entry.id);

      // THEN the entry is returned
      expect(result, equals(entry));
      verify(() => mockRepo.getAll()).called(1);
    });

    test('returns null when not found', () async {
      // GIVEN repo returns empty list
      when(() => mockRepo.getAll()).thenAnswer((_) async => []);

      // WHEN executing
      final result = await usecase.execute('missing-id');

      // THEN result is null
      expect(result, isNull);
      verify(() => mockRepo.getAll()).called(1);
    });
  });
}
