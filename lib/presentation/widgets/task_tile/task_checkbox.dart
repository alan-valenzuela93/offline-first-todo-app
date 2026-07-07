import 'package:flutter/material.dart';

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({super.key, required this.value, required this.onChanged});

  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 42,
      child: Checkbox(
        value: value,
        shape: const CircleBorder(),
        side: const BorderSide(width: 1.7, color: Color(0xFF6D7D7A)),
        onChanged: (_) => onChanged(),
      ),
    );
  }
}
