import React, { Component, useContext } from "react";
import { AbstractStorageItem } from "./storageItem";
import axios from "axios";
import { getURL } from "../settings/settings";
import { computeDownloadProgress, showNotification } from "../settings/utils";
import { FixedSizeList as List } from "react-window";
import AutoSizer from "react-virtualized-auto-sizer";
import ItemRow from "./components/ItemRow";
import {
  InputBase,
  Divider,
  Collapse,
  Paper,
  IconButton,
  Fade
} from "@material-ui/core";

import RemoteScannerPage from "../remoteScanner/RemoteScannerPage";
import QRDownload from "../QRDownload/QRDownload";
import { HomepageContext } from "../Datamodel/HomepageContext";
import SearchField from "./components/SearchField";
import ItemDetailPage from "./components/ItemDetailPage";
import LocalScanner from "../LocalScanner/LocalScanner";
import LoadingProgress from "./components/LoadingProgress";

let qrCode = "";
let _lasttime: number | undefined;
const waitAndDispearTime = 600;

interface Props {}

interface State {
  abstractItem: AbstractStorageItem[];
  searchItems: AbstractStorageItem[];
  selectedId: number;
  searchKeyword?: string;
  loadingProgress?: number;
  // qrcode for search
  qrCode: string;
  _lasttime?: number;
}

export default class Homepage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      abstractItem: [],
      searchItems: [],
      selectedId: -1,
      searchKeyword: undefined,
      loadingProgress: undefined,
      qrCode: ""
    };
  }

  async componentDidMount() {
    await this._onmount();
    document.addEventListener("keypress", this._handleScanner);
  }

  _onmount = async () => {
    var items = await this.fetchItems();
    this.setState({
      abstractItem: items,
      searchItems: items
    });
  };

  componentWillUnmount() {
    document.removeEventListener("keypress", this._handleScanner);
  }

  /**
   *  handler for sacnner
   */
  _handleScanner = (e: KeyboardEvent) => {
    let keycode = e.keyCode || e.which || e.charCode;
    let nextTime = new Date().getTime();
    // if scanned finish
    if (keycode === 13) {
      if (_lasttime && nextTime - _lasttime < 30) {
        this.setState({ qrCode: qrCode });
        this._handleQRSearch();
      } else {
        // keyboard
      }
      qrCode = "";
      _lasttime = undefined;
    } else {
      if (!_lasttime) {
        qrCode = String.fromCharCode(keycode).toLocaleLowerCase();
      } else {
        if (nextTime - _lasttime < 30) {
          qrCode += String.fromCharCode(keycode).toLocaleLowerCase();
        } else {
          qrCode = "";
        }
      }
      _lasttime = nextTime;
    }
  };

  /**
   * Fetch items from internet
   */
  async fetchItems(): Promise<AbstractStorageItem[]> {
    return new Promise(async (resolve, reject) => {
      try {
        this.setState({ loadingProgress: 0 });
        let url = getURL("item");
        let response = await axios.get(url, {
          onDownloadProgress: evt =>
            computeDownloadProgress(evt, (progress: number) => {
              this.setState({ loadingProgress: progress });
            })
        });
        let items: AbstractStorageItem[] = response.data;
        setTimeout(
          () => this.setState({ loadingProgress: undefined }),
          waitAndDispearTime
        );
        resolve(items);
      } catch (err) {
        alert(err);
      }
    });
  }

  /**
   * handle qrcode field for user input
   */
  _handleQRCode = (
    evt: React.ChangeEvent<
      HTMLTextAreaElement | HTMLInputElement | HTMLSelectElement
    >
  ) => {
    this.setState({ qrCode: evt.target.value });
  };

  /**
   * search by qr code
   */
  _handleQRSearch = async () => {
    try {
      let url = getURL("searchByQR?qr=" + this.state.qrCode);
      this.setState({ loadingProgress: 0 });
      let response = await axios.get(url);
      let result: AbstractStorageItem = response.data;
      if (result.id !== undefined) {
        this.setState({ selectedId: result.id });
      } else {
        showNotification("Item not found");
      }
      this.setState({ loadingProgress: 100 });
      setTimeout(
        () => this.setState({ loadingProgress: undefined }),
        waitAndDispearTime
      );
    } catch (err) {
      console.log("Error");
      this.setState({ loadingProgress: undefined });
    }
  };

  /**
   * Do the filter for the keyword
   */
  search = (
    event: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>
  ) => {
    let keyword = event.target.value;
    let results = this.state.abstractItem.filter(item => {
      return item.name.toLowerCase().includes(keyword.toLowerCase());
    });
    this.setState({ searchItems: results });
  };

  render() {
    return (
      <div className="container-fluid h-100">
        <div className="row h-100">
          <div
            className="col-5 pt-4"
            style={{ position: "sticky", overflowY: "scroll" }}
          >
            <SearchField
              search={this.search}
              listener={this._handleScanner}
              refresh={this._onmount}
            />

            <AutoSizer>
              {({ height, width }) => (
                <List
                  height={height}
                  width={width}
                  itemCount={this.state.searchItems.length}
                  itemSize={106}
                >
                  {({ index, style }) => (
                    <Collapse in={true}>
                      <ItemRow
                        style={style}
                        selected={this.state.selectedId}
                        item={this.state.searchItems[index]}
                        onSelected={id => {
                          this.setState({ selectedId: id });
                        }}
                      />
                    </Collapse>
                  )}
                </List>
              )}
            </AutoSizer>
          </div>
          <div
            className="col-7"
            style={{
              backgroundColor: "#e0e0e0",
              position: "sticky",
              overflowY: "scroll"
            }}
          >
            <ItemDetailPage itemID={this.state.selectedId} />
          </div>
        </div>
        <HomepageContext.Consumer>
          {({
            openScannerWindow,
            openQRWindow,
            qrWindowDetail,
            closeQR,
            openLocalScannerWindow,
            openLocalScanner,
            closeLocalScanner,
            openRemoteScanner,
            closeRemoteScanner
          }) => (
            <div>
              <RemoteScannerPage
                close={closeLocalScanner}
                open={openScannerWindow}
                onDone={(value: string) => {
                  console.log(value);
                  closeLocalScanner();
                }}
              />
              <QRDownload
                open={openQRWindow}
                item={qrWindowDetail}
                onClose={closeQR}
              />
              <LocalScanner
                open={openLocalScannerWindow}
                onClose={() => {
                  document.addEventListener("keypress", this._handleScanner);
                  closeLocalScanner();
                }}
                onChange={this._handleQRCode}
                onSearch={async () => {
                  document.addEventListener("keypress", this._handleScanner);
                  closeLocalScanner();
                  await this._handleQRSearch();
                }}
              />

              <LoadingProgress
                progress={this.state.loadingProgress}
                open={this.state.loadingProgress !== undefined}
              />
            </div>
          )}
        </HomepageContext.Consumer>
      </div>
    );
  }
}