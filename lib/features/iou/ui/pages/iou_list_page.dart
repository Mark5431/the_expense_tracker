/// IOU List Page
///
/// Author: Dev B
/// Created: 14 Sep 2025
///
/// Displays a list of IOU entries with a top summary bar.
/// Powered by [IOUListViewModel] through Riverpod.
///
/// # Responsibilities
/// - Routing entry for IOU list feature
/// - Orchestrates UI with [IOUSummaryBar] + [IOUCard]
/// - Manages async state: loading, error, empty
/// - Optional pull-to-refresh
///
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/iou_list_viewmodel.dart';
import '../widgets/iou_card.dart';
import '../widgets/iou_summary_bar.dart';

class IOUListPage extends ConsumerWidget {
  const IOUListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iouListState = ref.watch(iouListViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("IOU Ledger")),
      body: iouListState.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Text("No IOUs yet. Add one to get started!"),
            );
          }

          // Compute summary
          final totalAmount = entries.fold<double>(
            0,
            (sum, e) => sum + e.amount.asDouble,
          );
          final totalCount = entries.length;

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(iouListViewModelProvider.notifier).refresh();
            },
            child: ListView.builder(
              itemCount: entries.length + 2, // summary + divider + entries
              itemBuilder: (context, index) {
                if (index == 0) {
                  return IOUSummaryBar(
                    totalAmount: totalAmount,
                    totalCount: totalCount,
                  );
                }
                if (index == 1) return const Divider();
                final entry = entries[index - 2];
                return IOUCard(entry: entry);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
