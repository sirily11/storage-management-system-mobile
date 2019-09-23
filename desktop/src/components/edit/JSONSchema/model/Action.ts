import { BaseExtra } from "./base";
import { Schema } from './Schema';

export enum ActionTypes {
    image,
    qrScan
}

export enum ActionDone {
    getInput,
    getImage
}

export class FieldAction extends BaseExtra<FieldAction>{

    actionTypes: ActionTypes;
    actionDone: ActionDone;
    schemaName: string;

    constructor(t: ActionTypes, d: ActionDone, n: string) {
        super(n);
        this.schemaName = n;
        this.actionTypes = t;
        this.actionDone = d;
    }

    static merge(schemas: Schema[], values: FieldAction[]): Schema[] {
        return schemas.map((s) => {
            values.forEach((f) => {
                if (f.schemaName == s.name) {
                    s.action = f;
                }
            })

            return s;
        })
    }


}