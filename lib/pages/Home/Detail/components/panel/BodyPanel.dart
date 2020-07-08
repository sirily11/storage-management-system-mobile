import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_mobile/DataObj/StorageItem.dart';
import 'package:storage_management_mobile/States/ItemProvider.dart';
import 'package:storage_management_mobile/States/LoginProvider.dart';
import 'package:storage_management_mobile/pages/Home/Detail/ItemDetailPage.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/AuthorDetail.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/LocationDetail.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/PositionDetail.dart';
import 'package:storage_management_mobile/pages/Home/Detail/SubDetail/SeriesDetail.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/item/ItemCard.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/panel/components/ButtonInfo.dart';
import 'package:storage_management_mobile/pages/Home/Detail/components/quantityEditPannel.dart';

enum Path { author, location, position, series }

/// Body Panel which contains info
class BodyPanel extends StatelessWidget {
  navigationTo(Path navTo, BuildContext context) {
    ItemProvider detailState =
        Provider.of<ItemProvider>(context, listen: false);
    Navigator.of(context).push(
      MaterialWithModalsPageRoute(builder: (context) {
        switch (navTo) {
          case Path.author:
            return AuthorDetail(detailState.item.author);
          case Path.series:
            return SeriesDetail(detailState.item.series);
          case Path.location:
            return LocationDetail(detailState.item.location);
          case Path.position:
            return PositionDetail(detailState.item.position);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemProvider detailState =
        Provider.of<ItemProvider>(context, listen: false);
    LoginProvider loginProvider = Provider.of(context, listen: false);
    StorageItemDetail item = detailState.item;
    return Column(
      children: <Widget>[
        Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  ButtonInfo(
                    label: "Price",
                    icon: Icons.label,
                    color: Colors.blue,
                    value: '${item.price} ${item.unit}',
                  ),
                  ButtonInfo(
                    label: "Column",
                    icon: Icons.view_column,
                    color: Colors.orange,
                    value: item.column.toString(),
                  ),
                  ButtonInfo(
                    label: "Row",
                    icon: Icons.reorder,
                    color: Colors.green,
                    value: item.row.toString(),
                  ),
                  ButtonInfo(
                    label: "Quantity",
                    icon: Icons.shopping_cart,
                    color: Colors.red,
                    value: item.quantity.toString(),
                  )
                ],
              ),
            ),
          ),
        ),
        CardInfo(
          info: [Info(title: "Description", subtitle: item.description)],
        ),
        CardInfo(
          info: [
            Info(
                title: "Author",
                subtitle: item?.author?.name,
                onPress: () {
                  navigationTo(Path.author, context);
                }),
            Info(title: "Category", subtitle: item?.category?.name),
            Info(
                title: "Series",
                subtitle: item?.series?.name,
                onPress: () {
                  navigationTo(Path.series, context);
                }),
          ],
        ),
        CardInfo(
          info: [
            Info(
                title: "Position",
                subtitle: item?.position?.name,
                onPress: () {
                  navigationTo(Path.position, context);
                }),
            Info(
                title: "Location",
                subtitle: item?.location?.toString(),
                onPress: () {
                  navigationTo(Path.location, context);
                }),
          ],
        ),
        if (loginProvider.hasLogined) QuantityEdit(),
        SizedBox(
          height: 100,
        )
      ],
    );
  }
}
