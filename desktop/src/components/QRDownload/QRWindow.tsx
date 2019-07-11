import React, { Component } from "react";
import { IpcRenderer } from "electron";
import QRCode from "qrcode.react";
import printer from 'print-js'
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
      // setTimeout(()=>{
      //   printer("qrCode", "html")
      // }, 100)
      // let w = window.open("", "", "width=300,height=300")
      // let element = document.getElementById("qrCode")
      // if(element && w){
      //   w.document.write(element.innerHTML)
      //   w.print()
      // }
      window.print()
      printer("qrCode", "html")
    });
  }

  render() {
    if (!this.state.qrCode) {
      return <div>No content</div>;
    } else {
      return (
          <div className="row pt-3 pb-3" id="qrCode" style={{height: "100px", width: "100px"}}>
            <QRCode
              size={160}
              value={this.state.qrCode ? this.state.qrCode : ""}
            />
          </div>
      );
    }
  }
}
