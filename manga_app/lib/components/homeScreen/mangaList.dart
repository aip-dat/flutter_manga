import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:manga_app/constants/constants.dart';
import 'package:manga_app/components/homeScreen/mangaCard.dart';

class MangaList extends StatefulWidget {
  const MangaList({super.key});

  @override
  State<MangaList> createState() => _MangaListState();
}

class _MangaListState extends State<MangaList> {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
// actions: [
//   IconButton(onPressed: (){
//     showSearch(context: context, delegate: CustomSearch(mangaList: mangaList));
//   }, icon: const Icon(Icons.search_outlined)),
// ],
// class CustomSearch extends SearchDelegate{
//   final List<Map<String, dynamic>> mangaList;
//
//   CustomSearch({
//     required this.mangaList,
//   });
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(onPressed: (){
//         query = '';
//       }, icon: const Icon(Icons.clear)),
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(onPressed: (){
//       close(context, null);
//     }, icon: const Icon(Icons.arrow_back));
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var item in mangaList) {
//       String mangaTitle = item['attributes']['alt'];
//       if (mangaTitle.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(mangaTitle);
//       }
//     }
//
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var item in mangaList) {
//       String mangaTitle = item['attributes']['alt'];
//       if (mangaTitle.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(mangaTitle);
//       }
//     }
//
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }