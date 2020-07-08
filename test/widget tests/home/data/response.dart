var detailResponse = {
  "id": 1,
  "name": "pc",
  "description": "some description",
  "price": 500.0,
  "quantity": 1,
  "column": 1,
  "row": 1,
  "qr_code": "",
  "unit": "USD",
  "created_time": "2020-07-01T09:46:31.211497Z",
  "author_name": {"id": 1, "name": "apple", "description": "some description"},
  "series_name": {
    "id": 1,
    "name": "MacBook",
    "description": "some description"
  },
  "category_name": {"id": 1, "name": "pc"},
  "location_name": {
    "id": 1,
    "country": "United States",
    "city": "Ames",
    "street": "some street",
    "building": "some building",
    "unit": "000",
    "room_number": "000",
    "name": "some position",
    "latitude": 42.015392622292964,
    "longitude": -93.67447041277822
  },
  "position_name": {
    "id": 1,
    "position": "case 1",
    "description": "description",
    "name": "somename",
    "uuid": "1b15ed9d-7216-4b78-b560-e36969744fc7",
  },
  "images": [],
  "files": [],
  "uuid": "465eaae8-9b50-4ad3-9e92-5e60bfcc5ed4",
  "files_objects": [],
  "images_objects": []
};

var homeResponse = {
  "count": 1,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "uuid": "465eaae8-9b50-4ad3-9e92-5e60bfcc5ed4",
      "name": "Computer",
      "description": "some description",
      "author": 1,
      "author_name": "Apple",
      "category_name": "Mac",
      "series_name": "MacBook",
      "column": 1,
      "row": 1,
      "unit": "USD",
      "position": "position1",
      "images": [
        {"id": 6, "image": "some image1.jpg"},
        {"id": 7, "image": "some image2.jpg"}
      ],
      "price": 500.0
    }
  ]
};
