import React, { Component } from "react";
import "./App.css";
import "bootstrap/dist/css/bootstrap.css";
import { HashRouter as Router, Route, Link } from "react-router-dom";
import {
  spring,
  AnimatedRoute,
  AnimatedSwitch
} from "./components/plugins/react-router-transition";
import RemoteScannerPage from "./components/remoteScanner/RemoteScannerPage";
import QRDownload from "./components/QRDownload/QRDownload";

class App extends Component {
  render() {
    return (
      <Router>
                  <AnimatedSwitch
                    atEnter={{ opacity: 0 }}
                    atLeave={{ opacity: 0 }}
                    atActive={{ opacity: 1 }}
                    className="switch-wrapper"
                  >
                    <Route exact path="/" component={(props: any)=><QRDownload {...props} value="Hello"></QRDownload>} />
                  
                   
                  </AnimatedSwitch>
          
      </Router>
    );
  }
}

export default App;
