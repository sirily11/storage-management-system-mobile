import 'Decodeable.dart';

class Result<T> {
  int count;
  String next;
  String previous;
  List<T> results;

  Result({this.count, this.next, this.previous, this.results});

  factory Result.fromJSON(Map<String, dynamic> json) {
    return Result(
        count: json['count'],
        results: json['results'],
        next: json['next'],
        previous: json['previous']);
  }
}

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

  @override
  String toString() {
    return "${this.name} ${this.seriesName}";
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
  String name;
  double longitude;
  double latitude;

  @override
  String toString() {
    return "${this.country} ${this.city} ${this.street} ${this.building} ${this.unit} ${this.room_number}";
  }

  Location({
    this.id,
    this.building,
    this.street,
    this.country,
    this.city,
    this.room_number,
    this.name,
    this.unit,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Location(
        id: json['id'],
        city: json['city'],
        building: json['building'],
        street: json['street'],
        country: json['country'],
        room_number: json['room_number'],
        name: json['name'],
        unit: json['unit'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "country": country,
      "city": city,
      "street": street,
      "building": building,
      "unit": unit,
      "room_number": room_number,
      "id": id,
      "longitude": longitude,
      "latitude": latitude,
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

  Map<String, dynamic> toJson() {
    return {"name": name, "description": description, "id": id};
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

  Map<String, dynamic> toJson() {
    return {"name": name, "description": description, "id": id};
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

  Map<String, dynamic> toJson() {
    return {"name": name, "id": id};
  }
}

class Position implements Decodeable {
  int id;
  String name;
  String description;
  String uuid;
  String imageURL;

  Position({
    this.id,
    this.name,
    this.description,
    this.uuid,
    this.imageURL,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Position(
          id: json['id'],
          name: json['position'],
          description: json['description'],
          uuid: json['uuid'],
          imageURL: json['image']);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {"position": name, "description": description, "id": id};
  }
}

class ImageObject implements Decodeable {
  int id;
  String image;

  ImageObject({this.id, this.image});

  factory ImageObject.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return ImageObject(id: json['id'], image: json['image']);
    }
    return null;
  }

  Map toJson() {
    return {"image": image};
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
  String unit;
  int column;
  int row;
  int quantity;
  double price;
  List<ImageObject> images;
  List<String> files;
  String qrCode;
  String uuid;
  DateTime createAt;

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
      this.files,
      this.unit,
      this.uuid,
      this.quantity,
      this.createAt});

  Map<String, dynamic> toJSON() {
    return {
      "name": this.name,
      "description": this.description,
      "price": this.price.toString(),
      "column": this.column.toString(),
      "row": this.row.toString(),
      "qr_code": this.qrCode.toString(),
      "unit": this.unit,
      "author_id": {"label": this.author?.name, "value": this.author?.id},
      "series_id": {"label": this.series?.name, "value": this.series?.id},
      "category_id": {"label": this.category?.name, "value": this.category?.id},
      "location_id": {"label": this.location?.name, "value": this.location?.id},
      "position_id": {"label": this.position?.name, "value": this.position?.id},
      "uuid": this.uuid,
      "quantity": this.quantity.toString()
    };
  }

  factory StorageItemDetail.fromJson(Map<String, dynamic> json) {
    List<ImageObject> images = [];

    json['images_objects']?.forEach((data) {
      images.add(ImageObject.fromJson(data));
    });
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
        images: images,
        unit: json['unit'],
        uuid: json['uuid'],
        quantity: json['quantity'],
        createAt: json['created_time'] != null
            ? DateTime.parse(json['created_time'])
            : null,
        files: json['files'].cast<String>());
  }
}
