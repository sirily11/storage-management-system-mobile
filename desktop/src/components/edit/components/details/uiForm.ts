export const authorSchema = {
    required: ["name", "description"],
    properties: {
        "name": {
            type: "string",
            title: "作者名"
        },
        "description": {
            type: "string",
            title: "作者简介"
        }
    }
}

export const categorySchema = {
    required: ["name"],
    properties: {
        "name": {
            type: "string",
            title: "类别名"
        }
    }
}

export const seriesSchema = {
    required: ["name", "description"],
    properties: {
        "name": {
            type: "string",
            title: "系列名"
        },
        "description": {
            type: "string",
            title: "系列简介"
        }
    }
}

export const positionSchema = {
    required: ["position", "description"],
    properties: {
        "position": {
            type: "string",
            title: "位置名"
        },
        "description": {
            type: "string",
            title: "位置简介"
        }
    }
}

export const locationSchema = {
    required: ["city", "country", "street", "building", "unit", "room_number"],
    properties: {
        "city": {
            type: "string",
            title: "城市"
        },
        "country": {
            type: "string",
            title: "国家"
        },
        "street": {
            type: "string",
            title: "街道"
        },
        "building": {
            type: "string",
            title: "大楼"
        },
        "unit": {
            type: "string",
            title: "单元"
        },
        "room_number": {
            type: "string",
            title: "房间号"
        }
    }
}