import React, { Component } from "react";
import { AbstractStorageItem } from "../home/storageItem";

interface State {
  openQRWindow: boolean;
  openScannerWindow: boolean;
  openLocalScannerWindow: boolean;
  qrWindowDetail?: AbstractStorageItem;
  openQR(): void;
  closeQR(): void;
  openRemoteScanner(): void;
  closeRemoteScanner(): void;
  openLocalScanner(): void;
  closeLocalScanner(): void;
  setPrintQRItem(item: AbstractStorageItem): void;
}

interface Props {}

export default class HomepageProvider extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      openQRWindow: false,
      openScannerWindow: false,
      openLocalScannerWindow: false,
      openQR: this.openQR,
      closeQR: this.closeQR,
      openRemoteScanner: this.openRemoteScanner,
      closeRemoteScanner: this.closeRemoteScanner,
      openLocalScanner: this.openLocalScanner,
      closeLocalScanner: this.closeLocalScanner,
      setPrintQRItem: this.setPrintQRItem
    };
  }

  openQR = () => {
    this.setState({ openQRWindow: true });
  };

  closeQR = () => {
    this.setState({ openQRWindow: false });
  };

  openRemoteScanner = () => {
    this.setState({ openScannerWindow: true });
  };

  closeRemoteScanner = () => {
    this.setState({ openScannerWindow: false });
  };

  openLocalScanner = () => {
    this.setState({ openLocalScannerWindow: true });
  };

  closeLocalScanner = () => {
    this.setState({ openLocalScannerWindow: false });
  };

  setPrintQRItem = (item: AbstractStorageItem) => {
    this.setState({ qrWindowDetail: item });
  };

  render() {
    return (
      <HomepageContext.Provider value={this.state}>
        {this.props.children}
      </HomepageContext.Provider>
    );
  }
}

const context: State = {
  openQR: () => {},
  closeQR: () => {},
  openRemoteScanner: () => {},
  closeRemoteScanner: () => {},
  openLocalScanner: () => {},
  closeLocalScanner: () => {},
  setPrintQRItem: () => {},
  openQRWindow: false,
  openScannerWindow: false,
  openLocalScannerWindow: false
};

export const HomepageContext = React.createContext(context);
