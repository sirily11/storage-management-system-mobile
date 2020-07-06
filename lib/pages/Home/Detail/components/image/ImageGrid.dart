import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';

import '../../../ConfirmDialog.dart';

class ImageGrid extends StatelessWidget {
  final List<ImageObject> imageSrc;

  ImageGrid({@required this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      itemCount: imageSrc.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      itemBuilder: (context, index) {
        var i = imageSrc[index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (c) => Dialog(
                child: Container(
                  child: Image.network(i.image),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: Stack(
              children: <Widget>[
                Image.network(
                  i.image,
                  fit: BoxFit.contain,
                  // width: 1000,
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      ItemProvider pageState =
                          Provider.of(context, listen: false);
                      showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(
                          title: "Do you want to delete?",
                          content: "Cannot undo this action",
                          onConfirm: () async {
                            await pageState.deleteImage(i.id);
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.clear),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
