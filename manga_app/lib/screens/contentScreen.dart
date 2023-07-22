import 'package:manga_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:manga_app/screens/detailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ContentScreen extends StatefulWidget {
  final String mangaChapter, chapterTitle, mangaImg, mangaTitle, mangaUrl;
  final List<Map<String, dynamic>> mangaChapters;
  final int selectedChapterIndex;

  const ContentScreen({Key? key, required this.mangaChapter, required this.chapterTitle, required this.mangaImg, required this.mangaTitle, required this.mangaUrl, required this.mangaChapters, required this.selectedChapterIndex}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  List<String>? contentPages;
  List<String>? directChapter;
  String? previousChapter;
  String? nextChapter;
  String? strChapter;
  bool dataFetched = false;

  void getContent() async {
    final headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
    };

    final response = await http.get(Uri.parse(widget.mangaChapter), headers: headers);

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final imageElements = document.querySelectorAll('div.page-chapter > img');
      contentPages = imageElements.map((element) => element.attributes['src']!).toList();

      final directElements = document.querySelectorAll('div.chapter_content > div.chapter_control');
      if (directElements.isNotEmpty) {
        final previousChapterLink = directElements[0].querySelector('a.prev.control-button');
        final nextChapterLink = directElements[0].querySelector('a.next.control-button');

        previousChapter = previousChapterLink?.attributes['href'];
        nextChapter = nextChapterLink?.attributes['href'];
      }
    }

    setState(() {
      dataFetched = true;
    });
  }

  int selectedChapter(bool option) {
    int index = widget.selectedChapterIndex;

    if (option) {
      index = widget.selectedChapterIndex + 1;
      if (index >= widget.mangaChapters.length) {
        index = widget.mangaChapters.length - 1;
      }
    } else {
      index = widget.selectedChapterIndex - 1;
      if (index < 0) {
        index = 0;
      }
    }

    return index;
  }



  @override
  void initState() {
    super.initState();
    getContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.black,
      appBar: AppBar(
        title: Text(widget.chapterTitle),
        centerTitle: true,
        backgroundColor: Constants.darkgray,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  mangaImg: widget.mangaImg,
                  mangaTitle: widget.mangaTitle,
                  mangaUrl: widget.mangaUrl,
                ),
              ),
            );
          },
        ),
      ),
      body: dataFetched
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: contentPages!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  child: CachedNetworkImage(
                    imageUrl: contentPages![index],
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) {
                      return Image.network(
                        Constants.errorImg,
                        fit: BoxFit.cover,
                      );
                    },
                ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (previousChapter != null && previousChapter!.isNotEmpty && previousChapter! != "javascript:void(0);") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentScreen(
                          mangaChapter: previousChapter!,
                          chapterTitle: widget.mangaChapters[selectedChapter(true)]['title'].toString(),
                          mangaImg: widget.mangaImg,
                          mangaTitle: widget.mangaTitle,
                          mangaUrl: widget.mangaUrl,
                          mangaChapters: widget.mangaChapters,
                          selectedChapterIndex: selectedChapter(true),
                        ),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      // Check if the button is disabled (e.g., nextChapter is null, empty, or "javascript:void(0)")
                      if (previousChapter == null || previousChapter!.isEmpty || previousChapter! == "javascript:void(0);") {
                        return Constants.lightgray; // Set the button color to Constants.lightgray
                      }
                      return Constants.lightblue; // Set the button color to blue when enabled
                    },
                  ),
                ),
                child: const Text('Chap trước'),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(6, 0, 1, 0),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                height: 42,
                child: DropdownButton<int>(
                  borderRadius: BorderRadius.circular(10),
                  value: widget.selectedChapterIndex,
                  onChanged: (int? newIndex) {
                    // Navigating to the selected chapter here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentScreen(
                          mangaChapter: widget.mangaChapters[newIndex!]['attributes']['href'].toString(),
                          chapterTitle: widget.mangaChapters[newIndex]['title'].toString(),
                          mangaImg: widget.mangaImg,
                          mangaTitle: widget.mangaTitle,
                          mangaUrl: widget.mangaUrl,
                          mangaChapters: widget.mangaChapters,
                          selectedChapterIndex: newIndex,
                        ),
                      ),
                    );
                  },
                  items: List.generate(
                    widget.mangaChapters.length,
                        (index) => DropdownMenuItem<int>(
                      value: index,
                      child: Text(widget.mangaChapters[index]['title']),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nextChapter != null && nextChapter!.isNotEmpty && nextChapter! != "javascript:void(0);") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentScreen(
                          mangaChapter: nextChapter!,
                          chapterTitle: widget.mangaChapters[selectedChapter(false)]['title'].toString(),
                          mangaImg: widget.mangaImg,
                          mangaTitle: widget.mangaTitle,
                          mangaUrl: widget.mangaUrl,
                          mangaChapters: widget.mangaChapters,
                          selectedChapterIndex: selectedChapter(false),
                        ),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      // Check if the button is disabled (e.g., nextChapter is null, empty, or "javascript:void(0)")
                      if (nextChapter == null || nextChapter!.isEmpty || nextChapter! == "javascript:void(0);") {
                        return Constants.lightgray; // Set the button color to Constants.lightgray
                      }
                      return Constants.lightblue; // Set the button color to blue when enabled
                    },
                  ),
                ),
                child: const Text('Chap sau'),
              ),

            ],
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}
