/// Mock implementation of [IOURepository] using Mockito.
///
/// Author: Lim Kai Zhe
/// Created: 2 Sep 2025
///
/// This file defines reusable mocks for use case tests.
library;

import 'package:mocktail/mocktail.dart';
import 'package:the_expense_tracker/features/iou/domain/iou_repository.dart';

class MockIOURepository extends Mock implements IOURepository {}
