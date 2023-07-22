import 'package:manga_app/components/detailScreen/mangaChapter.dart';
import 'package:manga_app/components/detailScreen/mangaDesc.dart';
import 'package:manga_app/components/detailScreen/mangaInfo.dart';
import 'package:manga_app/constants/constants.dart';
import 'package:manga_app/widgets/HorDivider.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

import 'homeScreen.dart';

class DetailScreen extends StatefulWidget {
  final String mangaImg, mangaTitle, mangaUrl;
  const DetailScreen({super.key, required this.mangaImg, required this.mangaTitle, required this.mangaUrl});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String mangaGenres = '';
  String mangaAuthor = '';
  String mangaStatus = '';
  String mangaDesc = '';
  String mangaViews = '';
  List<Map<String, dynamic>>? mangaDetail;
  List<Map<String, dynamic>>? mangaDescList;
  List<Map<String, dynamic>>? mangaGenresList;
  List<Map<String, dynamic>> mangaChapters = [];
  bool dataFetch = false;

  void getMangaInfo() async {
    final webScraper = WebScraper(Constants.baseUrl);
    var uri = Uri.parse(widget.mangaUrl);
    var path = uri.path;

    if (await webScraper.loadWebPage(path)) {
      mangaDetail = webScraper.getElement(
          'ul.list-info > li > p.col-xs-9', []
      );
      mangaDescList = webScraper.getElement(
          'div.story-detail-info.detail-content > p', []
      );
      mangaChapters = webScraper.getElement(
          'div.works-chapter-list > div.works-chapter-item > div.col-md-10.col-sm-10.col-xs-8.name-chap > a', ['href']
      );
      mangaGenresList = webScraper.getElement(
          'ul.list01 > li.li03 > a', []
      );
    }
    mangaAuthor = mangaDetail![0]['title'].toString().trim();
    mangaStatus = mangaDetail![1]['title'].toString().trim();
    mangaViews = mangaDetail![4]['title'].toString().trim();

    if(mangaDescList!.isNotEmpty){
      mangaDesc = mangaDescList![0]['title'].toString();
    } else {
      mangaDescList = webScraper.getElement(
          'div.story-detail-info.detail-content > a', []
      );
      mangaDesc = '${mangaDescList![0]['title']} ${mangaDescList![1]['title']}';
    }

    mangaGenres = mangaGenresList!.map((genre) => genre['title'].toString()).join(', ');

    // for (var chapter in mangaChapters!) {
    //   chapter['title'] = chapter['title'].toString().trim().replaceAll(RegExp(r' {2,}'), '');
    // }
    //print(mangaChapters);
    setState(() {
      dataFetch = true;
    });
  }


  @override
  void initState() {
    super.initState();
    getMangaInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.black,
      appBar: AppBar(
        title: Text(widget.mangaTitle),
        centerTitle: true,
        backgroundColor: Constants.darkgray,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: dataFetch ? Container(
        height: screenSize.height,
        width: screenSize.width,
        color: Constants.lightgray,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MangaInfo(
                mangaImg: widget.mangaImg,
                mangaAuthor: mangaAuthor,
                mangaStatus: mangaStatus,
                mangaViews: mangaViews,
              ),
              const HorDivider(),
              MangaDesc(mangaDesc: mangaDesc, mangaGenres: mangaGenres,),
              const HorDivider(),
              MangaChapter(mangaChapters: mangaChapters, mangaImg: widget.mangaImg, mangaTitle: widget.mangaTitle, mangaUrl: widget.mangaUrl,),
            ],
          ),
        ),
      ) : const Center(child: CircularProgressIndicator(),),
    );
  }
}
