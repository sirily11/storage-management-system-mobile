import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalImage extends StatelessWidget {
  final List<String> images;

  HorizontalImage(this.images);

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
                      child: Image.network(images[index]),
                    );
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
