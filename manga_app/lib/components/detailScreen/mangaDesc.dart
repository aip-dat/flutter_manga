import 'package:manga_app/constants/constants.dart';
import 'package:flutter/material.dart';

class MangaDesc extends StatefulWidget {
  final String mangaDesc, mangaGenres;

  const MangaDesc({super.key, required this.mangaDesc, required this.mangaGenres});

  @override
  State<MangaDesc> createState() => _MangaDescState();
}

class _MangaDescState extends State<MangaDesc> {
  bool readMore = false;

  void toggleRead(){
    setState(() {
      readMore = !readMore;
    });
  }

  Widget overMultiLine(){
    return (widget.mangaDesc.trim()).split(" ").length > 30 ?
    GestureDetector(
      onTap: toggleRead,
      child: Text(readMore ? "Read less" : "Read more", style: const TextStyle(color: Constants.lightblue, fontSize:  15),),
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Giới thiệu:", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
            Text(
              widget.mangaDesc,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: readMore ? 128 : 3,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
            ),
            overMultiLine(),
            const Divider(),
            const Text("Thể loại:", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
            Text(widget.mangaGenres, style: const TextStyle(color: Colors.white, fontSize: 16),),
          ],
        ),
      ),
    );
  }
}
