import 'package:dartwiki/dartwiki.dart';
import 'package:flutter/material.dart';

class WikiDetailPage extends StatelessWidget {
  final String title;
  final Wikipedia wikipedia;
  WikiDetailPage({@required this.title, @required this.wikipedia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
      ),
      // body: FutureBuilder<WikiQueryResponse>(
      //   future: wikipedia.getPage(title, useHtml: false),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Center(
      //         child: Text("${snapshot.error}"),
      //       );
      //     }
      //     if (!snapshot.hasData) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

      //     var page = snapshot.data.query.pages.entries
      //         .map((e) => e.value)
      //         .toList()
      //         .first;

      //     return Container(
      //       height: MediaQuery.of(context).size.height,
      //       child: Stack(
      //         children: [
      //           SingleChildScrollView(
      //             child: Column(
      //               children: [
      //                 ListTile(
      //                   title: Text("$title"),
      //                   subtitle: SelectableText("${page.extract}"),
      //                 )
      //               ],
      //             ),
      //           ),
      //           Positioned(
      //             bottom: 40,
      //             width: MediaQuery.of(context).size.width,
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: RaisedButton(
      //                 onPressed: () {
      //                   String content = page.extract.split("\n")[0];
      //                   Navigator.pop(context, content);
      //                 },
      //                 child: Text("Use this"),
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
