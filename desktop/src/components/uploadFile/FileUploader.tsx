import React, { Component } from "react";
import CloudUploadIcon from "@material-ui/icons/CloudUpload";
import {
  Dialog,
  DialogTitle,
  Tooltip,
  IconButton,
  DialogContent,
  Collapse,
  List,
  DialogActions,
  Button,
  LinearProgress,
  Fade
} from "@material-ui/core";
import { FixedSizeList } from "react-window";
import AutoSizer from "react-virtualized-auto-sizer";
import path from "path";
import { IpcRenderer, Dialog as EDialog, ipcRenderer } from "electron";
import { FileRow } from "./FileRow";
import { CreateAndupdater } from "../settings/UpdateAndCreate";
import { showNotification } from "../settings/utils";
import { FileObject } from "../home/storageItem";
const electron = (window as any).require("electron");
const dialog: EDialog = electron.remote.dialog;

interface Props {
  open: boolean;
  itemID: number;
  existingFiles: FileObject[];
  onSave?(files: FileObject[]): void;
  onClose?(): void;
}

interface State {
  progress?: number;
  files: string[];
}

function arrayUnique(array: any[]) {
  var a = array.concat();
  for (var i = 0; i < a.length; ++i) {
    for (var j = i + 1; j < a.length; ++j) {
      if (a[i] === a[j]) {
        a.splice(j--, 1);
      }
    }
  }

  return a;
}

export default class FileUploader extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      files: []
    };
  }

  openFile = async () => {
    let file = await dialog.showOpenDialog({
      properties: ["openFile", "multiSelections"],
      filters: [
        { name: "Images", extensions: ["jpg", "png", "gif"] },
        { name: "Movies", extensions: ["mkv", "avi", "mp4"] },
        { name: "Custom File Type", extensions: ["as"] },
        { name: "All Files", extensions: ["*"] }
      ]
    });

    if (file.filePaths) {
      let paths = file.filePaths.map(p => p.replace(/^.*[\\\/]/, ""));
      for (let f of paths) {
        for (let f2 of this.props.existingFiles) {
          console.log(f2.file, f, f2.file === f);
          if (f2.file === f) {
            showNotification("文件已存在");
            return;
          }
        }
      }

      let oldPath = this.state.files;
      let newPath = arrayUnique([...paths, ...oldPath]);
      this.setState({ files: newPath });
    }
  };

  upload = async () => {
    let data: FileObject[] | undefined;
    try {
      let client = new CreateAndupdater<FileObject[]>("files");
      let files: FileObject[] = this.state.files.map(p => {
        return { file: p, item: this.props.itemID };
      });
      data = await client.create(files, (progress: number) => {
        this.setState({ progress });
      });
    } catch (err) {
      showNotification(err.toString());
    } finally {
      setTimeout(() => {
        this.setState({ progress: undefined });
        if (this.props.onSave && data) {
          // TODO: change it to return real file
          this.props.onSave(data);
        }
      }, 500);
    }
  };

  delete = (index: number) => {
    let files = this.state.files;

    files.splice(index, 1);
    this.setState({ files });
  };

  renderFileList() {
    return (
      <List>
        {this.state.files.map((file, index) => {
          return (
            <Collapse in={true} timeout={600}>
              <FileRow index={index} filePath={file} onDelete={this.delete} />
            </Collapse>
          );
        })}
      </List>
    );
  }

  render() {
    const { files } = this.state;
    return (
      <Dialog open={this.props.open} fullWidth>
        <Collapse in={this.state.progress !== undefined}>
          <LinearProgress
            className="mt-3"
            variant="determinate"
            value={this.state.progress}
          />
        </Collapse>

        <DialogTitle>
          上传文件名{" "}
          <Tooltip title="上传文件">
            <IconButton onClick={this.openFile}>
              <CloudUploadIcon />
            </IconButton>
          </Tooltip>
        </DialogTitle>
        <DialogContent>
          <h5>文件</h5>
          {this.renderFileList()}
        </DialogContent>
        <DialogActions>
          <Button disabled={files.length === 0} onClick={this.upload}>
            上传
          </Button>
          <Button
            onClick={() => {
              if (this.props.onClose) {
                this.props.onClose();
              }
            }}
          >
            取消
          </Button>
        </DialogActions>
      </Dialog>
    );
  }
}
