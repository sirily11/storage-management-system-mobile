import React, { Component } from "react";
import GenericDetailPage, { GenericProps } from "./GenericDetail";
import { Position } from "../../../home/storageItem";
import { positionSchema } from "./uiForm";
import { CreateAndupdater } from "../../../settings/UpdateAndCreate";

export class PositionDetail extends GenericDetailPage<Position> {
  constructor(props: GenericProps<Position>) {
    super(props);
    this.formData = {
      position: "",
      description: "",
      id: -1
    };
    this.title = "详细位置";
    this.pathName = "position"
    this.createAndUpdater = new CreateAndupdater<Position>(this.pathName);
    this.schema = positionSchema;
    this.state = {
      formData: this.formData
    };
  }
}
