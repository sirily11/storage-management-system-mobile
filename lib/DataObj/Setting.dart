

import 'StorageItem.dart';

class SettingObj {
  List<Category> categories;
  List<Series> series;
  List<Author> authors;
  List<Location> locations;
  List<Position> positions;

  SettingObj(
      {this.categories,
      this.series,
      this.authors,
      this.positions,
      this.locations});

  factory SettingObj.fromJson(Map<String, dynamic> json) {
    List<Category> categories = [];
    List<Author> authors = [];
    List<Series> series = [];
    List<Location> locations = [];
    List<Position> positions = [];

    json['categories']?.forEach((data) {
      categories.add(Category.fromJson(data));
    });

    json['series']?.forEach((data) {
      series.add(Series.fromJson(data));
    });

    json['authors']?.forEach((data) {
      authors.add(Author.fromJson(data));
    });

    json['locations']?.forEach((data) {
      locations.add(Location.fromJson(data));
    });

    json['positions']?.forEach((data) {
      positions.add(Position.fromJson(data));
    });

    return SettingObj(
        categories: categories,
        series: series,
        authors: authors,
        locations: locations,
        positions: positions);
  }
}
