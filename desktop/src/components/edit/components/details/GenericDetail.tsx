import { CreateAndupdater } from "../../../settings/UpdateAndCreate";
import React, { Component } from "react";
import {
  DialogTitle,
  DialogContent,
  Dialog,
  IconButton
} from "@material-ui/core";
import Form from "react-jsonschema-form";
import DeleteIcon from "@material-ui/icons/Delete";
import { showNotification } from "../../../settings/utils";

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
