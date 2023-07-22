import 'package:manga_app/constants/constants.dart';
import 'package:manga_app/widgets/botNavItem.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import '../components/homeScreen/mangaCard.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectNavIndex = 0;
  bool mangaLoaded = false;
  List<Map<String, dynamic>> mangaList = [];
  List<Map<String, dynamic>> mangaUrlList = [];
  List<Map<String, dynamic>> mangaPages = [];
  int currentPage = 1;
  int lastPageNumber = 10;
  final webscraper = WebScraper(Constants.baseUrl);
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchManga();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      mangaLoaded = false;
      fetchManga();
    }
  }

  void fetchManga() async {
    if (currentPage <= lastPageNumber) {
      if (await webscraper.loadWebPage('/truyen-moi-cap-nhat/trang-$currentPage.html')){
        mangaPages = webscraper.getElement('div.page_redirect > a', ['href']);

        List<Map<String, dynamic>> currentPageMangaList =
        webscraper.getElement('ul.list_grid.grid > li > div.book_avatar > a > img', ['src', 'alt']);
        List<Map<String, dynamic>> currentPageMangaUrlList =
        webscraper.getElement('ul.list_grid.grid > li > div.book_avatar > a', ['href']);

        mangaList.addAll(currentPageMangaList);
        mangaUrlList.addAll(currentPageMangaUrlList);
      }
      currentPage++;
      setState(() {
        mangaLoaded = true;
      });
    }
  }

  String extractPageFromUrl(String url) {
    String page = '';
    RegExp regExp = RegExp(r'trang-(\d+)');
    Match? match = regExp.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      page = '${match.group(1)}';
    }
    return page;
  }

  void searchManga(String query) {
    if (query.isEmpty) {

    } else {
      setState(() {
        // Filter the manga cards based on the search query
        mangaList = mangaList.where((manga) {
          String title = manga['attributes']['alt'].toString().toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void navBarTap(int index){
    setState(() {
      selectNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(mangaLoaded && mangaPages.isNotEmpty){
      lastPageNumber = int.parse(extractPageFromUrl(mangaPages.last['attributes']['href']));
    }

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.black,
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    searchManga(searchController.text);
                  },
                ),
                hintText: 'Search ...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        backgroundColor: Constants.darkgray,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        )
      ),
      body: mangaLoaded ? Container(
        height: screenSize.height,
        width: double.infinity,
        color: Constants.black,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            spacing: 6.6,
            runSpacing: 11,
            alignment: WrapAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 33,
                padding: const EdgeInsets.only(left: 15, top: 7.5),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Free Comics",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              for (int i = 0; i < mangaList.length; i++)
                MangaCard(
                  mangaImg: mangaList[i]['attributes']['src'],
                  mangaTitle: mangaList[i]['attributes']['alt'],
                  mangaUrlList: mangaUrlList[i]['attributes']['href'],
                ),
            ],
          ),
        ),
      ) : const Center(child: CircularProgressIndicator(),),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Constants.darkgray,
        selectedItemColor: Constants.lightblue,
        unselectedItemColor: Colors.white,
        currentIndex: selectNavIndex,
        onTap: navBarTap,
        items: [
          botNavItem(Icons.explore_outlined, "Explore"),
          botNavItem(Icons.favorite_outline_outlined, "Favorite"),
          botNavItem(Icons.watch_later_outlined, "Recent"),
          botNavItem(Icons.person_outline_outlined, "Account"),
        ],
      ),
    );
  }
}


