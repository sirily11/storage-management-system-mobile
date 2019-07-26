import React, { useContext } from "react";
import {
  Paper,
  InputBase,
  IconButton,
  Divider,
  Tooltip
} from "@material-ui/core";
import RefreshIcon from "@material-ui/icons/Refresh";
import CameraAltIcon from "@material-ui/icons/CameraAlt";
import CropFreeIcon from "@material-ui/icons/CropFree";
import CreateIcon from "@material-ui/icons/Create";
import { HomepageContext } from "../../Datamodel/HomepageContext";
import { openEditPage } from "../../settings/utils";
import { Link } from "react-router-dom";

interface Props {
  search(
    event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>
  ): void;
  refresh(): void;
  listener: any;
}

export default function SearchField(props: Props) {
  const { openRemoteScanner, openLocalScanner } = useContext(HomepageContext);

  return (
    <div className="sticky-top w-100 h-10" style={{ zIndex: 10 }}>
      <Paper className="d-flex w-100" elevation={0}>
        <InputBase
          className="col-md-7"
          placeholder={"Item name"}
          onChange={props.search}
        />
        <div className="col-md-5 row">
          <Tooltip title="Refresh">
            <IconButton onClick={props.refresh}>
              <RefreshIcon />
            </IconButton>
          </Tooltip>
          <Tooltip title="Scan from mobile">
            <IconButton onClick={openRemoteScanner}>
              <CameraAltIcon />
            </IconButton>
          </Tooltip>
          <Tooltip title="Scan from Scanner">
            <IconButton
              onClick={() => {
                openLocalScanner();
                document.removeEventListener("keypress", props.listener);
              }}
            >
              <CropFreeIcon />
            </IconButton>
          </Tooltip>
          <Tooltip title="Open Edit page">
            <Link to="/edit">
              <IconButton>
                <CreateIcon />
              </IconButton>
            </Link>
          </Tooltip>
        </div>
      </Paper>
    </div>
  );
}
