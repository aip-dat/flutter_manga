import 'package:manga_app/widgets/mangaInfoBtn.dart';
import 'package:manga_app/widgets/vertDivider.dart';
import 'package:flutter/material.dart';

class MangaInfo extends StatelessWidget {
  final String mangaImg, mangaAuthor, mangaStatus, mangaViews;

  const MangaInfo({super.key, required this.mangaImg, required this.mangaAuthor, required this.mangaStatus, required this.mangaViews});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 185,
                  width: 145,
                  child: Image.network(mangaImg,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace){
                      return Image.network(
                        'https://th.bing.com/th/id/OIP.ObEbZ_saxjzdSXaLxeivGwHaE6?pid=ImgDet&rs=1',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Text("Tác giả $mangaAuthor - Truyện $mangaStatus", style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                Text("$mangaViews Lượt xem", style: const TextStyle(color: Colors.white, fontSize: 15),)
              ],
            ),
          )),

          const SizedBox(
            height: 64,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MangaInfoBtn(icon: Icons.play_arrow_outlined, title: "Read"),
                VertDivider(),
                MangaInfoBtn(icon: Icons.list, title: "Chapters"),
                VertDivider(),
                MangaInfoBtn(icon: Icons.favorite_outline, title: "Favorite"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
