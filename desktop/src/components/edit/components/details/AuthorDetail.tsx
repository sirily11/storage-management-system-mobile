import React, { Component } from "react";
import { Author } from "../../../home/storageItem";
import { Dialog, DialogTitle, DialogContent } from "@material-ui/core";
import Form from "react-jsonschema-form";
import { authorSchema } from "./uiForm";
import { CreateAndupdater } from "../../../settings/UpdateAndCreate";
import GenericDetailPage, { GenericProps } from "./GenericDetail";

export default class AuthorDetail extends GenericDetailPage<Author> {
  showSearch = true;
  title = "作者";
  formData = { name: "", id: -1 };

  constructor(props: GenericProps<Author>) {
    super(props);
    this.schema = authorSchema;
    this.pathName = "author";
    this.createAndUpdater = new CreateAndupdater<Author>(this.pathName);
    this.state = {
      formData: this.formData,
      language: "Chinese"
    };
  }
}
