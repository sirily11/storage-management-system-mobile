import React, { Component } from "react";
import {
  DetailStorageItem,
  Settings,
  PublishStorageItem
} from "../home/storageItem";
import { IpcRenderer } from "electron";
import {
  EditMessage,
  fetchDetailSettings,
  showNotification,
  fetchDetailItem
} from "../settings/utils";
import TextInputField from "./components/TextInputField";
import FormProvider, { FormContext, FormValue } from "../Datamodel/FormContext";
import LoadingProgress from "../home/components/LoadingProgress";
import SelectInputField from "./components/SelectInputField";
import UploadButton from "@material-ui/icons/CloudUpload";
import RefreshIcon from "@material-ui/icons/Refresh";
import ArrowBackIcon from "@material-ui/icons/ArrowBack";
import {
  Button,
  AppBar,
  Toolbar,
  Typography,
  IconButton,
  createMuiTheme
} from "@material-ui/core";
import { blueGrey } from "@material-ui/core/colors";
import { MuiThemeProvider } from "@material-ui/core/styles";
import { CategoryDetail } from "./components/details/CategoryDetail";
import AuthorDetail from "./components/details/AuthorDetail";
import SeriesDetail from "./components/details/SeriesDetail";
import { PositionDetail } from "./components/details/PositionDetail";
import { LocationDetail } from "./components/details/LocationDetail";
import {
  Base,
  Author,
  Series,
  Category,
  Location,
  Position
} from "../home/storageItem";
import { object } from "prop-types";
import { CreateAndupdater } from "../settings/UpdateAndCreate";
import { Link, Redirect, RouteComponentProps } from "react-router-dom";
import MainEditor from "./MainEditor";

const ipcRenderer: IpcRenderer = (window as any).require("electron")
  .ipcRenderer;

const theme = createMuiTheme({
  palette: {
    primary: blueGrey
  }
});

interface RouterProps {
  id?: string;
}

interface Props extends RouteComponentProps<RouterProps> {}

interface State {
  isEdit: boolean;
  id?: number;
}

export default class Editpage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      isEdit: false
    };
  }

  render() {
    const id = this.props.match.params.id;
    return (
      <FormContext.Consumer>
        {({ init }) => (
          <MainEditor
            id={id ? parseInt(id) : undefined}
            initItem={id ? init : undefined}
          />
        )}
      </FormContext.Consumer>
    );
  }
}
