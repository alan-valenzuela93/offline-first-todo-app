import 'package:flutter/material.dart';

import '../../../domain/models/sync_status.dart';

class SyncStatusBadge extends StatelessWidget {
  const SyncStatusBadge({super.key, required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (color, foreground, icon) = switch (status) {
      SyncStatus.synced => (
        const Color(0xFFDDF2ED),
        const Color(0xFF15524B),
        Icons.cloud_done_outlined,
      ),
      SyncStatus.pendingCreate ||
      SyncStatus.pendingUpdate ||
      SyncStatus.pendingDelete => (
        const Color(0xFFFFE3D8),
        const Color(0xFF7E321E),
        Icons.sync_outlined,
      ),
      SyncStatus.syncError => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        Icons.error_outline,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: foreground),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                status.label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
