/// IOU Card Widget
///
/// Author: Lim Kai Zhe
/// Created: 14 Sep 2025
///
/// Displays a single [IOUEntry] with description, payer, and amount.
/// Used in [IOUListPage].
///
library;

import 'package:flutter/material.dart';
import 'package:the_expense_tracker/features/iou/domain/domain.dart';

class IOUCard extends StatelessWidget {
  final IOUEntry entry;

  const IOUCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(entry.description),
        subtitle: Text("Paid by ${entry.payer.name}"),
        trailing: Text(
          entry.amount.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onTap: () {
          // TODO: Navigate to IOU detail page
        },
      ),
    );
  }
}
