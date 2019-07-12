import React from "react";
import QRCode from "qrcode.react";
import { AbstractStorageItem } from "../home/storageItem";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button
} from "@material-ui/core";
import { IpcRenderer } from "electron";
// import printer from 'print-js'
const electron = (window as any).require("electron");
const ipc: IpcRenderer = electron.ipcRenderer;
const printer = require("print-js")

interface Props {
  item?: AbstractStorageItem;
  open: boolean;
  onClose(): void;
}

export default function QRDownload(props: Props) {
  return (
    <Dialog open={props.open} fullWidth>
      <DialogTitle>Print QR Code</DialogTitle>
      <DialogContent>
        <div className="row ml-2">
          <div id="qrCode" className="pr-2 mb-2 p-3">
            <QRCode size={57} value={props.item ? props.item.uuid : ""} />
          </div>
          <div className="ml-3">
            <div>{props.item ? props.item.name : ""}</div>
            <div>{props.item ? props.item.description : ""}</div>
            <div>{props.item ? props.item.uuid : ""}</div>
          </div>
        </div>
      </DialogContent>
      <DialogActions>
        <Button onClick={props.onClose}>Cancel</Button>
        <Button
          onClick={() => {
            if (props.item) {
              // ipc.send("print", props.item.uuid);
              // printer("qrCode", "html")
              printer({
                printable: "qrCode",
                type: "html",
              });
            }
          }}
        >
          Print
        </Button>
      </DialogActions>
    </Dialog>
  );
}
