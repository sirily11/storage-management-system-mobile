import React from "react";
import { Dialog, DialogContent, CircularProgress } from "@material-ui/core";
import { Progress } from "semantic-ui-react";

interface Props {
  open: boolean;
  progress?: number;
}

export default function LoadingProgress(props: Props) {
  return (
    <Dialog open={props.open}>
      <DialogContent className="d-flex" style={{ width: "250px" }}>
        <Progress
          percent={props.progress}
          indicating
          size="medium"
          className="w-100 mx-auto"
        />
      </DialogContent>
      <div className="mx-auto"> Loading: {props.progress}%</div>
    </Dialog>
  );
}
