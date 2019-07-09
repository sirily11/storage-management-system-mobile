import { CreateAndupdater } from "../../../settings/UpdateAndCreate";

export abstract class CreateAndUpdaterPage<T>{
    abstract async create(object: T): Promise<void>
    abstract async update(object: T, id: number): Promise<void>
}