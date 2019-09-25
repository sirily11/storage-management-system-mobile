import { SchemaList, Schema, Widget } from "../components/edit/JSONSchema/model/Schema"

describe("Test schema submit", () => {
    let l: Schema[] = [{
        name: "name",
        label: "name",
        readonly: false,
        required: false,
        widget: Widget.text,
        value: "1"
    }, {
        name: "description",
        label: "description",
        readonly: false,
        required: false,
        widget: Widget.text,
        value: "2"
    }]

    let schemaList: SchemaList;

    beforeEach(() => {
        schemaList = new SchemaList(l);
    })

    test("test on submit", () => {
        let result = schemaList.onSubmit()
        expect(result['name']).toBe("1")
        expect(result['description']).toBe("2")
    })
});