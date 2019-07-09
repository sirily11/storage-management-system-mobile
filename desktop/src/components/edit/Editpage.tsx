import React, { Component } from "react";
import { DetailStorageItem, Settings } from "../home/storageItem";
import { IpcRenderer } from "electron";
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
import RefreshIcon from "@material-ui/icons/Refresh";
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
  settings?: Settings;
  openAuthor: boolean;
  isEditAuthor: boolean;
  openSeries: boolean;
  isEditSeries: boolean;
  openCategory: boolean;
  isEditCategory: boolean;
  openPosition: boolean;
  isEditPosition: boolean;
  openLocation: boolean;
  isEditLocation: boolean;
}

export default class Editpage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      isEditAuthor: false,
      isEditCategory: false,
      isEditLocation: false,
      isEditPosition: false,
      isEditSeries: false,
      openAuthor: false,
      openCategory: false,
      openSeries: false,
      openLocation: false,
      openPosition: false
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
      if (v === "" || v === undefined || v === -1) {
        showNotification(`${k} should not be empty`);
        return;
      }
    }
    console.log(value);
  };

  add = (from: "category" | "series" | "author" | "location" | "position") => {
    switch (from) {
      case "author":
        this.setState({ openAuthor: true, isEditAuthor: false });
        break;
      case "series":
        this.setState({ openSeries: true, isEditSeries: false });
        break;
      case "category":
        this.setState({ openCategory: true, isEditCategory: false });
        break;
      case "location":
        this.setState({ openLocation: true, isEditLocation: false });
        break;
      case "position":
        this.setState({ openPosition: true, isEditPosition: false });
        break;
    }
  };

  update = (
    from: "category" | "series" | "author" | "location" | "position"
  ) => {
    console.log(from);
    switch (from) {
      case "author":
        this.setState({ openAuthor: true, isEditAuthor: true });
        break;
      case "series":
        this.setState({ openSeries: true, isEditSeries: true });
        break;
      case "category":
        this.setState({ openCategory: true, isEditCategory: true });
        break;
      case "location":
        this.setState({ openLocation: true, isEditLocation: true });
        break;
      case "position":
        this.setState({ openPosition: true, isEditPosition: true });
        break;
    }
  };

  _onDelete = (
    id: number,
    path: "category" | "series" | "author" | "location" | "position"
  ) => {
    let settings = this.state.settings;
    let index: number | undefined;
    if (settings) {
      switch (path) {
        case "author":
          index = settings.authors.findIndex(v => v.id === id);
          settings.authors.splice(index, 1);
          break;
        case "series":
          index = settings.series.findIndex(v => v.id === id);
          settings.series.splice(index, 1);
          break;
        case "category":
          index = settings.categories.findIndex(v => v.id === id);
          settings.categories.splice(index, 1);
          break;
        case "location":
          index = settings.locations.findIndex(v => v.id === id);
          settings.locations.splice(index, 1);
          break;
        case "position":
          index = settings.positions.findIndex(v => v.id === id);
          settings.positions.splice(index, 1);
          break;
      }
      this.setState({ settings: settings });
    }
  };

  _onCreate = (
    object: Base,
    path: "category" | "series" | "author" | "location" | "position"
  ) => {
    let settings = this.state.settings;
    let index: number | undefined;
    if (settings) {
      switch (path) {
        case "author":
          settings.authors.push(object);
          break;
        case "series":
          settings.series.push(object);
          break;
        case "category":
          settings.categories.push(object);
          break;
        case "location":
          settings.locations.push(object);
          break;
        case "position":
          settings.positions.push((object as unknown) as Position);
          break;
      }
      this.setState({ settings: settings });
    }
  };

  _onUpdate = (
    object: Base,
    path: "category" | "series" | "author" | "location" | "position"
  ) => {
    let settings = this.state.settings;
    let index: number | undefined;
    if (settings) {
      switch (path) {
        case "author":
          index = settings.authors.findIndex(v => v.id === object.id);
          settings.authors[index] = object;
          break;
        case "series":
          index = settings.series.findIndex(v => v.id === object.id);
          settings.series[index] = object;
          break;
        case "category":
          index = settings.categories.findIndex(v => v.id === object.id);
          settings.categories[index] = object;
          break;
        case "location":
          index = settings.locations.findIndex(v => v.id === object.id);
          settings.locations[index] = object;
          break;
        case "position":
          index = settings.positions.findIndex(v => v.id === object.id);
          settings.positions[index] = (object as unknown) as Position;
          break;
      }
      this.setState({ settings: settings });
    }
  };

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
                <div className="mr-1 ml-auto">
                  <IconButton
                    color="inherit"
                    onClick={() => {
                      this.handleSubmit(formValue);
                    }}
                  >
                    <UploadButton />
                  </IconButton>
                  <IconButton
                    color="inherit"
                    onClick={() => {
                      this._init();
                    }}
                  >
                    <RefreshIcon />
                  </IconButton>
                </div>
              )}
            </FormContext.Consumer>
          </Toolbar>
        </AppBar>
        <div className="container py-4" style={{ overflowX: "hidden" }}>
          <div>
            <TextInputField labels={["Name"]} multiline={false} type="name" />
            <TextInputField
              labels={["Description"]}
              type="description"
              multiline={true}
              varient="outlined"
            />
            <TextInputField
              labels={["Price", "Col", "Row"]}
              type="price"
              multiline={false}
              varient="outlined"
            />
            <TextInputField
              type="qrCode"
              labels={["QRCode"]}
              multiline={false}
              varient="outlined"
            />
          </div>
          {settings !== undefined && (
            <div>
              <SelectInputField
                label="Author"
                type="author"
                labels={settings.authors.map(author => author.name)}
                values={settings.authors.map(author => author.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
              <SelectInputField
                label="Series"
                type="series"
                labels={settings.series.map(s => s.name)}
                values={settings.series.map(s => s.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
              <SelectInputField
                label="Category"
                type="category"
                labels={settings.categories.map(c => c.name)}
                values={settings.categories.map(c => c.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
              <SelectInputField
                label="Position"
                type="position"
                labels={settings.positions.map(p => p.position)}
                values={settings.positions.map(p => p.id)}
                onAdd={this.add}
                onUpdate={this.update}
              />
              <SelectInputField
                label="Location"
                type="location"
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
          <FormContext.Consumer>
            {({ formValue }) => {
              if (settings) {
                const {
                  authors,
                  series,
                  categories,
                  locations,
                  positions
                } = settings;
                return (
                  <div>
                    <AuthorDetail
                      open={this.state.openAuthor}
                      isEdit={this.state.isEditAuthor}
                      onCreate={this._onCreate}
                      onUpdate={this._onUpdate}
                      onDelete={this._onDelete}
                      data={
                        formValue.author &&
                        authors.find(a => a.id === formValue.author)
                      }
                      close={() => {
                        this.setState({
                          openAuthor: false,
                          isEditAuthor: false
                        });
                      }}
                    />

                    <CategoryDetail
                      open={this.state.openCategory}
                      isEdit={this.state.isEditCategory}
                      onCreate={this._onCreate}
                      onUpdate={this._onUpdate}
                      onDelete={this._onDelete}
                      data={
                        formValue.category &&
                        categories.find(c => c.id === formValue.category)
                      }
                      close={() => {
                        this.setState({
                          openCategory: false,
                          isEditCategory: false
                        });
                      }}
                    />

                    <SeriesDetail
                      open={this.state.openSeries}
                      isEdit={this.state.isEditSeries}
                      onCreate={this._onCreate}
                      onUpdate={this._onUpdate}
                      onDelete={this._onDelete}
                      data={
                        formValue.series &&
                        series.find(s => s.id === formValue.series)
                      }
                      close={() => {
                        this.setState({
                          openSeries: false,
                          isEditSeries: false
                        });
                      }}
                    />

                    <PositionDetail
                      open={this.state.openPosition}
                      isEdit={this.state.isEditPosition}
                      onCreate={this._onCreate}
                      onUpdate={this._onUpdate}
                      onDelete={this._onDelete}
                      data={
                        formValue.position &&
                        positions.find(p => p.id === formValue.position)
                      }
                      close={() => {
                        this.setState({
                          openPosition: false,
                          isEditPosition: false
                        });
                      }}
                    />

                    <LocationDetail
                      open={this.state.openLocation}
                      isEdit={this.state.isEditLocation}
                      onCreate={this._onCreate}
                      onUpdate={this._onUpdate}
                      onDelete={this._onDelete}
                      data={
                        formValue.location &&
                        locations.find(l => l.id === formValue.location)
                      }
                      close={() => {
                        this.setState({
                          openLocation: false,
                          isEditLocation: false
                        });
                      }}
                    />
                  </div>
                );
              }
            }}
          </FormContext.Consumer>
        </div>
      </MuiThemeProvider>
    );
  }
}
