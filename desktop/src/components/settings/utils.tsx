import React, { Component } from "react";
import { IpcRenderer } from "electron";
import { DetailStorageItem, Settings, Category } from "../home/storageItem";
import { getURL } from "./settings";
import axios, { AxiosStatic } from "axios";
import FolderIcon from "@material-ui/icons/Folder";
import PersonalVideoIcon from "@material-ui/icons/PersonalVideo";
import InsertDriveFileIcon from "@material-ui/icons/InsertDriveFile";
import CropOriginalIcon from "@material-ui/icons/CropOriginal";
import { SvgIconProps } from "@material-ui/core/SvgIcon/SvgIcon";

export interface EditMessage {
  isEdit: boolean;
  id?: number;
  item?: any;
}

enum Currency {
  "CNY",
  "HKD",
  "JPY",
  "USD",
  "AUD",
  "GBP",
  "RUB",
  "INR",
  "EUR"
}

export function computeDownloadProgress(progressEvent: any, callback?: any) {
  const totalLength = progressEvent.lengthComputable
    ? progressEvent.total
    : progressEvent.target.getResponseHeader("content-length") ||
      progressEvent.target.getResponseHeader("x-decompressed-content-length");
  if (totalLength !== null) {
    let progress = Math.round((progressEvent.loaded * 100) / totalLength);
    if (callback) {
      callback(progress);
    }
  }
}

export function showNotification(message: string) {
  const ipcRenderer: IpcRenderer = (window as any).require("electron")
    .ipcRenderer;
  ipcRenderer.send("notification", message);
}

export function openEditPage(message: EditMessage) {
  const ipcRenderer: IpcRenderer = (window as any).require("electron")
    .ipcRenderer;
  ipcRenderer.send("show-edit", message);
}

export function fetchDetailItem(itemID: number): Promise<DetailStorageItem> {
  return new Promise(async (resolve, reject) => {
    try {
      let url = getURL(`item/${itemID}/`);
      let response = await axios.get(url);
      let item: DetailStorageItem = response.data;
      resolve(item);
    } catch (err) {
      reject(err);
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
      reject(err);
    }
  });
}

export function fetchCategories(): Promise<Category[]> {
  return new Promise(async (resolve, reject) => {
    try {
      let url = getURL(`category`);
      let response = await axios.get(url);
      let item: Category[] = response.data;
      resolve(item);
    } catch (err) {
      reject(err);
    }
  });
}

export function getIcon(filename: string): any {
  if (
    filename.includes("pdf") ||
    filename.includes("txt") ||
    filename.includes("word") ||
    filename.includes("pages") ||
    filename.includes("md")
  ) {
    return <InsertDriveFileIcon />;
  } else if (
    filename.includes("png") ||
    filename.includes("jpg") ||
    filename.includes("bmp")
  ) {
    return <CropOriginalIcon />;
  } else if (
    filename.includes("mp4") ||
    filename.includes("mov") ||
    filename.includes("wmv")
  ) {
    return <PersonalVideoIcon />;
  }
  return <FolderIcon />;
}

export async function getCurrencyRate(
  base = "CNY"
): Promise<Map<string, number>> {
  let url = "https://api.exchangeratesapi.io/latest?base=" + base;
  let response = await axios.get(url);
  let currency: Map<string, number> = response.data.rates;
  return currency;
}

export function convertCurrency(
  amount: number,
  from: Currency | string,
  to: Currency | string,
  currency: any
): number {
  const originalRate = currency[from];
  const convertRate = currency[to];
  if (originalRate && convertRate) {
    return (amount / originalRate) * convertRate;
  }
  return 0;
}
