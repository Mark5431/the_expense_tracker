/// IOU List Page
///
/// Author: Lim Kai Zhe
/// Created: 14 Sep 2025
///
/// Displays a list of IOU entries with a top summary bar.
/// Powered by [IOUListViewModel] through Riverpod.
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
    // Watch the provider to react to state changes (UI-1 requirement)
    final iouListState = ref.watch(iouListViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("IOU Ledger"), centerTitle: true),
      body: iouListState.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Text("No IOUs yet. Add one to get started!"),
            );
          }

          // 1. Get the notifier to access the new US-4 balance getters
          final viewModel = ref.read(iouListViewModelProvider.notifier);

          // 2. Fetch the specific maps for "You Owe" and "Owed to You"
          final youOweMap = viewModel.totalsYouOwe;
          final owedToYouMap = viewModel.totalsOwedToYou;

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(iouListViewModelProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: entries.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // 3. Pass the TWO new maps to the updated SummaryBar
                  return IOUSummaryBar(
                    youOweMap: youOweMap,
                    owedToYouMap: owedToYouMap,
                  );
                }
                if (index == 1) return const Divider(indent: 16, endIndent: 16);

                final entry = entries[index - 2];
                return IOUCard(entry: entry);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
      // Added FAB for UI-6 Navigation requirement
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to /iou/create (UI-6)
        },
        tooltip: 'Add IOU',
        child: const Icon(Icons.add),
      ),
    );
  }
}
