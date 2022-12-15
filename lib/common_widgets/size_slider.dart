import 'package:flutter/material.dart';

class SizeSlider extends StatelessWidget {
  const SizeSlider({
    Key? key,
    required this.max,
    required this.selectedSize,
    required this.onChanged,
  }) : super(key: key);
  final double max;
  final double selectedSize;
  final Function(double) onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select size',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: 0.0,
                max: max,
                divisions: max.toInt(),
                value: selectedSize,
                onChanged: onChanged,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                selectedSize.toInt().toString(),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ],
    );
  }
}
