import 'package:flutter/material.dart';

class LabeledCheckBox extends StatelessWidget {
  const LabeledCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool? value;
  final void Function(bool? value) onChanged;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
      ),
      label,
    ]);
  }
}
