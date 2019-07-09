import { CreateAndupdater } from "../components/settings/UpdateAndCreate";
import { Category } from "../components/home/storageItem";
import axios, { AxiosStatic } from 'axios';
import { mock, when, instance } from "ts-mockito"
import { getURL } from "../components/settings/settings";
import MockAdapter from "axios-mock-adapter"

describe("Parsing test", () => {
    let category: Category = { name: "category", id: 0 }
    const mockClient = new MockAdapter(axios)
    mockClient.onPost(getURL("/category/")).reply(
        201, category
    )
    mockClient.onPatch(getURL("/category/")).reply(200, category)


    test("get url test", async () => {
        let uploader = new CreateAndupdater<Category>("category", axios)
        expect(uploader._getPath()).toBe(getURL("/category/"))
    })

    test("get url test 2", async () => {
        let client: AxiosStatic = mock(axios)
        let clientInstance = instance(client)
        let uploader = new CreateAndupdater<Category>("author", clientInstance)
        expect(uploader._getPath()).toBe(getURL("/author/"))
    })


    test("create object", async () => {
        let uploader = new CreateAndupdater<Category>("category", axios)
        let result = await uploader.create(category)
        expect(result.name).toBe(category.name)
    })

    test("update object", async () => {
        // let uploader = new CreateAndupdater<Category>("category", axios)
        // let result = await uploader.update(category, category.id)
        // expect(result.name).toBe(category.name)
    })


})
