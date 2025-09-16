/// IOU Summary Bar Widget
///
/// Author: Lim Kai Zhe
/// Created: 14 Sep 2025
///
/// Displays total number of IOUs and total owed amount.
/// Used at the top of [IOUListPage].
///
library;

import 'package:flutter/material.dart';

class IOUSummaryBar extends StatelessWidget {
  final double totalAmount;
  final int totalCount;

  const IOUSummaryBar({
    super.key,
    required this.totalAmount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Total Expenses",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "$totalCount",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Total Amount",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  totalAmount.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
