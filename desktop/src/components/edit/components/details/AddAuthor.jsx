import React, { Component } from "react";
import { CreateAndUpdaterPage } from "./GenericDetail";
import { Author } from "../../../home/storageItem";
import { Dialog, DialogTitle, DialogContent } from "@material-ui/core";
import Form from "react-jsonschema-form";
import { authorSchema } from "./uiForm";

// interface Props {
//   open: boolean;
// }

// interface State {}

export default class AddAuthor extends Component {
  constructor(props) {
    super(props);
  }

  // async create(object: Author) {}
  // async update(object: Author, id: number) {}

  render() {
    return (
      <Dialog open={true} fullWidth>
        <DialogTitle>设置作者</DialogTitle>
        <DialogContent>
          <Form
            schema={authorSchema}
            onChange={({ formData }) => {
              console.log(formData);
            }}
          />
        </DialogContent>
      </Dialog>
    );
  }
}
