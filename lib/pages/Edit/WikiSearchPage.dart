import 'package:dartwiki/dartwiki.dart';
import 'package:flutter/material.dart';
import 'package:storage_management_mobile/pages/Edit/WikiDetailPage.dart';

class WikiSearchPage extends StatefulWidget {
  @override
  _WikiSearchPageState createState() => _WikiSearchPageState();
}

class _WikiSearchPageState extends State<WikiSearchPage> {
  Wikipedia wikipedia;
  WikiLocations locations = WikiLocations.en;

  @override
  void initState() {
    wikipedia = Wikipedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wiki Search"),
      ),
      // body: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextField(
      //         decoration: InputDecoration(
      //           filled: true,
      //           labelText: "Search",
      //         ),
      //         onSubmitted: (value) async {
      //           if (value != null && value.isNotEmpty) {
      //             await wikipedia.search(value);
      //           }
      //         },
      //       ),
      //     ),
      //     Row(
      //       children: [
      //         Radio(
      //           onChanged: (value) {
      //             _onChangeLocation(value);
      //           },
      //           value: WikiLocations.en,
      //           groupValue: locations,
      //         ),
      //         Text("en"),
      //         Radio(
      //           onChanged: (value) {
      //             _onChangeLocation(value);
      //           },
      //           value: WikiLocations.zh,
      //           groupValue: locations,
      //         ),
      //         Text("zh")
      //       ],
      //     ),
      //     StreamBuilder<WikiSearchResponse>(
      //       stream: wikipedia.stream,
      //       builder: (context, snapshot) {
      //         if (snapshot.hasError) {
      //           return Center(
      //             child: Text("${snapshot.error}"),
      //           );
      //         }
      //         if (!snapshot.hasData) {
      //           return Center(
      //             child: Text("No data"),
      //           );
      //         }

      //         return Expanded(
      //           child: Scrollbar(
      //             child: ListView.separated(
      //               separatorBuilder: (context, index) => Divider(),
      //               itemCount: snapshot.data.searchResults.length,
      //               itemBuilder: (context, index) {
      //                 var result = snapshot.data.searchResults[index];
      //                 return ListTile(
      //                   title: Text("${result.title}"),
      //                   onTap: () async {
      //                     String content = await Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => WikiDetailPage(
      //                           wikipedia: wikipedia,
      //                           title: result.title,
      //                         ),
      //                       ),
      //                     );
      //                     if (content != null) {
      //                       Navigator.pop(context, content);
      //                     }
      //                   },
      //                   subtitle: Text(
      //                     "${result.url}",
      //                     maxLines: 1,
      //                     overflow: TextOverflow.ellipsis,
      //                   ),
      //                 );
      //               },
      //             ),
      //           ),
      //         );
      //       },
      //     )
      //   ],
      // ),
    );
  }

  void _onChangeLocation(value) {
    wikipedia.wikiLocation = value;
    setState(() {
      locations = value;
    });
  }
}
