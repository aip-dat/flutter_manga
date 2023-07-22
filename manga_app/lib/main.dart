import 'package:manga_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comic App',
      home: HomeScreen(),
      // home: DetailScreen(
      //   mangaImg: "https://nettruyenco.vn/public/images/comics/bien-su-cua-cuoc-chien.jpg",
      //   mangaTitle: "Biên Sử Của Cuộc Chiến",
      //   mangaUrl: "https://nettruyenco.vn/truyen-tranh/bien-su-cua-cuoc-chien-3000013987",
      // ),
    );
  }
}

