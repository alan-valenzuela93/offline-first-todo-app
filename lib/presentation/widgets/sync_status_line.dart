import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';

class SyncStatusLine extends StatelessWidget {
  const SyncStatusLine({
    super.key,
    required this.controller,
    required this.onSyncNow,
  });

  final TaskController controller;
  final VoidCallback onSyncNow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, color) = switch (controller.syncUiState) {
      SyncUiState.syncing => (Icons.sync_rounded, colorScheme.primary),
      SyncUiState.synced => (Icons.cloud_done_outlined, colorScheme.primary),
      SyncUiState.localOnly => (
          Icons.cloud_off_outlined,
          colorScheme.onSurfaceVariant,
        ),
      SyncUiState.error => (Icons.error_outline, colorScheme.error),
      SyncUiState.idle => (Icons.save_outlined, colorScheme.onSurfaceVariant),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8E5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            controller.isSyncing
                ? SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(icon, size: 17, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                controller.syncMessage,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: controller.isSyncing ? null : onSyncNow,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Sincronizar ahora'),
            ),
          ],
        ),
      ),
    );
  }
}
