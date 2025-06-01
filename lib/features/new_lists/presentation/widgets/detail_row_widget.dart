import 'package:flutter/material.dart';

// Detail Row Widget
class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   width: 80,
        //   child: Text(
        //     '$label:',
        //     style: TextStyle(
        //       fontSize: 12,
        //       color: Colors.grey[600],
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
