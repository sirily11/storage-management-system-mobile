import React, { useContext } from "react";
import {
  TextField,
  Grid,
  GridList,
  GridListTile,
  InputAdornment,
  FormControl,
  InputLabel,
  MenuItem,
  FormHelperText
} from "@material-ui/core";
import { FormContext } from "../../Datamodel/FormContext";
import { Input, Dropdown, Form, Label, LabelDetail } from "semantic-ui-react";
import Select from "react-select";
import { unitOptions } from "../../home/storageItem";

const multiplesType = ["col", "row", "price"];

interface Props {
  unit?: string;
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
              className="mt-3 mb-1"
              value={value !== null ? value : ""}
              key={label}
            />
          );
        })}
      </div>
    );
  }

  return (
    <div className="row">
      {props.labels.map((label, index) => {
        const value = formContext.getForm(label.toLocaleLowerCase());
        return (
          <Input
            fluid
            type={props.number ? "number" : undefined}
            key={`${label}-label`}
            className={`mt-3 col-${props.labels.length === 3 ? "4" : "12"}`}
            value={value !== null ? value : ""}
            label={label}
            action={
              label.includes("Price") ? (
                <Dropdown
                  button
                  basic
                  floating
                  value={formContext.getForm("unit")}
                  options={unitOptions}
                  onChange={(e, { value }) => {
                    formContext.setForm("unit", value);
                  }}
                />
              ) : (
                undefined
              )
            }
            onChange={e => {
              if (props.type !== "multiple") {
                formContext.setForm(props.type, e.target.value);
              } else {
                formContext.setForm(label.toLocaleLowerCase(), e.target.value);
              }
            }}
            placeholder={label}
          />
        );
      })}
    </div>
  );
}
