import React from "react";
import {
  Dialog,
  DialogTitle,
  TextField,
  DialogContent,
  DialogActions,
  Button
} from "@material-ui/core";

interface Props {
  onChange(
    evt: React.ChangeEvent<
      HTMLTextAreaElement | HTMLInputElement | HTMLSelectElement
    >
  ): void;
  onSearch(): void;
  open: boolean;
  onClose(): void;
}

export default function LocalScanner(props: Props) {
  
  return (
    <div>
      <Dialog open={props.open} fullWidth>
        <DialogTitle>Scanner</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            onChange={props.onChange}
            fullWidth
            label="QRCode"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={props.onClose}>Cancel</Button>
          <Button onClick={props.onSearch}>OK</Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
