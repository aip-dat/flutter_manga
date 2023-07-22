import 'package:manga_app/constants/constants.dart';
import 'package:manga_app/screens/contentScreen.dart';
import 'package:flutter/material.dart';

class MangaChapter extends StatelessWidget {
  final List<Map<String, dynamic>> mangaChapters;
  final String mangaImg, mangaTitle, mangaUrl;

  const MangaChapter ({super.key, required this.mangaChapters, required this.mangaImg, required this.mangaTitle, required this.mangaUrl});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: mangaChapters.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index){
        return SizedBox(
        height: 48,
        width: double.infinity,
        child: Material(
          color: Constants.lightgray,
          child: InkWell(
            onTap: () => {
              //print(mangaChapters![index]['attributes']['href']),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContentScreen(
                    mangaChapter: mangaChapters[index]['attributes']['href'].toString(),
                    chapterTitle: mangaChapters[index]['title'].toString(),
                    mangaImg: mangaImg,
                    mangaTitle: mangaTitle,
                    mangaUrl: mangaUrl,
                    mangaChapters: mangaChapters,
                    selectedChapterIndex: index,
                  )))
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  mangaChapters[index]['title'],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
