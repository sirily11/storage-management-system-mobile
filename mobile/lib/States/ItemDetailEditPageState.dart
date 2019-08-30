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
  int _selectedAuthor;

  // Selected category
  int _selectedCategory;

  // Selected position
  int _selectedPosition;

  // Selected series
  int _selectedSeries;

  // Selected location
  int _selectedLocation;

  String itemName = "";

  String itemDescription = "";

  String qrCode = "";

  int col = 0;

  int row = 0;

  double price = 0;

  String unit;

  /**
   * Init setting page
   */
  updateItem(StorageItemDetail item) {
    selectedLocation = item.location?.id;
    selectedAuthor = item.author?.id;
    selectedCategory = item.category?.id;
    selectedPosition = item.position?.id;
    selectedSeries = item.series?.id;
    itemDescription = item.description;
    itemName = item.name;
    col = item.column;
    qrCode = item.qrCode;
    row = item.row;
    price = item.price;
    unit = item.unit;
  }

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

  set selectedAuthor(int author) {
    this._selectedAuthor = author;
    notifyListeners();
  }

  get selectedAuthor => this._selectedAuthor;

  set selectedSeries(int series) {
    this._selectedSeries = series;
    notifyListeners();
  }

  get selectedSeries => this._selectedSeries;

  set selectedCategory(int category) {
    this._selectedCategory = category;
    notifyListeners();
  }

  get selectedCategory => this._selectedCategory;

  set selectedLocation(int location) {
    this._selectedLocation = location;
    notifyListeners();
  }

  get selectedLocation => this._selectedLocation;

  set selectedPosition(int position) {
    this._selectedPosition = position;
    notifyListeners();
  }

  get selectedPosition => this._selectedPosition;

  edit(int selectedAuthor, int selectedSeries, int selectedCategory,
      int selectedLocation, int selectedPosition, String unit) {
    this._selectedPosition = selectedPosition;
    this._selectedSeries = selectedSeries;
    this._selectedLocation = selectedLocation;
    this._selectedAuthor = selectedAuthor;
    this.selectedCategory = selectedCategory;
    this.unit = unit;
    notifyListeners();
  }

  clear() {
    this._selectedPosition = null;
    this._selectedSeries = null;
    this._selectedLocation = null;
    this._selectedAuthor = null;
    this.selectedCategory = null;
    this.unit = null;
    notifyListeners();
  }

  Map<String, dynamic> toSchemaValues() {
    return {
      "author_name": {
        "name": this.authors.firstWhere((a) => a.id == this.selectedAuthor),
        "id": this.selectedAuthor
      },
    };
  }

  Map<String, dynamic> toSchemaSelections() {
    return {
      "author_name":
          this.authors.map((a) => {"name": a.name, "id": a.id}).toList()
    };
  }

  update() {
    notifyListeners();
  }
}
