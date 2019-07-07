import React from "react";
import QRCode from "qrcode.react";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button
} from "@material-ui/core";

interface Props {
  value: string;
}

export default function QRDownload(props: Props) {
  return (
    <Dialog open={true} fullWidth>
      <DialogTitle>Print QR Code</DialogTitle>
      <DialogContent>
        <div className="row ml-2">
          <QRCode value={props.value} />
          <div className="ml-3">
            <div>Item:Harry potter</div>
            <div>Description: a magic book</div>
            <div>UUID:020919921</div>
          </div>
        </div>
      </DialogContent>
      <DialogActions>
        <Button>Cancel</Button>
        <Button>Print</Button>
      </DialogActions>
    </Dialog>
  );
}
