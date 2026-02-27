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
import 'package:the_expense_tracker/features/iou/domain/money_value.dart';

class IOUSummaryBar extends StatelessWidget {
  final Map<String, MoneyValue> youOweMap;
  final Map<String, MoneyValue> owedToYouMap;

  const IOUSummaryBar({
    super.key,
    required this.youOweMap,
    required this.owedToYouMap,
  });

  @override
  Widget build(BuildContext context) {
    // Helper to format the first currency found (Standard for Sprint 1)
    String format(Map<String, MoneyValue> map) {
      if (map.isEmpty) return "0.00";
      final val = map.values.first;
      return "${val.currency} ${val.asDouble.toStringAsFixed(2)}";
    }

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Row(
          children: [
            _BalanceItem(
              label: "You Owe",
              amount: format(youOweMap),
              color: Colors.redAccent,
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
            _BalanceItem(
              label: "Owed to You",
              amount: format(owedToYouMap),
              color: Colors.green.shade700,
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _BalanceItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
