import React, { useContext } from "react";
import { AbstractStorageItem } from "../storageItem";
import { ListItem, ListItemText, IconButton } from "@material-ui/core";
import PrintIcon from "@material-ui/icons/Print";
import EditIcon from "@material-ui/icons/Edit";
import { HomepageContext } from "../../Datamodel/HomepageContext";
import { openEditPage } from "../../settings/utils";

interface Props {
  selected: number;
  onSelected(id: number): void;
  item: AbstractStorageItem;
  style: React.CSSProperties;
}

export default function ItemRow(props: Props) {
  const { openQR, setPrintQRItem } = useContext(HomepageContext);
  return (
    <ListItem
      selected={props.item.id === props.selected}
      style={props.style}
      button
    >
      <ListItemText
        primary={props.item.name}
        secondary={`${props.item.description} ${props.item.category_name}`}
        onClick={() => {
          props.onSelected(props.item.id);
        }}
      />
      <IconButton
        onClick={() => {
          openEditPage({ isEdit: false, id: props.item.id });
        }}
      >
        <EditIcon />
      </IconButton>
      <IconButton
        onClick={() => {
          openQR();
          setPrintQRItem(props.item);
        }}
      >
        <PrintIcon />
      </IconButton>
    </ListItem>
  );
}
