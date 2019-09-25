import React, { useState } from "react";
import { FieldProps } from "./JSONSchemaTextField";
import {
  Form,
  Dropdown,
  Label,
  Button,
  Grid,
  Modal,
  Header
} from "semantic-ui-react";
import axios from "axios";
import { Schema, Choice } from "../model/Schema";
import JSONSchema from "../JSONSchema";
import { Dialog, DialogContent, DialogTitle } from "@material-ui/core";

interface Props extends FieldProps {
  url: string;
  select(choice: Choice): void;
}

export default function JSONSchemaForignField(props: Props) {
  const { schema, onSaved, url } = props;
  const [list, setList] = useState<any[]>();
  const [editSchema, setSchema] = useState<Schema[]>();
  const [selected, setSelect] = useState<number>(
    schema.choice && schema.choice.value
  );
  const [loading, setLoading] = useState(false);
  const [openDialogIndex, setOpen] = useState(-1);

  function getURL(path?: string) {
    return `${url}${path}`;
  }

  /**
   * Fetch selection
   */
  const fetchList = async () => {
    if (schema.extra) {
      let url = getURL(
        schema.extra.related_model &&
          schema.extra.related_model.replace("-", "_") + "/"
      );
      let response = await axios.get<any[]>(url);

      return response.data;
    }
  };

  /**
   * Fetch schema
   */
  const fetchSchema = async () => {
    if (schema.extra) {
      let url = getURL(
        schema.extra.related_model &&
          schema.extra.related_model.replace("-", "_") + "/"
      );
      let response = await axios.request({ method: "OPTIONS", url: url });
      setSchema(response.data.fields);
    }
  };

  /**
   * Update forign key
   * @param data json data
   */
  const update = async (data: any) => {
    setLoading(true);
    if (schema.extra) {
      let url = getURL(
        schema.extra.related_model &&
          schema.extra.related_model.replace("-", "_") + "/" + selected + "/"
      );
      let response = await axios.patch(url, data);
    }
    setLoading(false);
  };

  /**
   * Create forign key
   * @param data JSon Data
   */
  const create = async (data: any) => {
    setLoading(true);
    if (schema.extra) {
      let url = getURL(
        schema.extra.related_model &&
          schema.extra.related_model.replace("-", "_") + "/"
      );
      let response = await axios.post(url, data);
    }
    setLoading(false);
  };

  const options = () => {
    if (list !== undefined) {
      return list.map(l => {
        return { key: l.id, text: l.name, value: l.id };
      });
    } else {
      if (schema.choice) {
        return [
          {
            text: schema.choice.label,
            key: schema.choice.value,
            value: schema.choice.value
          }
        ];
      } else {
        return [];
      }
    }
  };

  return (
    <Grid>
      <Grid.Row columns="equal">
        <Grid.Column width={10}>
          <Dropdown
            value={schema.choice && schema.choice.value}
            labeled
            placeholder={`Select ${schema.label}`}
            fluid
            search
            selection
            onChange={(e, { value }) => {
              setSelect(value as number);
              onSaved(value as string);
              if (list) {
                let selected = list.find(l => l.id === value);
                props.select({ label: selected.name, value: selected.id });
              }
            }}
            options={options()}
            onClick={async () => {
              let result = await fetchList();
              if (result) {
                setList(result);
              }
            }}
          />
        </Grid.Column>
        <Grid.Column>
          <Button
            icon="add"
            color="blue"
            onClick={async () => {
              setOpen(0);
              await fetchSchema();
            }}
          ></Button>
          <Button
            icon="edit"
            color="blue"
            disabled={schema.value === undefined}
            onClick={async () => {
              setOpen(1);
              let list = await fetchList();
              setList(list);
              await fetchSchema();
            }}
          ></Button>
          <Dialog
            open={openDialogIndex === 0}
            onClose={() => setOpen(-1)}
            fullWidth
          >
            <DialogTitle>Add {schema.label}</DialogTitle>
            <DialogContent>
              {editSchema && (
                <JSONSchema
                  schemas={editSchema}
                  url={url}
                  onSubmit={create}
                ></JSONSchema>
              )}
            </DialogContent>
          </Dialog>

          <Dialog
            open={openDialogIndex === 1}
            onClose={() => setOpen(-1)}
            fullWidth
          >
            <DialogTitle>Edit {schema.label}</DialogTitle>
            <DialogContent>
              {editSchema && (
                <JSONSchema
                  schemas={editSchema}
                  values={list && list.find(l => l.id === selected)}
                  url={url}
                  onSubmit={update}
                  loading={loading}
                ></JSONSchema>
              )}
            </DialogContent>
          </Dialog>
        </Grid.Column>
        {schema.required && !schema.value && (
          <Grid.Column>
            <Label tag color="red">
              Required
            </Label>
          </Grid.Column>
        )}
      </Grid.Row>
    </Grid>
  );
}
