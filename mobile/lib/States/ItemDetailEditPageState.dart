import 'package:flutter/widgets.dart';
import 'package:mobile/DataObj/StorageItem.dart';

class ItemDetailEditPageState with ChangeNotifier {
  bool isLoading = false;

  // authors
  List<Author> authors = [];

  // categories
  List<Category> categories = [];

  // detail position
  List<Position> positions = [];

  // Series
  List<Series> series = [];

  // Detail-location
  List<Location> locations = [];

  // item images
  List<String> images = [];

  // Selected author's id
  int selectedAuthor;

  // Selected category
  int selectedCategory;

  // Selected position
  int selectedPosition;

  // Selected series
  int selectedSeries;

  // Selected location
  int selectedLocation;

  String itemName = "";

  String itemDescription = "";

  String qrCode = "";

  updateAll(
      {List<Category> categories,
      List<Series> series,
      List<Author> authors,
      List<Location> locations,
      List<Position> positions}) {
    this.categories = categories;
    this.series = series;
    this.authors = authors;
    this.locations = locations;
    this.positions = positions;
    this.selectedAuthor = null;
    this.selectedCategory = null;
    this.selectedPosition = null;
    this.selectedSeries = null;
    this.selectedLocation = null;
    this.selectedPosition = null;
    this.qrCode = null;
//    notifyListeners();
  }

  update() {
    notifyListeners();
  }
}
