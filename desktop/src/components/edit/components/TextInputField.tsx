import React, { useContext } from "react";
import { TextField, Grid, GridList, GridListTile } from "@material-ui/core";
import { FormContext } from "../../Datamodel/FormContext";

interface Props {
  labels: string[];
  values?: string[];
  onchanges?: any[];
  multiline: boolean;
  varient?: any;
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
                formContext.setForm(label, e.target.value);
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
                formContext.setForm(label, e.target.value);
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
