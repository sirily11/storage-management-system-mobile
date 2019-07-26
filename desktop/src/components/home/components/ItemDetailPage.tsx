import React, { Component } from "react";
import axios from "axios";
import { DetailStorageItem, FileObject, ImageObject } from "../storageItem";
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
  ListSubheader,
  IconButton,
  CardActions,
  Collapse,
  CardHeader,
  Chip,
  Fade
} from "@material-ui/core";
import {
  fetchDetailItem,
  showNotification,
  getIcon
} from "../../settings/utils";
import FileUploader from "../../uploadFile/FileUploader";
import AddIcon from "@material-ui/icons/Add";
import ClearIcon from "@material-ui/icons/Clear";
import { Card, Message, Label, Icon, Button } from "semantic-ui-react";
import { CreateAndupdater } from "../../settings/UpdateAndCreate";

interface State {
  item?: DetailStorageItem;
  openAddFile: boolean;
  showFile: boolean;
  isLoading: boolean;
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
      showFile: false,
      isLoading: false
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
      // item === undefined && this.props.itemID !== -1
      this.setState({ item: undefined, isLoading: true });
      let item = await fetchDetailItem(this.props.itemID);
      setTimeout(() => {
        this.setState({
          item: item,
          isLoading: false
        });
      }, 100);
    }
  }

  renderImages() {
    if (this.state.item !== undefined && this.state.item.images.length > 0) {
      return (
        <List
          style={{
            display: "flex",
            flexDirection: "row",
            overflowY: "hidden",
            width: "100%"
          }}
        >
          {this.state.item.images_objects.map((i, index) => {
            return (
              <div
                key={`avatar-${i.id}`}
                id={`images-${i.id}`}
                style={{ width: "170px", height: "170px" }}
              >
                <Avatar
                  className="m-3"
                  style={{
                    position: "absolute",
                    zIndex: 100,
                    width: "150px",
                    height: "150px"
                  }}
                  src={i.image}
                />
                <IconButton
                  style={{
                    position: "relative",
                    zIndex: 105,

                    marginLeft: "auto",
                    marginRight: "auto"
                  }}
                  onClick={() => {
                    let confirm = window.confirm("你确定要删除照片吗？");
                    if (confirm && i.id) {
                      this.deleteImage(i.id, index);
                    }
                  }}
                >
                  <ClearIcon />
                </IconButton>
              </div>
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

  deleteImage = async (id: number, index: number) => {
    try {
      let client = new CreateAndupdater<ImageObject>("image");
      await client.delete(id);
      let item = this.state.item;
      if (item) {
        item.images_objects.splice(index, 1);
        this.setState({ item });
      }
    } catch (err) {
      showNotification(err.toString());
    }
  };

  renderTextField(title: string, label?: string, value?: string, numLine = 5) {
    return (
      <div className="mb-1" style={{ position: "relative" }}>
        <Label
          color="blue"
          style={{
            position: "relative",
            zIndex: 105,
            left: "-15px",
            top: "25px"
          }}
          ribbon
        >
          {title}
          <Label.Detail>{label}</Label.Detail>
        </Label>
        <Card fluid link>
          <CardContent>
            <p>{value}</p>
          </CardContent>
        </Card>
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
    const { item, isLoading } = this.state;

    if (isLoading) {
      return (
        <div className="h-100 w-100 row">
          <div className="mx-auto my-auto">
            <Message icon>
              <Icon name="circle notched" loading />
              <Message.Content>
                <Message.Header>请稍等</Message.Header>
                正在加载内容
              </Message.Content>
            </Message>
          </div>
        </div>
      );
    } else if (item === undefined) {
      return <div />;
    } else if (item !== undefined) {
      const i = [
        {
          header: "价格",
          description: item.price
        },
        {
          header: "Column",
          description: item.column
        },
        {
          header: "Row",
          description: item.row
        }
      ];
      return (
        <Fade in={true} timeout={300}>
          <div className="container pt-4">
            <h1>{item.name}</h1>
            <span>
              {item.category_name !== null ? item.category_name.name : ""}
            </span>
            <Divider />
            <div className="pt-3">
              <h1>照片</h1>
              {this.renderImages()}
              <Card.Group itemsPerRow={3} className="pb-3" items={i} />
              <Card header="QR Code" fluid description={item.qr_code} />
              {this.renderTextField(
                "简介",
                item.description !== null ? item.description : "",
                item.description !== null ? item.description : ""
              )}
              {this.renderTextField(
                "作者",
                item.author_name !== null ? item.author_name.name : "",
                item.author_name !== null ? item.author_name.description : ""
              )}
              {this.renderTextField(
                "系列",
                item.series_name !== null ? item.series_name.name : "",
                item.series_name !== null ? item.series_name.description : ""
              )}
              {this.renderTextField(
                "位置",
                item.position_name !== null ? item.position_name.position : "",
                item.position_name !== null
                  ? item.position_name.description
                  : "",
                2
              )}
              {this.renderTextField(
                "地址",
                "",
                `${item.location_name.country}${item.location_name.city}${
                  item.location_name.street
                } ${item.location_name.building}${item.location_name.unit}${
                  item.location_name.room_number
                }`
              )}
              <h1>文件</h1>
              <Button.Group size="mini" className="mb-5">
                <Button
                  icon="add"
                  onClick={() => {
                    this.setState({ openAddFile: true });
                  }}
                />
                <Button
                  positive
                  icon={!this.state.showFile ? "expand" : "hide"}
                  disabled={item.files_objects.length === 0}
                  onClick={() => {
                    let showFile = !this.state.showFile;
                    this.setState({
                      showFile
                    });
                  }}
                />
              </Button.Group>
              {this.renderFiles(item.files_objects)}
            </div>
            <FileUploader
              existingFiles={
                this.state.item ? this.state.item.files_objects : []
              }
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
        </Fade>
      );
    }
  }
}
