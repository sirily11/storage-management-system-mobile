import React, { Component } from "react";
import axios from "axios";
import { DetailStorageItem } from "../storageItem";
import { getURL } from "../../settings/settings";
import FolderIcon from "@material-ui/icons/Folder";
import {
  CircularProgress,
  Divider,
  List,
  Avatar,
  ListItem,
  TextField,
  GridList,
  GridListTile,
  CardContent,
  Icon,
  Card,
  ListSubheader
} from "@material-ui/core";
import { fetchDetailItem } from "../../settings/utils";

interface State {
  item?: DetailStorageItem;
}

interface Props {
  itemID: number;
}

export default class ItemDetailPage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      item: undefined
    };
  }

  async componentWillMount() {
    if (this.props.itemID !== -1) {
      let item = await fetchDetailItem(this.props.itemID);
      this.setState({
        item
      });
    }
  }

  async componentDidUpdate(oldProps: Props) {
    if (oldProps.itemID !== this.props.itemID && this.props.itemID !== -1) {
      let item = await fetchDetailItem(this.props.itemID);
      this.setState({
        item
      });
    }
  }

  renderImages() {
    if (this.state.item !== undefined && this.state.item.images.length > 0) {
      return (
        <List
          style={{
            display: "flex",
            flexDirection: "row",
            overflowY: "scroll",
            width: "100%"
          }}
        >
          {this.state.item.images.map((images, index) => {
            return (
              <Avatar
                className="m-3"
                style={{ width: "150px", height: "150px" }}
                src={images}
                key={`avatar-${index}`}
              />
            );
          })}
        </List>
      );
    } else {
      return <div>No image</div>;
    }
  }

  renderTextField(title: string, label?: string, value?: string, numLine = 5) {
    return (
      <div>
        <h5>{title}</h5>
        <TextField
          className="mt-2 mb-2"
          value={value}
          label={label}
          InputLabelProps={{ shrink: true }}
          fullWidth
          variant="outlined"
          rowsMax={numLine}
          rows={numLine}
          multiline={true}
        />
      </div>
    );
  }

  renderFiles(files: string[]) {
    return (
      <GridList cellHeight={80} cols={3} spacing={20} className="pt-2">
        <GridListTile key="Subheader" cols={3} style={{ height: "auto" }}>
          <h5>Files</h5>
        </GridListTile>
        {files.map((file, index) => {
          return (
            <GridListTile key={`file-${index}`}>
              <Card>
                <CardContent className="row mx-2">
                  <FolderIcon />
                  <div>{file}</div>
                </CardContent>
              </Card>
            </GridListTile>
          );
        })}
      </GridList>
    );
  }

  render() {
    const { item } = this.state;
    if (item === undefined && this.props.itemID !== -1) {
      return (
        <div className="h-100 w-100 row">
          <div className="mx-auto my-auto">
            <CircularProgress />
          </div>
        </div>
      );
    } else if (item === undefined) {
      return <div />;
    } else if (item !== undefined) {
      return (
        <div className="container pt-4">
          <h3>{item.name}</h3>
          <span>{item.category_name.name}</span>
          <Divider />
          <div className="pt-3">
            <h5>Images</h5>
            {this.renderImages()}

            <TextField
              className="mt-2 mb-2"
              value={item.description}
              label="Description"
              fullWidth
              variant="outlined"
              rowsMax={5}
              rows={5}
              multiline={true}
            />
            <div className="row mt-3 mb-3 px-3">
              <TextField
                className="col-4 pr-1"
                value={item.price}
                variant="outlined"
                label="Price"
              />
              <TextField
                className="col-4 px-1"
                value={item.column}
                variant="outlined"
                label="Column"
              />
              <TextField
                className="col-4 pl-1"
                value={item.row}
                variant="outlined"
                label="Row"
              />
            </div>
            <TextField
              fullWidth
              className="pb-3"
              value={item.qr_code}
              variant="outlined"
              label="QR Code"
            />
            {this.renderTextField(
              "Author",
              item.author_name.name,
              item.author_name.description
            )}
            {this.renderTextField(
              "Series",
              item.series_name.name,
              item.series_name.description
            )}
            {this.renderTextField(
              "Position",
              item.position_name.position,
              item.position_name.description,
              2
            )}
            {this.renderFiles(item.files)}
          </div>
        </div>
      );
    }
  }
}
