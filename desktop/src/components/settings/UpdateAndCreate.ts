import axios, { AxiosStatic } from "axios";
import { getURL } from "./settings";
import { showNotification, computeDownloadProgress } from "./utils";

export class CreateAndupdater<T>{
    client: AxiosStatic
    pathName: "category" | "series" | "author" | "location" | "position" | "item" | "files" | "image";

    constructor(pathName: "category" | "series" | "author" | "location" | "position" | "item" | "files" | "image",
        client?: AxiosStatic, ) {
        if (client) {
            this.client = client
        } else {
            this.client = axios
        }
        this.pathName = pathName
    }

    /**
     * Get url
     */
    _getPath(): string {
        switch (this.pathName) {
            case "author":
                return getURL("author/")
            case "category":
                return getURL("category/")
            case "series":
                return getURL("series/")
            case "location":
                return getURL("location/")
            case "position":
                return getURL("detail-position/")
            case "item":
                return getURL("item/")
            case "files":
                return getURL("files/")
            case "image":
                return getURL("item-image/")
            default:
                throw ("Path not found")
        }
    }


    async create(object: T, callback?: any): Promise<T> {
        return new Promise(async (resolve, reject) => {
            try {
                let url = this._getPath()
                let response = await this.client.post(url, object, { onUploadProgress: (evt: any) => computeDownloadProgress(evt, callback) })
                if (response.status === 201)
                    resolve(response.data)
            } catch (err) {
                reject(err)
            }
        })
    }

    async update(object: T, id: number): Promise<T> {
        return new Promise(async (resolve, reject) => {
            try {
                let url = `${this._getPath()}${id}/`
                let response = await this.client.patch(url, object)
                if (response.status === 200)
                    resolve(response.data)
            } catch (err) {
                reject(err)
            }
        })
    }

    async delete(id: number): Promise<T> {
        return new Promise(async (resolve, reject) => {
            try {
                let url = `${this._getPath()}${id}/`
                let response = await this.client.delete(url)
                if (response.status === 204)
                    resolve(response.data)
            } catch (err) {
                reject(err)
            }
        })
    }

}