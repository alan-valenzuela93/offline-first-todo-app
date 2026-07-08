import 'package:flutter/material.dart';

class TaskTileActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ColorScheme colorScheme;
  const TaskTileActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          tooltip: 'Editar',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        const SizedBox(width: 6),
        IconButton(
          tooltip: 'Eliminar',
          onPressed: onDelete,
          color: colorScheme.error,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}
