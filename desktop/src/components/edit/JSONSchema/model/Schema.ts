import { FieldIcon } from "./Icon";
import { FieldAction } from "./Action";
import { string } from "prop-types";


interface Extra {
    default?: any;
    help?: string;
    related_model?: string;
    choices?: Choice[]

}

export enum Widget {
    text = "text",
    number = "number",
    datetime = "datetime",
    foreignkey = "foreignkey",
    unknown = "unknown",
    select = "select",
    tomanyTable = "tomany-table"
}

interface Validation {
    length: Length

}

export interface Choice {
    label: string;
    value: any;
}

interface Length {
    maximum?: number;
    minimum?: number;
}

export interface Schema {
    label: string;
    readonly: boolean;
    /// Could be null
    extra?: Extra;
    /// Map's key
    name: string;
    /// If widget type is not defined in the enum, then
    /// return widgetType.unknown
    widget: Widget | string;
    required: boolean;
    /// could be null
    validations?: Validation;
    /// this is value will be displayed at screen if set,
    /// else null
    value?: any;
    /// Set this value only if the field includes selection
    choice?: Choice;
    /// icon for the field
    /// this will be set through the params of JSONForm widget
    icon?: FieldIcon;
    /// action for the field
    /// this will be set through the params of JSONForm widget
    action?: FieldAction;

}



export class SchemaList {

    schemaList: Schema[];

    constructor(schemas: Schema[]) {
        schemas.forEach(s => {
            if (s.extra && s.extra.default) {
                s.value = s.extra.default
            }
        })
        this.schemaList = schemas;
    }

    merge(values: { [key: string]: any }) {
        this.schemaList = this.schemaList.map((s) => {
            if (values[s.name]) {
                let value = values[s.name];
                if (s.widget == Widget.select) {
                    let choice: Choice | undefined = s.extra
                        && s.extra.choices
                        && s.extra.choices.find((c) => c.value === value)
                    s.choice = choice;
                } else if (s.widget == Widget.foreignkey) {
                    let choice: Choice = value;
                    s.choice = choice;
                    s.value = value.value;
                } else {
                    s.value = value;
                }
            }
            return s;
        });
    }

    onSubmit(): { [key: string]: any } {
        console.log(this.schemaList)
        let maps: { [key: string]: any } = {};
        this.schemaList.filter(s => !s.readonly && s.widget !== Widget.tomanyTable).forEach((s) => maps[s.name] = s.value);
        console.log(maps)
        return maps;

    }

}
