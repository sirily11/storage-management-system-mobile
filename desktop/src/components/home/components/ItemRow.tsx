import React, { useContext } from "react";
import { AbstractStorageItem } from "../storageItem";
import { ListItem, ListItemText, IconButton } from "@material-ui/core";
import PrintIcon from "@material-ui/icons/Print";
import EditIcon from "@material-ui/icons/Edit";
import DeleteIcon from "@material-ui/icons/Delete";
import { HomepageContext } from "../../Datamodel/HomepageContext";
import { openEditPage, showNotification } from "../../settings/utils";
import { Link } from "react-router-dom";
import { CreateAndupdater } from "../../settings/UpdateAndCreate";

interface Props {
  selected: number;
  /**
   * When Item is selected
   * @param id
   */
  onSelected(id: number): void;
  item: AbstractStorageItem;
  style: React.CSSProperties;
  onDeleted(id: number): void;
}

/**
 *  Item row in left side of home screen
 * @param props
 */
export default function ItemRow(props: Props) {
  const { openQR, setPrintQRItem } = useContext(HomepageContext);
  return (
    <ListItem
      selected={props.item.id === props.selected}
      style={props.style}
      className="px-3"
      button
      onClick={() => {
        props.onSelected(props.item.id);
      }}
      key={`item-${props.item.id}`}
    >
      {/* Title */}
      <ListItemText
        primary={props.item.name}
        secondary={`${props.item.description} -<${props.item.category_name}>`}
      />
      {/* Buttons */}
      <Link to={`/edit/${props.item.id}`}>
        <IconButton>
          <EditIcon />
        </IconButton>
      </Link>
      <IconButton
        onClick={() => {
          openQR();
          setPrintQRItem(props.item);
        }}
      >
        <PrintIcon />
      </IconButton>
      <IconButton
        onClick={async () => {
          let willDelete = window.confirm("真的要删除吗？");
          if (willDelete) {
            try {
              let client = new CreateAndupdater<AbstractStorageItem>("item");
              await client.delete(props.item.id);
              props.onDeleted(props.item.id);
            } catch (err) {
              showNotification(err.toString());
            }
          }
        }}
      >
        <DeleteIcon />
      </IconButton>
    </ListItem>
  );
}
