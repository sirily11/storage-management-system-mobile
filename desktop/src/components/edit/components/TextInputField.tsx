import React, { useContext } from "react";
import {
  TextField,
  Grid,
  GridList,
  GridListTile,
  InputAdornment
} from "@material-ui/core";
import { FormContext } from "../../Datamodel/FormContext";
import { Input, Dropdown } from "semantic-ui-react";
import Select from "react-select";

const multiplesType = ["col", "row", "price"];

interface Props {
  labels: string[];
  values?: string[];
  onchanges?: any[];
  multiline: boolean;
  varient?: any;
  number?: boolean;
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
  // multiline style
  if (props.multiline === true) {
    return (
      <div>
        {props.labels.map((label, index) => {
          const value = formContext.getForm(label.toLocaleLowerCase());
          return (
            <TextField
              type={props.number ? "number" : undefined}
              onChange={e => {
                formContext.setForm(label.toLocaleLowerCase(), e.target.value);
              }}
              required
              InputLabelProps={{ shrink: true }}
              variant={props.varient}
              fullWidth
              rows={3}
              multiline={true}
              label={label}
              // defaultValue={props.values ? props.values[index] : ""}
              className="mt-3"
              value={value !== null ? value : ""}
              key={label}
            />
          );
        })}
      </div>
    );
  }

  return (
    <GridList cols={props.labels.length} cellHeight={70} spacing={30}>
      {props.labels.map((label, index) => {
        const value = formContext.getForm(label.toLocaleLowerCase());
        return (
          <GridListTile cols={1}>
            <TextField
              required
              InputLabelProps={{ shrink: true }}
              type={props.number ? "number" : undefined}
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
              value={value !== null ? value : ""}
              fullWidth
            />
          </GridListTile>
        );
      })}
    </GridList>
  );
}
