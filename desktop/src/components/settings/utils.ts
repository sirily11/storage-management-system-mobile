import { IpcRenderer } from "electron"
import { DetailStorageItem, Settings } from "../home/storageItem";
import { getURL } from "./settings";
import axios, { AxiosStatic } from 'axios';


export interface EditMessage {
    isEdit: boolean;
    id?: number;
    item?: any
}

export function computeDownloadProgress(progressEvent: any, callback?: any) {
    const totalLength = progressEvent.lengthComputable ? progressEvent.total : progressEvent.target.getResponseHeader('content-length') || progressEvent.target.getResponseHeader('x-decompressed-content-length');
    if (totalLength !== null) {
        let progress = Math.round((progressEvent.loaded * 100) / totalLength);
        callback(progress)
    }
}

export function showNotification(message: string) {
    const ipcRenderer: IpcRenderer = (window as any).require("electron").ipcRenderer
    ipcRenderer.send("notification", message)
}

export function openEditPage(message: EditMessage) {
    const ipcRenderer: IpcRenderer = (window as any).require("electron").ipcRenderer
    ipcRenderer.send("show-edit", message)
}

export function fetchDetailItem(itemID: number): Promise<DetailStorageItem> {
    return new Promise(async (resolve, reject) => {
        try {
            let url = getURL(`item/${itemID}/`);
            let response = await axios.get(url);
            let item: DetailStorageItem = response.data;
            resolve(item);
        } catch (err) {
            reject(err)
        }
    });
}

export function fetchDetailSettings(): Promise<Settings> {
    return new Promise(async (resolve, reject) => {
        try {
            let url = getURL(`settings`);
            let response = await axios.get(url);
            let item: Settings = response.data;
            resolve(item);
        } catch (err) {
            reject(err)
        }
    });
}

