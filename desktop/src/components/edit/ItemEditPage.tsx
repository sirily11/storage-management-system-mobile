import React, { Component } from "react";
import { RouteComponentProps, Redirect } from "react-router";
import { Schema } from "./JSONSchema/model/Schema";
import axios from "axios";
import { getURL } from "../settings/settings";
import { JSONSchema } from "./JSONSchema";
import {
  AppBar,
  Toolbar,
  Typography,
  createMuiTheme,
  Paper,
  IconButton
} from "@material-ui/core";
import { blueGrey } from "@material-ui/core/colors";
import { MuiThemeProvider } from "@material-ui/core/styles";
import { Link } from "react-router-dom";
import ArrowBackIcon from "@material-ui/icons/ArrowBack";
import { DetailStorageItem } from "../home/storageItem";

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
  isLoading: boolean;
  isEdit: boolean;
  schema?: Schema[];
  redirect: boolean;
  values?: { [key: string]: any };
}

export default class ItemEditPage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      isEdit: false,
      isLoading: true,
      redirect: false
    };
  }

  async componentDidMount() {
    const id = this.props.match.params.id;
    const isEdit = id !== undefined;
    // fetch schema
    let url = getURL("item/");
    let response = await axios.request({ method: "OPTIONS", url: url });
    this.setState({ schema: response.data.fields, isEdit: isEdit });
    // fetch data if edit is true
    if (isEdit) {
      await this.getValue();
    }
    this.setState({ isLoading: false });
  }

  async getValue() {
    const id = this.props.match.params.id;
    let url = getURL(`item/${id}/`);
    let data = await axios.get<DetailStorageItem>(url);
    let detailItem = data.data;
    const values = {
      ...detailItem,
      author_id: {
        label: detailItem.author_name.name,
        value: detailItem.author_name.id
      },
      category_id: {
        label: detailItem.category_name.name,
        value: detailItem.category_name.id
      },
      location_id: {
        label: detailItem.location_name.name,
        value: detailItem.location_name.id
      },
      position_id: {
        label: detailItem.position_name.name,
        value: detailItem.position_name.id
      },
      series_id: {
        label: detailItem.series_name.name,
        value: detailItem.series_name.id
      }
    };

    this.setState({
      values: values
    });
  }

  create = async (data: { [key: string]: any }) => {
    let url = getURL("item/");
    let response = await axios.post(url, data);
  };

  update = async (data: { [key: string]: any }) => {
    let url = getURL(`item/${this.props.match.params.id}/`);
    let response = await axios.patch(url, data);
  };

  render() {
    const { values, schema, isEdit, isLoading, redirect } = this.state;
    if (redirect) {
      return <Redirect to="/"> </Redirect>;
    }

    return (
      <MuiThemeProvider theme={theme}>
        <AppBar elevation={0} style={{ height: "200px", zIndex: 3 }}>
          <Toolbar>
            <Link to="/">
              <IconButton style={{ color: "white" }}>
                <ArrowBackIcon />
              </IconButton>
            </Link>
            <Typography variant="h6" color="inherit">
              {isEdit ? "编辑" : "添加"}物品
            </Typography>
          </Toolbar>
        </AppBar>
        <Paper
          className="container-fluid py-4 w-75 mb-3"
          style={{
            overflowX: "hidden",
            overflowY: "hidden",
            position: "absolute",
            top: "130px",
            left: 0,
            right: 0,
            zIndex: 30
          }}
        >
          {!isLoading && (
            <JSONSchema
              schemas={schema}
              url={"http://0.0.0.0/"}
              values={values}
              onSubmit={async data => {
                if (isEdit) {
                  await this.update(data);
                } else {
                  await this.create(data);
                }
                this.setState({ redirect: true });
              }}
            ></JSONSchema>
          )}{" "}
        </Paper>
      </MuiThemeProvider>
    );
  }
}
