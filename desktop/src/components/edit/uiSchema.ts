interface Schema {
    title: "创建物品" | "更新物品";
    description: string;
    type: string;
    properties: any

}

// "selectWidgetOptions": {
//     "title": "Custom select widget with options",
//     "type": "string",
//     "enum": [
//       "1",
//       "2"
//     ],
//     "enumNames": [
//       "Foo",
//       "Bar"
//     ]
//   }

export let schema: Schema = {
    title: "创建物品",
    description: "创建新的物品",
    type: "object",
    properties: {
        "itemName": {
            "type": "string",
            "title": "物品名称",
        },
        "textarea": {
            "type": "string",
            "title": "物品简介",
        },
        "itemprice": {
            "type": "number",
            "title": "物品价格",
        },
        "itemCol": {
            "type": "integer",
            "title": "物品列",
        },
        "itemRow": {
            "type": "string",
            "title": "物品行",
        },
        "selectWidgetOptions": {
            "title": "物品作者",
            "type": "string",
            "enum": [
                "1",
                "2"
            ],
            "enumNames": [
                "哈利波特",
                "李其炜"
            ]
        }
    }

}