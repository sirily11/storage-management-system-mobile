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

var homeResponseWithNext = {
  "count": 2,
  "next": "https://more.com",
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

var settingsResponse = {
  "categories": [
    {"id": 1, "name": "电脑"}
  ],
  "series": [
    {
      "id": 1,
      "name": "MacBook",
      "description":
          "MacBook Pro\nMacBookPro2017.png\nMacBook Pro 15 inch (2017) Touch Bar.jpg\n15英吋MacBook Pro 配備Touch Bar（2017年末）\n開發者\t蘋果公司\n類型\t筆記型電腦\n推出日期\t\n2006年1月10日（原始型號）\n2008年10月14日（第二代產品Unibody機型）\n2012年6月11日（第三代，配备Retina屏幕及全SSD硬盘）\n2015年春季（在原有基础上配置了Force Touch）\n2016年秋季（第四代，配备触控栏、雷雳3和第二代蝶式键盘）\n2017年夏季（更新第七代处理器）\n2018年夏季（更新第八代处理器，新增原彩显示技术和更静音的蝶式键盘，“嘿，Siri”随时就绪）\n2019年底（將具爭議的蝶式鍵盤改為剪刀式鍵盤）\n2006年1月10日，​14年前 （原始）\n2019年11月13日​（7個月前） （當前）\n作業系統\t\nOS X（2016年前）\nmacOS（2016年后）\n中央處理器\t\n2019 15inch cpu:i7-9750H 4.5GHZ i9-9880H 4.8GHZ\ni9-9980HK 5.0GHZ\n上代產品\tPowerBook G4\n相關文章\tMacBook、 MacBook Air、 iMac\n官方網站\twww.apple.com/macbook-pro/\nMacBook Pro是蘋果公司於2006年1月開始推出的Mac筆記型電腦系列，現已推出到第五代。它是繼iMac後第二款取代以PowerBook G4生產線的英特爾核心筆記型電腦。它也是MacBook家族中的高端機型，雖然在此之前已有17英寸版本但已經停產并只保留13以及16寸的產品。"
    }
  ],
  "authors": [
    {
      "id": 1,
      "name": "苹果",
      "description":
          "蘋果公司（英語：Apple Inc.），原稱蘋果电脑公司（英語：Apple Computer, Inc.），是总部位于美国加州庫比蒂諾的跨國科技公司。現時的業務包括设计、开发和销售消费电子、计算机软件、在线服务和个人计算机。与亚马逊，谷歌和微软一起被认为是四大技术公司之一。最初由史蒂夫·乔布斯、史蒂夫·沃茲尼克、罗纳德·韦恩创立于1976年4月1日，次年1月3日確定正式名稱為苹果电脑公司，主業是开发和销售个人计算机，至2007年1月9日在舊金山Macworld Expo（英语：Macworld Expo）上宣佈改名为苹果公司，象徵其业务重点转向消费电子领域。[4][5][6]"
    }
  ],
  "locations": [
    {
      "id": 1,
      "country": "United States",
      "city": "Ames",
      "street": "Pinon Dr",
      "building": "800",
      "unit": "109",
      "room_number": "109",
      "name": "United StatesAmes800",
      "latitude": 42.015392622292964,
      "longitude": -93.67447041277822
    }
  ],
  "positions": [
    {
      "id": 1,
      "position": "行李箱1",
      "description": "回国的行李箱之一。小号的，不是很大。蓝色的。里面装着大多数是贵重的随身行李。",
      "name": "行李箱1",
      "uuid": "1b15ed9d-7216-4b78-b560-e36969744fc7",
      "image":
          "https://storage-image.sfo2.digitaloceanspaces.com/storage-management-data/image_picker_43473FD6-A7B8-4358-A9B4-1F778B3E5FCF-578-00000018F4E914FD.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=MEWBOPAX6PDSC4B7I3QM%2F20200708%2Fsfo2%2Fs3%2Faws4_request&X-Amz-Date=20200708T224522Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=a4b50a26aefbcc297dace1f22930c793524d33bd24e32f2309e5d0a5a06f6135"
    }
  ]
};

var schemaResponse = {
  "fields": [
    {
      "label": "ID",
      "readonly": true,
      "extra": {},
      "name": "id",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "Item Name",
      "readonly": false,
      "extra": {"help": "Please Enter your item name", "default": ""},
      "name": "name",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
    {
      "label": "description",
      "readonly": false,
      "extra": {"help": "Please enter your item description"},
      "name": "description",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "price",
      "readonly": false,
      "extra": {"default": 0.0},
      "name": "price",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "quantity",
      "readonly": false,
      "extra": {"default": 1},
      "name": "quantity",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "column",
      "readonly": false,
      "extra": {"default": 1},
      "name": "column",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "row",
      "readonly": false,
      "extra": {"default": 1},
      "name": "row",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "qr code",
      "readonly": false,
      "extra": {},
      "name": "qr_code",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {
        "length": {"maximum": 10008}
      }
    },
    {
      "label": "unit",
      "readonly": false,
      "extra": {
        "choices": [
          {"label": "美元", "value": "USD"},
          {"label": "港币", "value": "HDK"},
          {"label": "人民币", "value": "CNY"}
        ],
        "default": "USD"
      },
      "name": "unit",
      "widget": "select",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "created time",
      "readonly": true,
      "extra": {},
      "name": "created_time",
      "widget": "datetime",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "author",
      "readonly": true,
      "extra": {"related_model": "storage-management/author"},
      "name": "author_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "series",
      "readonly": true,
      "extra": {"related_model": "storage-management/series"},
      "name": "series_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "category",
      "readonly": true,
      "extra": {"related_model": "storage-management/category"},
      "name": "category_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "location",
      "readonly": true,
      "extra": {"related_model": "storage-management/location"},
      "name": "location_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "detail position",
      "readonly": true,
      "extra": {"related_model": "storage-management/detailposition"},
      "name": "position_name",
      "widget": "foreignkey",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "images",
      "readonly": false,
      "extra": {"related_model": "storage-management/itemimage"},
      "name": "images",
      "widget": "tomany-table",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "files",
      "readonly": false,
      "extra": {"related_model": "storage-management/itemfile"},
      "name": "files",
      "widget": "tomany-table",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "author",
      "readonly": false,
      "extra": {"related_model": "storage-management/author"},
      "name": "author_id",
      "widget": "foreignkey",
      "required": true,
      "translated": false,
      "validations": {"presence": true}
    },
    {
      "label": "series",
      "readonly": false,
      "extra": {"related_model": "storage-management/series"},
      "name": "series_id",
      "widget": "foreignkey",
      "required": true,
      "translated": false,
      "validations": {"presence": true}
    },
    {
      "label": "category",
      "readonly": false,
      "extra": {"related_model": "storage-management/category"},
      "name": "category_id",
      "widget": "foreignkey",
      "required": true,
      "translated": false,
      "validations": {"presence": true}
    },
    {
      "label": "location",
      "readonly": false,
      "extra": {"related_model": "storage-management/location"},
      "name": "location_id",
      "widget": "foreignkey",
      "required": true,
      "translated": false,
      "validations": {"presence": true}
    },
    {
      "label": "detail position",
      "readonly": false,
      "extra": {"related_model": "storage-management/detailposition"},
      "name": "position_id",
      "widget": "foreignkey",
      "required": true,
      "translated": false,
      "validations": {"presence": true}
    },
    {
      "label": "uuid",
      "readonly": true,
      "extra": {"default": "79659b67-2ea5-4e02-863c-09f05dba6315"},
      "name": "uuid",
      "widget": "text",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "files",
      "readonly": true,
      "extra": {"related_model": "storage-management/itemfile"},
      "name": "files_objects",
      "widget": "tomany-table",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "images",
      "readonly": true,
      "extra": {"related_model": "storage-management/itemimage"},
      "name": "images_objects",
      "widget": "tomany-table",
      "required": false,
      "translated": false,
      "validations": {}
    }
  ],
};
