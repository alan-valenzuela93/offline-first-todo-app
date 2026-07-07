import 'package:flutter/material.dart';

class StorageEngineBadge extends StatelessWidget {
  const StorageEngineBadge({super.key, required this.storageEngineName});

  final String storageEngineName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFallback = storageEngineName.toLowerCase().contains('fallback');
    final title = isFallback
        ? 'Datos guardados en el navegador'
        : 'Datos guardados con SQLite Web';
    final description = isFallback
        ? 'La app usa un respaldo local porque SQLite Web no inicio.'
        : 'Las tareas se guardan localmente antes de sincronizar.';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFallback ? const Color(0xFFE7CFD9) : const Color(0xFFD2E6E1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: isFallback
                    ? colorScheme.tertiaryContainer
                    : colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  isFallback ? Icons.storage_outlined : Icons.dataset_outlined,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Motor: $storageEngineName',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
