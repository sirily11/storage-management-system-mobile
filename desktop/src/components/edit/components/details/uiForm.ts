export const authorSchema = {
    // required: ["authorName", "authorDescription"],
    properties: {
        "authorName": {
            type: "string",
            title: "作者名"
        },
        "authorDescription": {
            type: "string",
            title: "作者简介"
        }
    }
}