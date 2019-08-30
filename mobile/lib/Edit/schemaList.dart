Map<String, dynamic> schema = {
  "author_name": {
    "type": "nested object",
    "required": false,
    "read_only": true,
    "label": "Author name",
    "children": {
      "id": {
        "type": "integer",
        "required": false,
        "read_only": true,
        "label": "ID"
      },
      "name": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Name",
        "max_length": 128
      },
      "description": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Description",
        "max_length": 1024
      }
    }
  },
  // "series_name": {
  //   "type": "nested object",
  //   "required": false,
  //   "read_only": true,
  //   "label": "Series name",
  //   "children": {
  //     "id": {
  //       "type": "integer",
  //       "required": false,
  //       "read_only": true,
  //       "label": "ID"
  //     },
  //     "name": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Name",
  //       "max_length": 128
  //     },
  //     "description": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Description",
  //       "max_length": 1024
  //     }
  //   }
  // },
  // "category_name": {
  //   "type": "nested object",
  //   "required": false,
  //   "read_only": true,
  //   "label": "Category name",
  //   "children": {
  //     "id": {
  //       "type": "integer",
  //       "required": false,
  //       "read_only": true,
  //       "label": "ID"
  //     },
  //     "name": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Name",
  //       "max_length": 128
  //     }
  //   }
  // },
  // "location_name": {
  //   "type": "nested object",
  //   "required": false,
  //   "read_only": true,
  //   "label": "Location name",
  //   "children": {
  //     "id": {
  //       "type": "integer",
  //       "required": false,
  //       "read_only": true,
  //       "label": "ID"
  //     },
  //     "country": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Country",
  //       "max_length": 128
  //     },
  //     "city": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "City",
  //       "max_length": 128
  //     },
  //     "street": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Street",
  //       "max_length": 128
  //     },
  //     "building": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Building",
  //       "max_length": 128
  //     },
  //     "unit": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Unit",
  //       "max_length": 128
  //     },
  //     "room_number": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Room number",
  //       "max_length": 128
  //     }
  //   }
  // },
  // "position_name": {
  //   "type": "nested object",
  //   "required": false,
  //   "read_only": true,
  //   "label": "Position name",
  //   "children": {
  //     "id": {
  //       "type": "integer",
  //       "required": false,
  //       "read_only": true,
  //       "label": "ID"
  //     },
  //     "position": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Position",
  //       "max_length": 1024
  //     },
  //     "description": {
  //       "type": "string",
  //       "required": false,
  //       "read_only": false,
  //       "label": "Description",
  //       "max_length": 1024
  //     }
  //   }
  // },
};
