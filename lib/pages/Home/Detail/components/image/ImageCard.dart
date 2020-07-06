import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';

class ImageCard extends StatelessWidget {
  final List<ImageObject> imageSrc;

  ImageCard({@required this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      enableInfiniteScroll: false,
      height: MediaQuery.of(context).size.height - 300,
      items: imageSrc.map((i) {
        return Container(
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                child: Image.network(
                  i.image,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  // width: 1000,
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () async {
                    ItemProvider pageState =
                        Provider.of(context, listen: false);
                    await pageState.deleteImage(i.id);
                  },
                  icon: Icon(Icons.clear),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
