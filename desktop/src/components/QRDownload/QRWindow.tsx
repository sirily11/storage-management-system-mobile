import React, { Component } from "react";
import { IpcRenderer } from "electron";
import QRCode from "qrcode.react";
import printer from "print-js";
const ipcRenderer: IpcRenderer = (window as any).require("electron")
  .ipcRenderer;

interface Props {}

interface State {
  qrCode?: string;
}

export default class QRWindow extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { qrCode: undefined };
  }

  componentDidMount() {
    console.log("Window mounted", this.state.qrCode);
    ipcRenderer.on("qrCode", (evnt: any, qr: any) => {
      let qrCode: string = qr.code;
      this.setState({ qrCode });
      setTimeout(() => {
        printer("qrCode", "html");
      }, 100);
    });
  }

  render() {
    if (!this.state.qrCode) {
      return <div>No content</div>;
    } else {
      return (
        <div className="d-flex h-100" id="qrCode">
          <div className="m-auto">
            <QRCode
              size={200}
              value={this.state.qrCode ? this.state.qrCode : ""}
            />
          </div>
        </div>
      );
    }
  }
}
