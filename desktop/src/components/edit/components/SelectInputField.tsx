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
  values: any[];
  onAdd(from: string): void;
  onUpdate(from: string): void;
}

export default function SelectInputField(props: Props) {
  const context = useContext(FormContext);
  return (
    <Paper className="d-flex mt-3">
      <FormControl className="col-md-4 col-6 m-3">
        <InputLabel>{props.label}</InputLabel>
        <Select
          required
          value={context.getForm(props.label)}
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
        <IconButton>
          <AddIcon />
        </IconButton>
        <IconButton>
          <RemoveIcon />
        </IconButton>
        <IconButton>
          <EditIcon />
        </IconButton>
      </div>
    </Paper>
  );
}
