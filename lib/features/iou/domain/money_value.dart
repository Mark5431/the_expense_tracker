/// MoneyValue entity.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// Represents a monetary value stored in the smallest currency unit
/// (e.g., cents for USD/MYR). Ensures immutability, type safety,
/// and prevents invalid values such as negative amounts.
///
/// # Design Notes
/// - Uses `int cents` to avoid floating-point precision errors.
/// - Currency must follow ISO 4217 format (e.g., "USD", "MYR").
/// - Addition and subtraction are only allowed between values of the
///   same currency.
/// - Rounding in [MoneyValue.fromDouble] uses `round()` by default,
///   which aligns with corporate accounting best practices unless
///   otherwise specified.
library;

class MoneyValue {
  /// Monetary value stored in smallest unit (e.g., 100 = $1.00).
  final int cents;

  /// ISO 4217 currency code (e.g., "USD", "MYR").
  final String currency;

  /// Private constructor to enforce controlled instantiation.
  const MoneyValue._({required this.cents, required this.currency});

  /// Creates a [MoneyValue] with validation.
  ///
  /// - [cents] must be non-negative.
  /// - [currency] cannot be empty, and will be normalized to uppercase.
  factory MoneyValue(int cents, String currency) {
    if (cents < 0) {
      throw ArgumentError("Money value cannot be negative");
    }
    final normalizedCurrency = currency.trim().toUpperCase();
    if (normalizedCurrency.isEmpty) {
      throw ArgumentError("Currency code cannot be empty");
    }
    return MoneyValue._(cents: cents, currency: normalizedCurrency);
  }

  /// Creates a [MoneyValue] from a decimal amount.
  ///
  /// Example: `10.25 → 1025 cents`.
  ///
  /// Uses `round()` to handle fractional cents, which follows
  /// standard rounding practices in corporate finance.
  factory MoneyValue.fromDouble(double amount, String currency) {
    final cents = (amount * 100).round();
    return MoneyValue(cents, currency);
  }

  /// Returns the decimal form of the value (e.g., `1025 → 10.25`).
  double get asDouble => cents / 100.0;

  /// Human-readable string formatting.
  /// Example: `MYR 10.25`.
  @override
  String toString() {
    final major = cents ~/ 100;
    final minor = cents % 100;
    return "$currency $major.${minor.toString().padLeft(2, '0')}";
  }

  /// Equality is based on both cents and currency.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoneyValue &&
          other.cents == cents &&
          other.currency == currency);

  @override
  int get hashCode => Object.hash(cents, currency);

  /// Returns a copy of this instance with optional overrides.
  MoneyValue copyWith({int? cents, String? currency}) {
    return MoneyValue(cents ?? this.cents, currency ?? this.currency);
  }

  /// Adds two [MoneyValue]s of the same currency.
  MoneyValue operator +(MoneyValue other) {
    _assertSameCurrency(other);
    return MoneyValue(cents + other.cents, currency);
  }

  /// Subtracts two [MoneyValue]s of the same currency.
  /// Throws [ArgumentError] if the result would be negative.
  MoneyValue operator -(MoneyValue other) {
    _assertSameCurrency(other);
    final result = cents - other.cents;
    if (result < 0) {
      throw ArgumentError("Resulting MoneyValue cannot be negative");
    }
    return MoneyValue(result, currency);
  }

  /// Internal helper to validate matching currencies.
  void _assertSameCurrency(MoneyValue other) {
    if (currency != other.currency) {
      throw ArgumentError("Currency mismatch: $currency vs ${other.currency}");
    }
  }
}
