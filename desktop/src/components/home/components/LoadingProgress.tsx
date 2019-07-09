import React from "react";
import { Dialog, DialogContent, CircularProgress } from "@material-ui/core";

interface Props {
  open: boolean;
  progress?: number;
}

export default function LoadingProgress(props: Props) {
  return (
    <Dialog open={props.open}>
      <DialogContent className="d-flex" style={{ width: "150px" }}>
        <CircularProgress
          className="mx-auto"
          variant="determinate"
          value={props.progress}
        />
      </DialogContent>
      <div className="mx-auto"> Loading</div>
    </Dialog>
  );
}
