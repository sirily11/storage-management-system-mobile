import React, { Component } from "react";
import { IpcRenderer } from "electron";
import { DetailStorageItem, Settings } from "../home/storageItem";
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

export function computeDownloadProgress(progressEvent: any, callback?: any) {
  const totalLength = progressEvent.lengthComputable
    ? progressEvent.total
    : progressEvent.target.getResponseHeader("content-length") ||
      progressEvent.target.getResponseHeader("x-decompressed-content-length");
  if (totalLength !== null) {
    let progress = Math.round((progressEvent.loaded * 100) / totalLength);
    if(callback){
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
