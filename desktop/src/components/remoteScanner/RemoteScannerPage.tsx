import React, { Component } from "react";
import {
  Dialog,
  Fab,
  DialogTitle,
  CircularProgress,
  IconButton,
  Collapse,
  DialogActions,
  Button
} from "@material-ui/core";
import SmartphoneIcon from "@material-ui/icons/Smartphone";
import { ReactComponent as QRBackground } from "./qr-code.svg";
import { getWebSocket } from "../settings/settings";
import { Message } from "./message";
import RefreshIcon from "@material-ui/icons/Refresh";

const waitingColor = "#e65100";
const connectColor = "#039be5";
const successColor = "#00c853";

interface Props {
  onDone(qrCode?: string): void;
  open: boolean;
  close(): void;
}

interface State {
  // 0 - not connect to ws, 1 connect, but scanner not connect,
  // 2 connect and scanner is online
  status: number;
  qrCode?: string;
  ws?: WebSocket;
}

const initState: State = {
  status: 0,
  qrCode: undefined
};

export default class RemoteScannerPage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = initState;
  }

  componentDidMount() {
    this.init();
  }

  componentWillUnmount() {
    if (this.state.ws) {
      this.state.ws.close();
    }
  }

  init = () => {
    this.setState(initState);
    let url = getWebSocket("");
    let ws = new WebSocket(url);
    this.setState({ ws });

    ws.onerror = evt => {
      this.setState({ status: -1 });
    };

    ws.onclose = evt => {
      this.setState({ status: 0 });
    };

    ws.onopen = evt => {
      this.setState({ status: 1 });
    };

    ws.onmessage = evt => {
      let message: Message = JSON.parse(evt.data);

      switch (message.type) {
        case "connect":
          this.setState({
            status: 2
          });
          var response: Message = { type: "connect", from: "receiver" };
          ws.send(JSON.stringify(response));
          break;
        case "disconnect":
          this.setState({ status: 1 });
          break;
        case "message":
          console.log(message);
          if (message.body) {
            this.setState({ qrCode: message.body });
            setTimeout(() => this.props.onDone(message.body), 1000);
          }
      }
    };
  };

  renderTitle() {
    switch (this.state.status) {
      case 0:
        return "Waiting for server's response";
      case 1:
        return "Waiting for scanner's response";
      case 2:
        return "Scanner is connected";
      default:
        return "Connection error";
    }
  }

  renderColor() {
    switch (this.state.status) {
      case 0:
        return waitingColor;
      case 1:
        return connectColor;
      case 2:
        return successColor;
      default:
        return waitingColor;
    }
  }

  render() {
    return (
      <Dialog
        open={this.props.open}
        className="h-100 w-100"
        style={{ height: "300px" }}
        fullWidth
      >
        <DialogTitle>
          {this.renderTitle()}
          <IconButton onClick={this.init}>
            <RefreshIcon />
          </IconButton>
        </DialogTitle>
        <div className="d-flex pb-5 pt-4">
          <div className="row h-100 mx-auto my-auto">
            <QRBackground style={{ opacity: 0.3, width: 200, height: 150 }} />
            <Fab
              className="mx-auto my-auto"
              style={{
                backgroundColor: this.renderColor(),
                position: "absolute",
                left: "0",
                right: "0",
                top: 0,
                bottom: 0
              }}
            >
              {this.state.status >= 0 && this.state.status !== 2 && (
                <CircularProgress
                  size={64}
                  style={{ position: "absolute", color: "#e91e63" }}
                />
              )}
              <SmartphoneIcon style={{ color: "white" }} />
            </Fab>
          </div>
        </div>
        <Collapse in={this.state.qrCode !== undefined} mountOnEnter>
          <div className="row w-100 mx-auto p-4">Code Has Been Scanned</div>
        </Collapse>
        <DialogActions>
          <Button
            onClick={() => {
              this.props.close();
            }}
          >
            Close
          </Button>
        </DialogActions>
      </Dialog>
    );
  }
}
