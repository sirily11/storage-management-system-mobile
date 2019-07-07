import React, { Component } from "react";
import { Dialog, Fab, DialogTitle, CircularProgress } from "@material-ui/core";

import SmartphoneIcon from "@material-ui/icons/Smartphone";
import { ReactComponent as QRBackground } from "./qr-code.svg";

const waitingColor = "#e65100";
const connectColor = "#039be5"
const successColor = "#00c853";

export default class RemoteScannerPage extends Component {
  render() {
    return (
      <Dialog open={true} className="h-100 w-100" style={{ height: "300px" }}>
        <DialogTitle>Waiting for mobile's response</DialogTitle>
        <div className="d-flex pb-5 pt-4">
          <div className="row h-100 mx-auto my-auto">
            <QRBackground style={{ opacity: 0.3, width: 200, height: 150}} />
            <Fab
              className="mx-auto my-auto"
              style={{
                backgroundColor: connectColor,
                position: "absolute",
                left: "0",
                right: "0",
                top: 0,
                bottom: 0
              }}
            >
              <CircularProgress
                size={64}
                style={{ position: "absolute", color: "#e91e63" }}
              />
              <SmartphoneIcon style={{ color: "white" }} />
            </Fab>
          </div>
        </div>
      </Dialog>
    );
  }
}
