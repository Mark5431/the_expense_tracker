/// Unit tests for [GetIOUs] use case.
///
/// Author: Lim Kai Zhe
/// Created: 3 Sep 2025
///
/// These tests validate the GetIOUs application logic:
/// - Delegates persistence to repository
/// - Returns entries unchanged
/// - Handles empty results
/// - Propagates repository errors
///
/// # Test Strategy
/// - Mock repository to isolate use case
/// - GIVEN/WHEN/THEN naming for clarity
/// - Covers empty, non-empty, and error cases
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_expense_tracker/features/iou/domain/iou_entry.dart';
import 'package:the_expense_tracker/features/iou/domain/money_value.dart';
import 'package:the_expense_tracker/features/iou/domain/participant.dart';
import 'package:the_expense_tracker/features/iou/domain/participant_share.dart';
import 'package:the_expense_tracker/features/iou/domain/usecases/get_ious.dart';

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
  late GetIOUs usecase;

  setUp(() {
    mockRepo = MockIOURepository();
    usecase = GetIOUs(mockRepo);
  });

  group('GetIOUs.execute', () {
    test('returns empty list when repository has no entries', () async {
      // GIVEN repository returns []
      when(() => mockRepo.getAll()).thenAnswer((_) async => []);

      // WHEN executing
      final result = await usecase.execute();

      // THEN result is empty
      expect(result, isEmpty);
      verify(() => mockRepo.getAll()).called(1);
    });

    test('returns list of entries from repository', () async {
      // GIVEN repository returns [entry1, entry2]
      final entry1 = buildEntry(
        description: 'Lunch',
        cents: 1000,
        payer: alice,
        shares: [
          ParticipantShare(alice, MoneyValue(600, 'MYR')),
          ParticipantShare(bob, MoneyValue(400, 'MYR')),
        ],
      );
      final entry2 = buildEntry(
        description: 'Coffee',
        cents: 500,
        payer: bob,
        shares: [ParticipantShare(bob, MoneyValue(500, 'MYR'))],
      );
      when(() => mockRepo.getAll()).thenAnswer((_) async => [entry1, entry2]);

      // WHEN executing
      final result = await usecase.execute();

      // THEN result contains both entries
      expect(result.length, 2);
      expect(result, containsAll([entry1, entry2]));
      verify(() => mockRepo.getAll()).called(1);
    });

    test('propagates repository exception', () async {
      // GIVEN repository throws
      when(() => mockRepo.getAll()).thenThrow(Exception('DB failure'));

      // WHEN/THEN expect the exception to propagate
      expect(() => usecase.execute(), throwsA(isA<Exception>()));
      verify(() => mockRepo.getAll()).called(1);
    });
  });
}
