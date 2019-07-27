import React, { Component } from "react";
import {
  AbstractStorageItem,
  DetailStorageItem,
  unitOptions
} from "../home/storageItem";
import { IpcRenderer } from "electron";
const ipcRenderer: IpcRenderer = (window as any).require("electron")
  .ipcRenderer;

export interface FormValue {
  name?: string;
  description?: string;
  unit: string;
  qrCode?: string;
  price?: number;
  col?: number;
  row?: number;
  author?: number;
  category?: number;
  series?: number;
  position?: number;
  location?: number;
}

const initForm: FormValue = {
  name: "",
  description: "",
  qrCode: "",
  price: 0,
  col: 0,
  row: 0,
  author: -1,
  category: -1,
  series: -1,
  position: -1,
  location: -1,
  unit: unitOptions[0].value
};

interface State {
  formValue: FormValue;
  setForm(name: string, value: any): void;
  getForm(name: string): any;
  clear(): void;
  init(item: DetailStorageItem): void;
}

interface Props {}

export default class FormProvider extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      formValue: initForm,
      setForm: this.setForm,
      getForm: this.getValue,
      clear: this.clear,
      init: this.init
    };
    ipcRenderer.on("close", () => {
      console.log("closed");
      this.setState({ formValue: initForm });
    });
  }

  init = (item: DetailStorageItem) => {
    this.setState({
      formValue: {
        qrCode: item.qr_code,
        name: item.name,
        description: item.description,
        price: item.price,
        col: item.column,
        row: item.row,
        author: item.author_name ? item.author_name.id : undefined,
        category: item.category_name ? item.category_name.id : undefined,
        series: item.series_name ? item.series_name.id : undefined,
        position: item.position_name ? item.position_name.id : undefined,
        location: item.location_name ? item.location_name.id : undefined,
        unit: item.unit
      }
    });
  };

  clear = () => {
    console.log("clear");

    this.setState({ formValue: initForm });
  };

  setForm = (name: string, value: any) => {
    let f = this.state.formValue;
    switch (name.toLowerCase()) {
      case "name":
        f.name = value;
        break;
      case "description":
        f.description = value;
        break;
      case "qrcode":
        f.qrCode = value;
        break;
      case "price":
        f.price = value;
        break;
      case "col":
        f.col = value;
        break;
      case "row":
        f.row = value;
        break;
      case "author":
        f.author = value;
        break;
      case "series":
        f.series = value;
        break;
      case "category":
        f.category = value;
        break;
      case "position":
        f.position = value;
        break;
      case "location":
        f.location = value;
        break;
      case "unit":
        f.unit = value;
        break;
      default:
        console.error("Error happened on set value");
        return;
    }
    this.setState({ formValue: f });
  };

  getValue = (name: string): any => {
    let f = this.state.formValue;
    switch (name.toLowerCase()) {
      case "name":
        return f.name;

      case "description":
        return f.description;

      case "price":
        return f.price;

      case "qrcode":
        return f.qrCode;

      case "col":
        return f.col;

      case "row":
        return f.row;

      case "author":
        return f.author;

      case "series":
        return f.series;

      case "category":
        return f.category;

      case "position":
        return f.position;

      case "location":
        return f.location;

      case "unit":
        return f.unit;
      default:
        console.error("Error happened on get value");
        return;
    }
  };

  render() {
    return (
      <FormContext.Provider value={this.state}>
        {this.props.children}
      </FormContext.Provider>
    );
  }
}

const context: State = {
  formValue: initForm,
  setForm: (name: string, value: any) => {},
  getForm: (name: string) => {},
  clear: () => {},
  init: (item: DetailStorageItem) => {}
};

export const FormContext = React.createContext(context);
