import { Schema } from "./Schema";

export abstract class BaseExtra<T> {

    schemaName: string

    constructor(name: string) {
        this.schemaName = name;
    }

    /**
     * Merge with schemas
     * @param schemas shemas
     * @param values values you want to merge
     * @returns new schemas
     */
    merge(schemas: [], values: T[]): Schema[] {
        return []
    }
}