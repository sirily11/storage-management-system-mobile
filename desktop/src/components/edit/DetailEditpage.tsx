import React, { Component } from "react";
import { fetchDetailItem, EditMessage } from "../settings/utils";
import { IpcRenderer } from "electron";
import { DetailStorageItem } from "../home/storageItem";
import { schema } from "./uiSchema";
import Form from "react-jsonschema-form";
const ipcRenderer: IpcRenderer = (window as any).require("electron")
  .ipcRenderer;

interface Props {}

interface State {
  item?: DetailStorageItem;
  progress?: number;
  schema?: any;
}

export default class DetailEditpage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      schema: schema
    };
  }

  componentDidMount() {
    ipcRenderer.on("show-edit", async (message: EditMessage) => {
      if (message.isEdit && message.id) {
      } else if (!message.isEdit) {
      }
    });
  }

  render() {
    return <Form schema={this.state.schema} />;
  }
}
