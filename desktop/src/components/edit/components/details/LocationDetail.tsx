import React, { Component } from "react";
import GenericDetailPage, { GenericProps } from "./GenericDetail";
import { Location } from "../../../home/storageItem";
import { locationSchema } from "./uiForm";
import { CreateAndupdater } from "../../../settings/UpdateAndCreate";

export class LocationDetail extends GenericDetailPage<Location> {
  showSearch = false;
  title = "地址";
  formData = {
    street: "",
    country: "",
    building: "",
    unit: "",
    city: "",
    room_number: "",
    id: -1
  };

  constructor(props: GenericProps<Location>) {
    super(props);
    this.pathName = "location";
    this.createAndUpdater = new CreateAndupdater<Location>(this.pathName);
    this.schema = locationSchema;
    this.state = {
      formData: this.formData,
      language: "Chinese"
    };
  }
}
