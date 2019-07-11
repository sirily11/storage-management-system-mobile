import React, { Component } from "react";
import { IpcRenderer } from "electron";
import QRCode from "qrcode.react";
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
    ipcRenderer.on("qrCode", (qr: any) => {
      this.setState({ qrCode: qr.code });
    });
  }

  render() {
    if (this.state.qrCode) {
      return <div>No content</div>;
    } else {
      return (
        <div className="d-flex h-100">
          <h4>{this.state.qrCode}</h4>
          <div className="m-auto">
            <QRCode
              size={100}
              value={this.state.qrCode ? this.state.qrCode : ""}
            />
          </div>
        </div>
      );
    }
  }
}
