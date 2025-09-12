/// Unit tests for [Participant].
///
/// Author: Lim Kai Zhe
/// Created: 2 Sep 2025
///
/// Validates Participant domain rules:
/// - Creation enforces non-empty name and generates a UUID.
/// - Equality/hashCode are based on id only.
/// - copyWith preserves id and updates name.
/// - toString is human-readable.
///
/// Conventions:
/// - GIVEN/WHEN/THEN naming
/// - Isolated, deterministic tests
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:the_expense_tracker/features/iou/domain/participant.dart';

void main() {
  group('Participant.create', () {
    test(
      'GIVEN valid name WHEN create THEN succeeds with generated UUID-like id',
      () {
        final p = Participant.create('Alice');

        expect(p.name, 'Alice');
        expect(p.id, isNotEmpty);

        // Optional: lightweight UUID v4 shape check (case-insensitive).
        final uuidV4 = RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
        );
        expect(
          uuidV4.hasMatch(p.id),
          isTrue,
          reason: 'id should look like a UUID v4',
        );
      },
    );

    test(
      'GIVEN empty/whitespace name WHEN create THEN throws ArgumentError',
      () {
        expect(() => Participant.create(''), throwsArgumentError);
        expect(() => Participant.create('   '), throwsArgumentError);
      },
    );
  });

  group('Equality & hashCode (by id)', () {
    test('GIVEN same id via copyWith WHEN compared THEN equal & same hash', () {
      final a = Participant.create('Alice');
      final b = a.copyWith(name: 'Bob'); // preserves id

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('GIVEN different generated ids WHEN compared THEN not equal', () {
      final a = Participant.create('Alice');
      final b = Participant.create('Alice');

      expect(a == b, isFalse);
      expect(a.hashCode == b.hashCode, isFalse);
    });
  });

  group('copyWith', () {
    test(
      'GIVEN copyWith(name) WHEN called THEN updates name but preserves id',
      () {
        final original = Participant.create('Alice');
        final copy = original.copyWith(name: 'Alicia');

        expect(copy.id, equals(original.id));
        expect(copy.name, 'Alicia');
      },
    );

    test(
      'GIVEN copyWith() no args WHEN called THEN returns equivalent object',
      () {
        final original = Participant.create('Alice');
        final copy = original.copyWith();

        expect(copy.id, equals(original.id));
        expect(copy.name, equals(original.name));
      },
    );
  });

  group('toString', () {
    test('GIVEN participant WHEN toString THEN contains id and name', () {
      final p = Participant.create('Alice');
      final s = p.toString();

      expect(s, contains('Participant('));
      expect(s, contains('id:'));
      expect(s, contains('name: Alice'));
    });
  });
}
