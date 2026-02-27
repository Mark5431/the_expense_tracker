/// IOU Detail Page
///
/// Author: Lim Kai Zhe
/// Created: 27 Feb 2026
///
/// Responsibilities:
/// - Display comprehensive details of a specific IOU entry.
/// - Observe [IOUDetailViewModel] for async state (loading, data, error).
/// - List all participants and their specific shares.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodels/iou_detail_viewmodel.dart';

class IOUDetailPage extends ConsumerWidget {
  /// The unique identifier passed from the router.
  final String id;

  const IOUDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific family provider for this ID
    final detailState = ref.watch(iouDetailViewModelProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(iouDetailViewModelProvider(id).notifier).refresh(),
          ),
        ],
      ),
      body: detailState.when(
        data: (entry) {
          if (entry == null) {
            return const Center(child: Text("Entry not found."));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildHeader(context, entry),
              const Divider(height: 32),
              _buildParticipantList(context, entry),
              const Divider(height: 32),
              _buildAuditInfo(context, entry),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text("Error loading detail: $err")),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic entry) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.description,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          "${entry.amount.currency} ${entry.amount.asDouble.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.person),
          title: const Text("Paid by"),
          subtitle: Text(entry.payer.name),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_today),
          title: const Text("Date"),
          subtitle: Text(dateFormat.format(entry.date)),
        ),
      ],
    );
  }

  Widget _buildParticipantList(BuildContext context, dynamic entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Participants Split",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...entry.shares.map(
          (share) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Text(share.participant.name[0])),
            title: Text(share.participant.name),
            trailing: Text(
              "${share.amount.currency} ${share.amount.asDouble.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuditInfo(BuildContext context, dynamic entry) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Audit Information", style: Theme.of(context).textTheme.bodySmall),
        Text(
          "Created: ${dateFormat.format(entry.createdAt)}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          "Last Updated: ${dateFormat.format(entry.updatedAt)}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
