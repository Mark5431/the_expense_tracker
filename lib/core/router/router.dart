/// Central Router Configuration
///
/// Author: Lim Kai Zhe
/// Created: 27 Feb 2026
///
/// Responsibilities:
/// - Define application routes and path parameters.
/// - Map URL paths to specific [Page] widgets.
/// - Handle deep linking for IOU details.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_expense_tracker/features/iou/ui/pages/iou_list_page.dart';
import 'package:the_expense_tracker/features/iou/ui/pages/iou_detail_page.dart';

/// Global router configuration using GoRouter.
/// Satisfies ARCH-2: Routing in place.
final router = GoRouter(
  initialLocation: '/',
  routes: [
    // IOU List (Home)
    GoRoute(
      path: '/',
      builder: (context, state) => const IOUListPage(),
      routes: [
        // IOU Detail (Sub-route)
        // Satisfies UI-3: /iou/:id mapping
        GoRoute(
          path: 'iou/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return IOUDetailPage(id: id);
          },
        ),
      ],
    ),
  ],
);
