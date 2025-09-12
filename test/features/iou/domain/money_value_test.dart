/// Unit tests for [MoneyValue].
///
/// Author: Lim Kai Zhe
/// Created: 2 Sep 2025
///
/// Validates MoneyValue domain rules:
/// - Construction enforces valid cents and currency.
/// - fromDouble creates correctly rounded values.
/// - Equality and hashCode rely on cents + currency.
/// - copyWith preserves immutability while allowing overrides.
/// - Arithmetic operators (+, -) enforce business constraints.
///
/// Conventions:
/// - GIVEN/WHEN/THEN naming
/// - Isolated, deterministic tests
/// - Business rules validated with both valid and invalid cases
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:the_expense_tracker/features/iou/domain/money_value.dart';

void main() {
  group('MoneyValue constructor', () {
    test(
      'GIVEN valid inputs WHEN create THEN succeeds and normalizes currency',
      () {
        final money = MoneyValue(1000, 'myr');

        expect(money.cents, 1000);
        expect(money.currency, 'MYR'); // uppercase normalized
      },
    );

    test('GIVEN negative cents WHEN create THEN throws ArgumentError', () {
      expect(() => MoneyValue(-1, 'MYR'), throwsArgumentError);
    });

    test('GIVEN empty currency WHEN create THEN throws ArgumentError', () {
      expect(() => MoneyValue(100, ''), throwsArgumentError);
    });
  });

  group('MoneyValue.fromDouble', () {
    test('GIVEN valid double WHEN fromDouble THEN converts correctly', () {
      final money = MoneyValue.fromDouble(10.25, 'MYR');

      expect(money.cents, 1025);
      expect(money.asDouble, 10.25);
    });

    test(
      'GIVEN value with extra precision WHEN fromDouble THEN rounds properly',
      () {
        final money = MoneyValue.fromDouble(10.255, 'USD');

        expect(money.cents, 1026); // rounded up
      },
    );
  });

  group('Formatting', () {
    test('GIVEN valid money WHEN toString THEN formatted as "CUR xx.xx"', () {
      final money = MoneyValue(1025, 'MYR');

      expect(money.toString(), 'MYR 10.25');
    });
  });

  group('Equality & hashCode', () {
    test(
      'GIVEN same cents and currency WHEN compared THEN equal & same hash',
      () {
        final a = MoneyValue(500, 'USD');
        final b = MoneyValue(500, 'USD');

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      },
    );

    test(
      'GIVEN different values or currencies WHEN compared THEN not equal',
      () {
        final a = MoneyValue(500, 'USD');
        final b = MoneyValue(600, 'USD');
        final c = MoneyValue(500, 'MYR');

        expect(a == b, isFalse);
        expect(a == c, isFalse);
      },
    );
  });

  group('copyWith', () {
    test(
      'GIVEN copyWith(cents) WHEN called THEN updates cents but preserves currency',
      () {
        final original = MoneyValue(100, 'USD');
        final copy = original.copyWith(cents: 200);

        expect(copy.cents, 200);
        expect(copy.currency, 'USD');
      },
    );

    test(
      'GIVEN copyWith(currency) WHEN called THEN updates currency but preserves cents',
      () {
        final original = MoneyValue(100, 'USD');
        final copy = original.copyWith(currency: 'MYR');

        expect(copy.cents, 100);
        expect(copy.currency, 'MYR');
      },
    );

    test(
      'GIVEN copyWith() no args WHEN called THEN returns equivalent object',
      () {
        final original = MoneyValue(100, 'USD');
        final copy = original.copyWith();

        expect(copy, equals(original));
      },
    );
  });

  group('operator +', () {
    test('GIVEN same currency WHEN add THEN sums cents', () {
      final a = MoneyValue(100, 'USD');
      final b = MoneyValue(200, 'USD');

      expect((a + b).cents, 300);
    });

    test('GIVEN different currencies WHEN add THEN throws ArgumentError', () {
      final a = MoneyValue(100, 'USD');
      final b = MoneyValue(200, 'MYR');

      expect(() => a + b, throwsArgumentError);
    });
  });

  group('operator -', () {
    test(
      'GIVEN same currency and sufficient value WHEN subtract THEN reduces cents',
      () {
        final a = MoneyValue(500, 'USD');
        final b = MoneyValue(200, 'USD');

        expect((a - b).cents, 300);
      },
    );

    test(
      'GIVEN same currency but insufficient value WHEN subtract THEN throws ArgumentError',
      () {
        final a = MoneyValue(100, 'USD');
        final b = MoneyValue(200, 'USD');

        expect(() => a - b, throwsArgumentError);
      },
    );

    test(
      'GIVEN different currencies WHEN subtract THEN throws ArgumentError',
      () {
        final a = MoneyValue(100, 'USD');
        final b = MoneyValue(50, 'MYR');

        expect(() => a - b, throwsArgumentError);
      },
    );
  });
}
