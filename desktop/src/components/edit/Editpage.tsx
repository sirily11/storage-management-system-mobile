import React, { Component } from "react";
import { DetailStorageItem, Settings } from "../home/storageItem";
import { schema } from "./uiSchema";
import { IpcRenderer } from "electron";
import Form from "react-jsonschema-form";
import {
  EditMessage,
  fetchDetailSettings,
  showNotification
} from "../settings/utils";
import TextInputField from "./components/TextInputField";
import FormProvider, { FormContext, FormValue } from "../Datamodel/FormContext";
import LoadingProgress from "../home/components/LoadingProgress";
import SelectInputField from "./components/SelectInputField";
import UploadButton from "@material-ui/icons/CloudUpload";
import {
  Button,
  AppBar,
  Toolbar,
  Typography,
  IconButton,
  createMuiTheme
} from "@material-ui/core";
import {
  purple,
  green,
  lightBlue,
  blue,
  blueGrey
} from "@material-ui/core/colors";
import { MuiThemeProvider } from "@material-ui/core/styles";
import AddAuthor from "./components/details/AddAuthor";

const ipcRenderer: IpcRenderer = (window as any).require("electron")
  .ipcRenderer;

const theme = createMuiTheme({
  palette: {
    primary: blueGrey
  }
});

interface Props {}

interface State {
  item?: DetailStorageItem;
  progress?: number;
  schema?: any;
  settings?: Settings;
}

export default class Editpage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      schema: schema
    };
  }

  async componentDidMount() {
    await this._init();
    ipcRenderer.on("edit", async (message: EditMessage) => {
      await this._init(message);
    });
  }

  async _init(message?: EditMessage) {
    this.setState({ progress: 0 });
    try {
      let settings: Settings = await fetchDetailSettings();
      this.setState({ settings: settings, progress: 100 });
      if (message && message.isEdit && message.id) {
      } else if (message && !message.isEdit) {
      }
    } catch (err) {
      showNotification(err);
    } finally {
      setInterval(() => {
        this.setState({ progress: undefined });
      }, 500);
    }
  }

  handleSubmit = (value: FormValue) => {
    for (let [k, v] of Object.entries(value)) {
      if (v === "" || v === undefined) {
        showNotification("Value should not be empty");
        return;
      }
    }
  };

  add = (from: string) => {};

  update = (from: string) => {};

  render() {
    const { settings } = this.state;
    return (
      <MuiThemeProvider theme={theme}>
        <AppBar position="sticky" elevation={0}>
          <Toolbar>
            <Typography variant="h6" color="inherit">
              添加物品
            </Typography>
            <FormContext.Consumer>
              {({ formValue }) => (
                <IconButton
                  className="mr-1 ml-auto"
                  color="inherit"
                  onClick={() => {
                    this.handleSubmit(formValue);
                  }}
                >
                  <UploadButton />
                </IconButton>
              )}
            </FormContext.Consumer>
          </Toolbar>
        </AppBar>
        <div className="container py-4" style={{ overflowX: "hidden" }}>
          <div>
            <TextInputField labels={["Name"]} multiline={false} />
            <TextInputField
              labels={["Description"]}
              multiline={true}
              varient="outlined"
            />
            <TextInputField
              labels={["Price", "Col", "Row"]}
              multiline={false}
              varient="outlined"
            />
          </div>
          {settings !== undefined && (
            <div>
              <SelectInputField
                label="Author"
                labels={settings.authors.map(author => author.name)}
                values={settings.authors.map(author => author.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
              <SelectInputField
                label="Series"
                labels={settings.series.map(s => s.name)}
                values={settings.series.map(s => s.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
              <SelectInputField
                label="Category"
                labels={settings.categories.map(c => c.name)}
                values={settings.categories.map(c => c.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
              <SelectInputField
                label="Position"
                labels={settings.positions.map(p => p.position)}
                values={settings.positions.map(p => p.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
              <SelectInputField
                label="Location"
                labels={settings.locations.map(
                  l =>
                    `${l.country}${l.city}${l.street}${l.building}${
                      l.room_number
                    }${l.unit}`
                )}
                values={settings.locations.map(l => l.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
            </div>
          )}
          <LoadingProgress
            progress={this.state.progress}
            open={this.state.progress !== undefined}
          />
          <AddAuthor open={true} />
        </div>
      </MuiThemeProvider>
    );
  }
}
