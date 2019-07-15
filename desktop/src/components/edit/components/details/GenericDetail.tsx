import { CreateAndupdater } from "../../../settings/UpdateAndCreate";
import React, { Component } from "react";
import {
  DialogTitle,
  DialogContent,
  Dialog,
  IconButton,
  FormControl,
  InputLabel,
  Select,
  MenuItem
} from "@material-ui/core";
import Form from "react-jsonschema-form";
import SearchIcon from "@material-ui/icons/Search";
import DeleteIcon from "@material-ui/icons/Delete";
import { showNotification } from "../../../settings/utils";
import wiki from "wikijs";
import { async, reject } from "q";

export interface GenericProps<T> {
  open: boolean;
  close(): void;
  isEdit: boolean;
  data?: T | any;
  onCreate?(object: T, path: string): void;
  onUpdate?(object: T, path: string): void;
  onDelete?(id: number, path: string): void;
}

export interface GenericState<T> {
  formData?: T;
  id?: number;
  language: string;
}

function isChinese(text: string) {
  var re = /[^\u4e00-\u9fa5]/;
  if (re.test(text)) return false;
  return true;
}

export default class GenericDetailPage<T> extends Component<
  GenericProps<T>,
  GenericState<T>
> {
  createAndUpdater: CreateAndupdater<T>;
  pathName: any;
  title?: string;
  formData?: T;
  schema: any;
  showSearch: boolean = true;
  language: string = "Chinese";

  constructor(props: GenericProps<T>) {
    super(props);
    this.createAndUpdater = new CreateAndupdater<T>(this.pathName);
  }

  componentDidUpdate(oldProps: GenericProps<T>) {
    if (this.props.isEdit !== oldProps.isEdit && this.props.isEdit) {
      this.setState({ formData: this.props.data, id: this.props.data.id });
    } else if (this.props.isEdit !== oldProps.isEdit && !this.props.isEdit) {
      this.setState({ formData: this.formData });
    } else if (
      !this.props.open &&
      !this.props.isEdit &&
      this.state.formData !== this.formData
    ) {
      this.setState({ formData: this.formData });
    }
  }

  async create(object: T) {
    try {
      let newObj = await this.createAndUpdater.create(object);
      if (this.props.onCreate) {
        this.props.onCreate(newObj, this.pathName);
      }
      this.props.close();
    } catch (err) {
      showNotification(err.toString());
    }
  }

  /**
   * Update the database
   * @param object update's object
   * @param id object's id
   */
  async update(object: T, id: number) {
    try {
      let newObj = await this.createAndUpdater.update(object, id);
      if (this.props.onUpdate) {
        this.props.onUpdate(newObj, this.pathName);
      }
      this.props.close();
    } catch (err) {
      showNotification(err.toString());
    }
  }

  /**
   * Delete by id
   */
  delete = async (id: number) => {
    try {
      let newObj = await this.createAndUpdater.delete(id);
      if (this.props.onDelete) {
        this.props.onDelete(id, this.pathName);
      }
      this.props.close();
    } catch (err) {
      showNotification(err.toString());
    }
  };

  _search = async (
    keyword: string,
    url: string
  ): Promise<string | undefined> => {
    return new Promise(async (resolve, reject) => {
      try {
        let page = await wiki({
          apiUrl: url
        }).find(keyword);
        let summary = await page.summary();
        resolve(summary.substr(0, 1024));
      } catch (err) {
        reject(err);
      }
    });
  };

  /**
   * Search by keyword
   */
  search = async (keyword: string) => {
    let chinese = "https://zh.wikipedia.org/w/api.php";
    let english = "https://en.wikipedia.org/w/api.php";
    let summary: string | undefined;

    try {
      if (this.state.language.includes("English")) {
        summary = await this._search(keyword, english);
      } else {
        summary = await this._search(keyword, chinese);
      }
      if (summary) {
        let confirm = window.confirm(`添加内容“${summary}?”`);
        let formData = this.state.formData;
        if (formData && confirm) {
          (formData as any).description = summary;
          this.setState({ formData });
        }
      }
    } catch (err) {
      showNotification(err.toString());
    }
  };

  renderSelect = () => {
    return (
      <FormControl fullWidth>
        <InputLabel>Language</InputLabel>
        <Select
          fullWidth
          value={this.state.language}
          defaultValue="Chinese"
          onChange={e => {
            let s = e.target.value as string;
            this.setState({ language: s });
          }}
        >
          <MenuItem value="Chinese">Chinese</MenuItem>
          <MenuItem value="English">English</MenuItem>
        </Select>
      </FormControl>
    );
  };

  render() {
    return (
      <Dialog open={this.props.open} onClose={this.props.close} fullWidth>
        <DialogTitle>
          {this.props.isEdit ? "编辑" : "添加"}
          {this.title}
          {this.props.isEdit && (
            <IconButton
              onClick={() => {
                if (this.state.id) {
                  this.delete(this.state.id);
                }
              }}
            >
              <DeleteIcon />
            </IconButton>
          )}

          <IconButton
            hidden={!this.showSearch}
            onClick={() => {
              if (this.state.formData) {
                this.search((this.state.formData as any).name);
              }
            }}
          >
            <SearchIcon />
          </IconButton>
          {this.renderSelect()}
        </DialogTitle>
        <DialogContent>
          <Form
            schema={this.schema}
            formData={this.state.formData}
            onChange={({ formData }) => {
              this.setState({ formData });
            }}
            onSubmit={e => {
              const { formData, id } = this.state;
              if (this.props.isEdit) {
                if (formData && id) {
                  this.update(formData, id);
                }
              } else {
                if (formData) {
                  this.create(formData);
                }
              }
            }}
          />
        </DialogContent>
      </Dialog>
    );
  }
}
