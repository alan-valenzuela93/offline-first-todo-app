import 'package:flutter/material.dart';

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({super.key, required this.value, required this.onChanged});

  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: 42,
      child: Checkbox(
        value: value,
        shape: const CircleBorder(),
        activeColor: const Color(0xFF10B981),
        checkColor: Colors.white,
        side: BorderSide(
          width: 1.8,
          color: value ? const Color(0xFF10B981) : colorScheme.outline,
        ),
        onChanged: (_) => onChanged(),
      ),
    );
  }
}
