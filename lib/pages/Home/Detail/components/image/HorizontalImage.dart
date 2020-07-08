import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalImage extends StatelessWidget {
  final List<String> images;
  final isLocal;

  HorizontalImage(this.images, {this.isLocal = false});

  Widget getImage(String imagePath) {
    return this.isLocal
        ? Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: 200,
          )
        : Image.network(
            imagePath,
            fit: BoxFit.cover,
            width: 200,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text("Images", style: TextStyle(color: Colors.white)),
            ),
            images.length > 0
                ? Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                    height: 200,
                    child: Scrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: getImage(images[index]),
                              ));
                        },
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text("No image yet"),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
