import 'package:flutter/foundation.dart';

import 'Decodeable.dart';

class StorageItemAbstract {
  int id;
  String name;
  String description;
  String authorName;
  String categoryName;
  String seriesName;
  int column;
  int row;
  String position;

  StorageItemAbstract(
      {this.id,
      this.name,
      this.description,
      this.authorName,
      this.categoryName,
      this.seriesName,
      this.column,
      this.row,
      this.position});

  factory StorageItemAbstract.fromJson(Map<String, dynamic> json) {
    return StorageItemAbstract(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        authorName: json['author_name'],
        categoryName: json['category_name'],
        seriesName: json['series_name'],
        column: json['column'],
        row: json['row'],
        position: json['position']);
  }
}

class Location implements Decodeable {
  int id;
  String country;
  String city;
  String street;
  String building;
  String unit;
  String room_number;

  @override
  String toString() {
    return "${this.country} ${this.city} ${this.street} ${this.building} ${this.unit} ${this.room_number}";
  }

  Location(
      {this.id,
      this.building,
      this.street,
      this.country,
      this.city,
      this.room_number,
      this.unit});

  factory Location.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Location(
          id: json['id'],
          city: json['city'],
          building: json['building'],
          street: json['street'],
          country: json['country'],
          room_number: json['room_number'],
          unit: json['unit']);
    }
    return null;
  }

  @override
  Map toJson() {
    return {
      "country": country,
      "city": city,
      "street": street,
      "building": building,
      "unit": unit,
      "room_number": room_number
    };
  }
}

class Series implements Decodeable {
  int id;
  String name;
  String description;

  Series({this.id, this.name, this.description});

  factory Series.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Series(
          id: json['id'], name: json['name'], description: json['description']);
    }
    return null;
  }

  Map toJson() {
    return {"name": name, "description": description};
  }
}

class Author implements Decodeable {
  int id;
  String name;
  String description;

  @override
  String toString() {
    return 'Author{id: $id, name: $name, description: $description}';
  }

  Author({this.id, this.name, this.description});

  factory Author.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Author(
          id: json['id'], name: json['name'], description: json['description']);
    }
    return null;
  }

  Map toJson() {
    return {"name": name, "description": description};
  }
}

class Category implements Decodeable {
  int id;
  String name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Category(id: json['id'], name: json['name']);
    }
    return null;
  }

  Map toJson() {
    return {"name": name};
  }
}

class Position implements Decodeable {
  int id;
  String name;
  String description;

  Position({this.id, this.name, this.description});

  factory Position.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Position(
          id: json['id'],
          name: json['position'],
          description: json['description']);
    }
    return null;
  }

  Map toJson() {
    return {"position": name, "description": description};
  }
}

class StorageItemDetail {
  int id;
  String name;
  String description;
  Author author;
  Series series;
  Category category;
  Location location;
  Position position;
  int column;
  int row;
  double price;
  List<String> images;
  List<String> files;
  String qrCode;

  StorageItemDetail(
      {this.id,
      this.name,
      this.description,
      this.author,
      this.category,
      this.location,
      this.series,
      this.column,
      this.row,
      this.position,
      this.price,
      this.images,
      this.qrCode,
      this.files});

  factory StorageItemDetail.fromJson(Map<String, dynamic> json) {
    return StorageItemDetail(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        author: Author.fromJson(json['author_name']),
        category: Category.fromJson(json['category_name']),
        series: Series.fromJson(json['series_name']),
        location: Location.fromJson(json['location_name']),
        column: json['column'],
        row: json['row'],
        price: json['price'],
        position: Position.fromJson(json['position_name']),
        qrCode: json['qr_code'],
        images: json['images'].cast<String>(),
        files: json['files'].cast<String>());
  }
}
