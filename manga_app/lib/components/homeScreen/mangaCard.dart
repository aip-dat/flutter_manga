import 'package:manga_app/constants/constants.dart';
import 'package:manga_app/screens/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MangaCard extends StatelessWidget {
  final String mangaImg;
  final String mangaTitle;
  final String mangaUrlList;

  const MangaCard({
    Key? key,
    required this.mangaImg,
    required this.mangaTitle,
    required this.mangaUrlList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 130,
      color: Constants.darkgray,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                mangaImg: mangaImg,
                mangaTitle: mangaTitle,
                mangaUrl: mangaUrlList,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              flex: 75,
              child: CachedNetworkImage(
                imageUrl: mangaImg,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return Image.network(
                    Constants.errorImg,
                    fit: BoxFit.cover,
                  );
                },
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            Expanded(
              flex: 25,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  mangaTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

