import { ListChildComponentProps } from "react-window";
import React, { Component } from "react";
import FolderIcon from "@material-ui/icons/Folder";
import DeleteIcon from "@material-ui/icons/Delete";
import {
  ListItem,
  ListItemText,
  ListItemIcon,
  IconButton
} from "@material-ui/core";

interface Props {
  style?: React.CSSProperties;
  index: number;
  filePath: string;
  onDelete?(index: number): void;
}

export function FileRow(props: Props) {
  const { index, style, filePath } = props;

  return (
    <ListItem button style={style} key={index}>
      <ListItemIcon>
        <FolderIcon />
      </ListItemIcon>
      <ListItemText primary={filePath} />
      <IconButton
        onClick={() => {
          if (props.onDelete) {
            props.onDelete(props.index);
          }
        }}
      >
        <DeleteIcon />
      </IconButton>
    </ListItem>
  );
}
