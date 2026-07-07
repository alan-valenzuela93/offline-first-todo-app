import 'package:flutter/material.dart';

class AboutDemoCard extends StatelessWidget {
  const AboutDemoCard({super.key});

  static const _items = [
    'Funcionamiento offline-first',
    'SQLite local en navegador usando WebAssembly',
    'Fallback automatico si SQLite Web no inicializa',
    'Cola de sincronizacion create/update/delete',
    'Sincronizacion contra API REST de Supabase',
    'Manejo de estados pendientes y errores',
    'Arquitectura separada por capas',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E8E5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.hub_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Qué demuestra esta demo',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              'Una cola local que funciona aun sin red y luego se reconcilia con Supabase REST.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            for (final item in _items)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.3,
                          fontWeight: FontWeight.w600,
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
