import React, { Component } from "react";
import GenericDetailPage, { GenericProps } from "./GenericDetail";
import { Category } from "../../../home/storageItem";
import { categorySchema } from "./uiForm";
import { CreateAndupdater } from "../../../settings/UpdateAndCreate";

export class CategoryDetail extends GenericDetailPage<Category> {
  constructor(props: GenericProps<Category>) {
    super(props);
    this.formData = {
      name: "",
      id: -1
    };
    this.title = "类别";
    this.pathName = "category";
    this.createAndUpdater = new CreateAndupdater<Category>(this.pathName);
    this.schema = categorySchema;
    this.state = {
      formData: this.formData
    };
  }
}
