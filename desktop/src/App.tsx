import React, { Component } from "react";
import "./App.css";
import "bootstrap/dist/css/bootstrap.css";
import { HashRouter as Router, Route, Link } from "react-router-dom";
import { AnimatedSwitch } from "./components/plugins/react-router-transition";
import RemoteScannerPage from "./components/remoteScanner/RemoteScannerPage";
import QRDownload from "./components/QRDownload/QRDownload";
import Homepage from "./components/home/Homepage";
import HomepageProvider from "./components/Datamodel/HomepageContext";
import SettingPage from "./components/settings/SettingPage";
import ItemEditPage from "./components/edit/ItemEditPage";

class App extends Component {
  onDone = (qrcode: string) => {
    console.log(qrcode);
  };

  render() {
    return (
      <HomepageProvider>
        <Router>
          <AnimatedSwitch
            atEnter={{ opacity: 0 }}
            atLeave={{ opacity: 0 }}
            atActive={{ opacity: 1 }}
            className="switch-wrapper"
          >
            <Route exact path="/" component={(props: any) => <Homepage />} />
            <Route exact path="/edit/:id?" component={ItemEditPage} />
            <Route exact path="/setting" component={SettingPage} />
          </AnimatedSwitch>
        </Router>
      </HomepageProvider>
    );
  }
}

export default App;
