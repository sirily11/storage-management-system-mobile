import React, { Component } from "react";
import axios from "axios";
import { DetailStorageItem, FileObject } from "../storageItem";
import { getURL } from "../../settings/settings";
import FolderIcon from "@material-ui/icons/Folder";
import DeleteIcon from "@material-ui/icons/Delete";
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
  ListSubheader,
  IconButton,
  CardActions,
  Collapse,
  Button
} from "@material-ui/core";
import {
  fetchDetailItem,
  showNotification,
  getIcon
} from "../../settings/utils";
import FileUploader from "../../uploadFile/FileUploader";
import AddIcon from "@material-ui/icons/Add";
import { async } from "q";
import { CreateAndupdater } from "../../settings/UpdateAndCreate";

interface State {
  item?: DetailStorageItem;
  openAddFile: boolean;
  showFile: boolean;
}

interface Props {
  itemID: number;
}

export default class ItemDetailPage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      item: undefined,
      openAddFile: false,
      showFile: false
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

  deleteFile = async (id: number, index: number) => {
    try {
      let client = new CreateAndupdater<FileObject>("files");
      await client.delete(id);
      let item = this.state.item;
      if (item) {
        item.files_objects.splice(index, 1);
        this.setState({ item });
      }
    } catch (err) {
      showNotification(err.toString());
    }
  };

  renderTextField(title: string, label?: string, value?: string, numLine = 5) {
    return (
      <div>
        <h5>{title}</h5>
        <TextField
          InputLabelProps={{ shrink: true }}
          className="mt-2 mb-2"
          value={value}
          label={label}
          fullWidth
          variant="outlined"
          rowsMax={numLine}
          rows={numLine}
          multiline={true}
        />
      </div>
    );
  }

  renderFiles(files: FileObject[]) {
    return (
      <Collapse
        in={this.state.showFile}
        mountOnEnter
        unmountOnExit
        className="pb-3"
      >
        <GridList cellHeight={"auto"} cols={2} spacing={20} className="pt-2">
          {files.map((file, index) => {
            return (
              <GridListTile key={`file-${index}`}>
                <Card>
                  <CardContent className="row mx-2">
                    {getIcon(file.file)}
                    <div>{file.file}</div>
                  </CardContent>
                  <CardActions>
                    <IconButton
                      onClick={() => {
                        let confirm = window.confirm("确定要删除吗？");
                        if (file.id && confirm) {
                          this.deleteFile(file.id, index);
                        }
                      }}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </CardActions>
                </Card>
              </GridListTile>
            );
          })}
        </GridList>
      </Collapse>
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
          <span>
            {item.category_name !== null ? item.category_name.name : ""}
          </span>
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
              item.author_name !== null ? item.author_name.name : "",
              item.author_name !== null ? item.author_name.description : ""
            )}
            {this.renderTextField(
              "Series",
              item.series_name !== null ? item.series_name.name : "",
              item.series_name !== null ? item.series_name.description : ""
            )}
            {this.renderTextField(
              "Position",
              item.position_name !== null ? item.position_name.position : "",
              item.position_name !== null ? item.position_name.description : "",
              2
            )}
            <h5>
              Files
              <IconButton
                onClick={() => {
                  this.setState({ openAddFile: true });
                }}
              >
                <AddIcon />
              </IconButton>
              <Button
                onClick={() => {
                  let showFile = !this.state.showFile;
                  this.setState({
                    showFile
                  });
                }}
              >
                {!this.state.showFile ? "显示更多" : "隐藏"}
              </Button>
            </h5>
            {this.renderFiles(item.files_objects)}
          </div>
          <FileUploader
            existingFiles={this.state.item ? this.state.item.files_objects : []}
            open={this.state.openAddFile}
            itemID={this.props.itemID}
            onClose={() => {
              this.setState({ openAddFile: false });
            }}
            onSave={(newFiles: FileObject[]) => {
              let item = this.state.item;
              if (item) {
                item.files_objects = [...item.files_objects, ...newFiles];
                this.setState({ item: item, openAddFile: false });
              }
            }}
          />
        </div>
      );
    }
  }
}
