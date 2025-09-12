/// Barrel file for the IOU Domain layer.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
///
/// # Purpose
/// Provides a single import point for all domain layer classes,
/// keeping the public API of the domain clean and discoverable.
///
/// # Design Notes
/// - Keeps domain models, value objects, and repository contracts
///   together under one unified entry point.
/// - Helps reduce clutter in imports across other layers.
/// - Use this in data/repository/presentation layers where multiple
///   domain classes are needed.
///
/// Example:
/// ```dart
/// import 'package:the_expense_tracker/features/iou/domain/domain.dart';
/// ```
///
library;

export 'iou_entry.dart';
export 'iou_ledger.dart';
export 'iou_repository.dart';
export 'money_value.dart';
export 'participant.dart';
export 'participant_share.dart';
