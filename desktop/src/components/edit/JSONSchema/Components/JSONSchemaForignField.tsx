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
import { Schema } from "../model/Schema";
import JSONSchema from "../JSONSchema";

interface Props extends FieldProps {
  url: string;
}

export default function JSONSchemaForignField(props: Props) {
  const { schema, onSaved, url } = props;
  const [list, setList] = useState<any[]>();
  const [editSchema, setSchema] = useState<Schema[]>();
  const [selected, setSelect] = useState<number>();
  const [loading, setLoading] = useState(false);

  function getURL(path: string) {
    return `${url}${path}`;
  }

  const fetchList = async () => {
    if (schema.extra) {
      let url = getURL(schema.extra.related_model.replace("-", "_") + "/");
      let response = await axios.get<any[]>(url);

      return response.data;
    }
  };

  const fetchSchema = async () => {
    if (schema.extra) {
      let url = getURL(schema.extra.related_model.replace("-", "_") + "/");
      let response = await axios.request({ method: "OPTIONS", url: url });
      setSchema(response.data.fields);
    }
  };

  const update = async (data: any) => {
    setLoading(true);
    if (schema.extra) {
      let url = getURL(
        schema.extra.related_model.replace("-", "_") + "/" + selected + "/"
      );
      let response = await axios.patch(url, data);
    }
    setLoading(false);
  };

  const create = async (data: any) => {
    setLoading(true);
    if (schema.extra) {
      let url = getURL(schema.extra.related_model.replace("-", "_") + "/");
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

  const value = () => {
    if (selected === undefined) {
      if (schema.choice) {
        return schema.choice.value;
      }
    } else {
      return selected;
    }
  };

  return (
    <Grid>
      <Grid.Row columns="equal">
        <Grid.Column width={10}>
          <Dropdown
            value={value()}
            labeled
            placeholder={`Select ${schema.label}`}
            fluid
            search
            selection
            onChange={(e, { value }) => {
              setSelect(value as number);
              onSaved(value as string);
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
          <Modal
            trigger={
              <Button
                icon="add"
                color="blue"
                onClick={async () => await fetchSchema()}
              ></Button>
            }
          >
            <Modal.Content image>
              <Modal.Description style={{ width: "100%" }}>
                <Header>Add {schema.label}</Header>
                {editSchema && (
                  <JSONSchema
                    schemas={editSchema}
                    url={url}
                    onSubmit={create}
                  ></JSONSchema>
                )}
              </Modal.Description>
            </Modal.Content>
          </Modal>

          <Modal
            trigger={
              <Button
                icon="edit"
                color="blue"
                disabled={schema.value === undefined}
                onClick={async () => {
                  await fetchSchema();
                }}
              ></Button>
            }
          >
            <Modal.Content image>
              <Modal.Description style={{ width: "100%" }}>
                <Header>Add {schema.label}</Header>
                {editSchema && (
                  <JSONSchema
                    schemas={editSchema}
                    values={list && list.find(l => l.id === selected)}
                    url={url}
                    onSubmit={update}
                    loading={loading}
                  ></JSONSchema>
                )}
              </Modal.Description>
            </Modal.Content>
          </Modal>
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
