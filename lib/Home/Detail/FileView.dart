import 'package:flutter/material.dart';

class FileView extends StatelessWidget {
  final List<String> files;

  FileView(this.files);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: files.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 3.6),
        itemBuilder: (context, index) {
          return FileCard(files[index]);
        },
      ),
    );
  }
}

class FileCard extends StatelessWidget {
  final String file;

  FileCard(this.file);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: <Widget>[Text(file), Icon(Icons.folder)],
        ),
      ),
    );
  }
}
