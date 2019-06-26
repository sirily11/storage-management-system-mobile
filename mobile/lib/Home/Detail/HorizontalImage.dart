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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text("Images"),
        ),
        images.length > 0
            ? Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: getImage(images[index]),
                        ));
                  },
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text("No image yet"),
                ),
              )
      ],
    );
  }
}
