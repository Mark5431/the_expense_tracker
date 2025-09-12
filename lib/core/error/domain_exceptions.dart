/// Domain-specific exceptions.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// These represent business rule violations or invalid states
/// within the IOU domain. Upper layers can catch them to display
/// user-friendly messages or handle gracefully.
library;

abstract class DomainException implements Exception {
  final String message;
  const DomainException(this.message);

  @override
  String toString() => "$runtimeType: $message";
}

/// Validation error — input failed business rules.
class DomainValidationFailure extends DomainException {
  const DomainValidationFailure(super.message);
}

/// Invariant error — aggregate state would become inconsistent.
class DomainInvariantFailure extends DomainException {
  const DomainInvariantFailure(super.message);
}
