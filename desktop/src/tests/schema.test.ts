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

describe("Test 2", () => {
    test("default value will be assign to value", () => {
        let l: Schema[] = [{
            name: "name",
            label: "name",
            readonly: false,
            required: false,
            extra: { default: "1" },
            widget: Widget.text,
        }, {
            name: "description",
            label: "description",
            readonly: false,
            required: false,
            widget: Widget.text,
            extra: { default: 1 }
        }]

        let schemaList = new SchemaList(l);
        expect(schemaList.schemaList[0].value).toBe("1")
        expect(schemaList.schemaList[1].value).toBe(1)
    })

    test("forign field with value", () => {
        let l: Schema[] = [{
            name: "name",
            label: "name",
            readonly: false,
            required: false,
            extra: { default: "1" },
            widget: Widget.foreignkey,
        }]

        let schemaList = new SchemaList(l);
        schemaList.merge({ "name": { name: "a", value: 1 } })
        expect(schemaList.schemaList[0].choice).toBeDefined()
        expect(schemaList.schemaList[0].choice && schemaList.schemaList[0].choice.value).toBe(1)
        expect(schemaList.schemaList[0].value).toBe(1)

    })
})