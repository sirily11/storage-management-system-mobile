import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:storage_management_mobile/pages/utils/ConfirmDialog.dart';

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
                child: CachedNetworkImage(
                  key: Key("image-${i.id}"),
                  imageUrl: i.image,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Text("image"),
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () async {
                    ItemProvider pageState =
                        Provider.of(context, listen: false);

                    var confirm = await showConfirmDialog(context,
                        title: "Delete image",
                        content: "Do  you want to delete this?");
                    if (confirm) {
                      await pageState.deleteImage(i.id);
                    }
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
