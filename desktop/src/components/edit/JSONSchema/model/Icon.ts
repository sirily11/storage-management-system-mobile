import { BaseExtra } from './base';
import { Schema } from './Schema';


export class FieldIcon extends BaseExtra<FieldIcon> {
    iconData: string;
    schemaName: string;

    constructor(i: string, n: string) {
        super(n);
        this.iconData = i;
        this.schemaName = n;
    }

    static merge(schemas: Schema[], values: FieldIcon[]): Schema[] {
        return schemas.map((s) => {
            values.forEach((f) => {
                if (f.schemaName == s.name) {
                    s.icon = f;
                }
            })
            return s;
        })
    }

}