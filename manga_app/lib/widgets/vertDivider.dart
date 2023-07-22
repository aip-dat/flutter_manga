import 'package:flutter/material.dart';

class VertDivider extends StatelessWidget {
  const VertDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      color: Colors.white,
      indent: 10,
      endIndent: 10,
      thickness: 1,
    );
  }
}
