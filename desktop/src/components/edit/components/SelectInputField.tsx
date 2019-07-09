import React, { useContext } from "react";
import AddIcon from "@material-ui/icons/Add";
import RemoveIcon from "@material-ui/icons/Remove";
import EditIcon from "@material-ui/icons/Edit";
import {
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  IconButton,
  Paper
} from "@material-ui/core";
import { FormContext } from "../../Datamodel/FormContext";

interface Props {
  label: string;
  labels: string[];
  type: "category" | "series" | "author" | "location" | "position";
  values: any[];
  onAdd(from: "category" | "series" | "author" | "location" | "position"): void;
  onUpdate(
    from: "category" | "series" | "author" | "location" | "position"
  ): void;
}

export default function SelectInputField(props: Props) {
  const context = useContext(FormContext);
  return (
    <Paper className="d-flex mt-3">
      <FormControl className="col-md-4 col-6 m-3">
        <InputLabel>{props.label}</InputLabel>
        <Select
          required
          value={context.getForm(props.type)}
          onChange={e => {
            context.setForm(props.label, e.target.value);
          }}
        >
          {props.labels.map((label, index) => (
            <MenuItem
              key={`menu-${label}-${index}`}
              value={props.values[index]}
            >
              {label}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
      <div className="col-md-4 col-6 m-3">
        <IconButton
          onClick={() => {
            props.onAdd(props.type);
          }}
        >
          <AddIcon />
        </IconButton>
        <IconButton>
          <RemoveIcon />
        </IconButton>
        <IconButton
          disabled={context.getForm(props.type) < 0}
          onClick={() => {
            props.onUpdate(props.type);
          }}
        >
          <EditIcon />
        </IconButton>
      </div>
    </Paper>
  );
}
