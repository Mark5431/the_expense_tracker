/// Riverpod providers for IOU feature.
///
/// Author: Lim Kai Zhe
/// Created: 7 Sep 2025
///
/// # Responsibilities
/// - Expose dependency injection for repository and use cases
/// - Keep domain & data layers free of Riverpod
/// - Central wiring for feature-level DI
///
/// # Provided
/// - [iouRepositoryProvider] → concrete repository (InMemory for now)
/// - [getIOUsProvider] → GetIOUs use case
/// - [addIOUProvider] → AddIOU use case
/// - [getIOUByIdProvider] → GetIOUById use case
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_expense_tracker/features/iou/data/in_memory_iou_repository.dart';
import 'package:the_expense_tracker/features/iou/domain/iou_repository.dart';
import 'package:the_expense_tracker/features/iou/domain/usecases/add_iou.dart';
import 'package:the_expense_tracker/features/iou/domain/usecases/get_ious.dart';
import 'package:the_expense_tracker/features/iou/domain/usecases/get_iou_by_id.dart';

/// Repository provider.
///
/// Swap [InMemoryIOURepository] with another impl (e.g. SQLite) in production.
final iouRepositoryProvider = Provider<IOURepository>((ref) {
  return InMemoryIOURepository();
});

/// Use case: Get all IOUs.
final getIOUsProvider = Provider<GetIOUs>((ref) {
  final repo = ref.watch(iouRepositoryProvider);
  return GetIOUs(repo);
});

/// Use case: Add a new IOU.
final addIOUProvider = Provider<AddIOU>((ref) {
  final repo = ref.watch(iouRepositoryProvider);
  return AddIOU(repo);
});

/// Use case: Get IOU by ID.
final getIOUByIdProvider = Provider<GetIOUById>((ref) {
  final repo = ref.watch(iouRepositoryProvider);
  return GetIOUById(repo);
});
