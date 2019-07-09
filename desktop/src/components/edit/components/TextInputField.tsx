import React, { useContext } from "react";
import { TextField, Grid, GridList, GridListTile } from "@material-ui/core";
import { FormContext } from "../../Datamodel/FormContext";

interface Props {
  labels: string[];
  values?: string[];
  onchanges?: any[];
  multiline: boolean;
  varient?: any;
  type:
    | "name"
    | "description"
    | "qrCode"
    | "price"
    | "col"
    | "row"
    | "multiple";
}

export default function TextInputField(props: Props) {
  const formContext = useContext(FormContext);
  if (props.multiline === true) {
    return (
      <div>
        {props.labels.map((label, index) => {
          return (
            <TextField
              onChange={e => {
                if (props.type !== "multiple") {
                  formContext.setForm(props.type, e.target.value);
                } else {
                  formContext.setForm(
                    label.toLocaleLowerCase(),
                    e.target.value
                  );
                }
              }}
              required
              variant={props.varient}
              fullWidth
              rows={3}
              multiline={true}
              label={label}
              defaultValue={props.values ? props.values[index] : ""}
              key={label}
            />
          );
        })}
      </div>
    );
  }

  return (
    <GridList cols={props.labels.length} cellHeight={80} spacing={30}>
      {props.labels.map((label, index) => {
        return (
          <GridListTile cols={1}>
            <TextField
              required
              onChange={e => {
                if (props.type !== "multiple") {
                  formContext.setForm(props.type, e.target.value);
                } else {
                  formContext.setForm(
                    label.toLocaleLowerCase(),
                    e.target.value
                  );
                }
              }}
              className="my-2"
              variant={props.varient}
              label={label}
              key={`${label}-label`}
              defaultValue={props.values ? props.values[index] : ""}
              fullWidth
            />
          </GridListTile>
        );
      })}
    </GridList>
  );
}
