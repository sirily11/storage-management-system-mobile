import React, { useContext } from "react";
import AddIcon from "@material-ui/icons/Add";
import RemoveIcon from "@material-ui/icons/Remove";
import EditIcon from "@material-ui/icons/Edit";
import { FormContext } from "../../Datamodel/FormContext";
import { Button, Dropdown, Label } from "semantic-ui-react";

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
  const options = props.values.map((v, i) => ({
    value: v,
    text: props.labels[i]
  }));

  return (
    <div className="d-flex mt-3">
      <Dropdown
        className="h-50"
        fluid
        search
        selection
        placeholder={props.label}
        options={options}
        value={context.getForm(props.label)}
        onChange={(e, { value }) => {
          context.setForm(props.label, value);
        }}
      />
      <div className="col-md-4 col-6 mb-3">
        <Button.Group size="mini" icon>
          <Button
            positive
            onClick={() => {
              props.onAdd(props.type);
            }}
          >
            <AddIcon />
          </Button>
          <Button color="blue">
            <RemoveIcon />
          </Button>
          <Button
            disabled={context.getForm(props.type) < 0}
            onClick={() => {
              props.onUpdate(props.type);
            }}
          >
            <EditIcon />
          </Button>
        </Button.Group>
        <Label className="ml-4 position-absolute" color="red" tag>
          必须项
        </Label>
      </div>
    </div>
  );
}
