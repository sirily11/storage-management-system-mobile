import React from "react";
import { Schema, Widget } from "../model/Schema";
import { Input, Form } from "semantic-ui-react";

export interface FieldProps {
  schema: Schema;
  onSaved(value: any): void;
}

export default function JSONSchemaTextField(props: FieldProps) {
  const { schema, onSaved } = props;

  function hasError() {
    if (schema.required && schema.value === undefined) {
      return { content: "This field is required", pointing: "below" };
    }

    return;
  }

  return (
    <Form.Input
      control={Input}
      label={schema.label}
      error={hasError()}
      onChange={(e, { value }) => {
        onSaved(value);
      }}
      // defaultValue={
      //   schema.value ? schema.value : schema.extra && schema.extra.default
      // }
      defaultValue={schema.value}
    ></Form.Input>
  );
}
