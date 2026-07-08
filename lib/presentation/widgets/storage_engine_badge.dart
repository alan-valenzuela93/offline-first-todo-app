import 'package:flutter/material.dart';

class StorageEngineBadge extends StatelessWidget {
  const StorageEngineBadge({super.key, required this.storageEngineName});

  final String storageEngineName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFallback = storageEngineName.toLowerCase().contains('fallback');
    final title = isFallback
        ? 'Datos en almacenamiento local'
        : 'Datos en SQLite Web';
    final description = isFallback
        ? 'La app usa LocalStorage porque SQLite Web no se pudo iniciar.'
        : 'Las tareas se guardan localmente usando una base de datos SQLite FFI.';

    final themeColor = isFallback ? const Color(0xFFEC4899) : const Color(0xFF10B981); // Pink or Emerald
    final containerColor = isFallback ? const Color(0xFFFDF2F8) : const Color(0xFFECFDF5); // Light Pink or Light Emerald
    final iconData = isFallback ? Icons.warning_amber_rounded : Icons.dns_rounded;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeColor.withOpacity(0.24),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  iconData,
                  size: 20,
                  color: themeColor,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Text(
                      'Motor: $storageEngineName',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: themeColor,
                        fontWeight: FontWeight.w900,
                      ),
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
