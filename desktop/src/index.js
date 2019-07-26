import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import * as serviceWorker from "./serviceWorker";
import { I18nProvider } from "@lingui/react";

// import chinese from "./locales/zh/messages";

// const catalogs = { zh: chinese };

ReactDOM.render(
  <I18nProvider>
    <App />
  </I18nProvider>,
  document.getElementById("root")
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
