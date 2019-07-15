import React from "react";
import { Category } from "../storageItem";
import {
  FormGroup,
  InputLabel,
  MenuItem,
  Select,
  FormControl
} from "@material-ui/core";

interface Props {
  categories: Category[];
  onchange?(newValue: string): void;
  value: string;
}

export default function FilterField(props: Props) {
  return (
    <FormControl fullWidth className="mb-3">
      <InputLabel>Category</InputLabel>
      <Select
        value={props.value}
        onChange={e => {
          if (props.onchange) {
            props.onchange(e.target.value as string);
          }
        }}
      >
        {props.categories.map((category, index) => {
          return <MenuItem key={`${index}-category`}>{category.name}</MenuItem>;
        })}
      </Select>
    </FormControl>
  );
}
