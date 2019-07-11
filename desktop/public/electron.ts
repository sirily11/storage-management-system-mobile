import { app, BrowserWindow, ipcMain, Menu, remote, Notification, dialog } from "electron";
import * as path from "path";
import * as fs from 'fs';
import * as notifier from "node-notifier"
import * as  contextMenu from "electron-context-menu"

const isDev = require("electron-is-dev");

let mainWindow: Electron.BrowserWindow | undefined;
let qrWindow: Electron.BrowserWindow | undefined;

contextMenu({
  prepend: (actions, params, browserWindow) => (
    [

    ]
  )
})

var menu = Menu.buildFromTemplate([
  {
    label: 'Menu',
  }, {
    label: "File",
    submenu: [
      {
        label: 'Log out', click: () => {
          if (mainWindow) {
            mainWindow.webContents.send('logout')
          }
        }
      }, {
        label: "Reload", click: () => {
          if (mainWindow) {
            mainWindow.reload()
          }
        },
      }, {
        label: "Debug", click: () => {
          if (mainWindow) {
            mainWindow.webContents.openDevTools()
          }
        },
      }
    ]
  }
])
Menu.setApplicationMenu(menu);

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1080,
    height: 900,
    titleBarStyle: "hidden",
    webPreferences: {
      nodeIntegration: true,
      webSecurity: false,
    },
  });

  qrWindow = new BrowserWindow({
    width: 300,
    height: 300,
    titleBarStyle: "hidden",
    show: false,
    webPreferences: {
      nodeIntegration: true,
      webSecurity: false,
    },
  });

  mainWindow.loadURL(
    isDev
      ? "http://localhost:3000#/"
      : `file://${path.join(__dirname, "../build/index.html")}`
  );

  qrWindow.loadURL(
    isDev
      ? "http://localhost:3000#/qr"
      : `file://${path.join(__dirname, "../build/index.html#/qr")}`
  );

  mainWindow.once("ready-to-show", () => {
    if (mainWindow) {
      mainWindow.show()
      // qrWindow.show()
    }
  })

  if (isDev) {
    // Open the DevTools.
    //BrowserWindow.addDevToolsExtension('<location to your react chrome extension>');
    mainWindow.webContents.openDevTools();
    // qrWindow.webContents.openDevTools()
  }
  mainWindow.on("closed", () => {
    mainWindow = undefined;
  })

  qrWindow.on("close", e => {
    e.preventDefault()
    qrWindow.hide()
  })
}

app.on("ready", createWindow);

app.on("window-all-closed", () => {
  if (process.platform !== "darwin") {
    app.quit();
  }
});

app.on("activate", () => {
  if (mainWindow === null) {
    createWindow();
  }
});

ipcMain.on("print", (e: any, qrCode: string) => {
  // console.log({ code: qrCode })
  // qrWindow.show()
  qrWindow.webContents.send("qrCode", { code: qrCode })
  setTimeout(() => {
    qrWindow.webContents.print({ silent: false })
  })

})

ipcMain.on("notification", (event: any, message: string) => {
  console.log(message)
  notifier.notify({
    title: "Notification",
    message: message
  })
})
