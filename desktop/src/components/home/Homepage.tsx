import React, { Component, useContext } from "react";
import {
  AbstractStorageItem,
  Category,
  DetailStorageItem
} from "./storageItem";
import axios from "axios";
import { getURL } from "../settings/settings";
import {
  computeDownloadProgress,
  showNotification,
  fetchCategories
} from "../settings/utils";
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
import FilterField from "./components/FilterField";
import CheckoutPage from "../checkout/CheckoutPage";

let qrCode = "";
let _lasttime: number | undefined;
const waitAndDispearTime = 400;

interface Props {}

interface State {
  abstractItem: AbstractStorageItem[];
  searchItems: AbstractStorageItem[];
  fetchItem?: DetailStorageItem;
  selectedId: number;
  searchKeyword?: string;
  loadingProgress?: number;
  // qrcode for search
  qrCode: string;
  _lasttime?: number;
  categories: Category[];
  selectedCategory: string;
}

export default class Homepage extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      abstractItem: [],
      categories: [],
      selectedCategory: "",
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

  /**
   * This function will be called when component is mounted
   * 0r doing some refresh
   */
  _onmount = async () => {
    let categories = await fetchCategories();
    var items = await this.fetchItems();
    this.setState({
      abstractItem: items,
      searchItems: items,
      categories: categories
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

        resolve(items);
      } catch (err) {
        alert(err);
      } finally {
        setTimeout(
          () => this.setState({ loadingProgress: undefined }),
          waitAndDispearTime
        );
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
   * Handle deletion
   */
  _handleDeleted = (id: number) => {
    let { abstractItem } = this.state;
    let index = abstractItem.findIndex(v => v.id === id);
    abstractItem.splice(index, 1);
    this.setState({ abstractItem: abstractItem, searchItems: abstractItem });
  };

  /**
   * search by qr code
   */
  _handleQRSearch = async (qrCode?: string) => {
    let qr = qrCode ? qrCode : this.state.qrCode;
    try {
      let url = getURL("searchByQR?qr=" + qr);
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
   * Detail item
   */
  _handleOnFetchItem = (item: DetailStorageItem) => {
    this.setState({ fetchItem: item });
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
      <div className="container-fluid h-100" style={{ overflowY: "hidden" }}>
        <div className="row h-100">
          <CheckoutPage item={this.state.fetchItem} />
          <div
            className="col-6 col-lg-4 mt-4 mb-4"
            style={{ overflowY: "hidden" }}
          >
            <SearchField
              search={this.search}
              listener={this._handleScanner}
              refresh={this._onmount}
            />
            <FilterField
              categories={this.state.categories}
              value={this.state.selectedCategory}
              onchange={c => {
                let searchItem = this.state.abstractItem.filter(
                  v => v.category_name === c
                );
                console.log(c);
                this.setState({ selectedCategory: c, searchItems: searchItem });
              }}
            />
            <AutoSizer className="h-80">
              {({ height, width }) => (
                <List
                  height={height - 149}
                  width={width - 20}
                  itemCount={this.state.searchItems.length}
                  itemSize={106}
                >
                  {({ index, style }) => (
                    <Collapse in={true}>
                      <ItemRow
                        style={style}
                        selected={this.state.selectedId}
                        onDeleted={this._handleDeleted}
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
            className="col-6 col-lg-8"
            style={{
              position: "sticky",
              overflowY: "scroll"
            }}
          >
            <ItemDetailPage
              itemID={this.state.selectedId}
              onFetchItem={this._handleOnFetchItem}
            />
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
                close={closeRemoteScanner}
                open={openScannerWindow}
                onDone={async (value: string) => {
                  // console.log(value);
                  closeRemoteScanner();
                  await this._handleQRSearch(value);
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
