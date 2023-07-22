import 'package:manga_app/constants/constants.dart';
import 'package:flutter/material.dart';

class MangaInfoBtn extends StatelessWidget {
  final IconData icon;
  final String title;

  const MangaInfoBtn({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 42, color: Constants.lightblue,),
        Text(title, style: const TextStyle(color: Colors.white),)
      ],
    );
  }
}
