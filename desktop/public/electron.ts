import { app, BrowserWindow, ipcMain, Menu, remote, Notification, dialog, globalShortcut } from "electron";
import * as path from "path";
import * as fs from 'fs';
import * as notifier from "node-notifier"
import * as  contextMenu from "electron-context-menu"

const isDev = require("electron-is-dev");

let mainWindow: Electron.BrowserWindow | undefined;
let settingWindow: Electron.BrowserWindow | undefined;


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
    label: "设置",
    submenu: [
      {
        label: '打开设置页面', click: () => {
          settingWindow.show()
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

  settingWindow = new BrowserWindow({
    width: 400,
    height: 300,
    titleBarStyle: "hidden",
    show: false
  });

  mainWindow.loadURL(
    isDev
      ? "http://localhost:3000#/"
      : `file://${path.join(__dirname, "../build/index.html")}`
  );
  settingWindow.loadURL(
    isDev
      ? "http://localhost:3000#/setting"
      : `file://${path.join(__dirname, "../build/index.html#/setting")}`
  );
  mainWindow.once("ready-to-show", () => {
    if (mainWindow) {
      mainWindow.show()
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

  mainWindow.on("close", e => {
    mainWindow = undefined
  })

  settingWindow.on("close", (e) => {
    e.preventDefault()
    settingWindow.hide()
  })
}

app.on("ready", () => {
  createWindow()
  globalShortcut.register('CommandOrControl+Q', () => {
    app.quit()
  })
});

app.on("window-all-closed", () => {
  app.quit()

});

app.on("activate", () => {
  if (mainWindow === null) {
    createWindow();
  }
});

if (settingWindow) {

}


ipcMain.on("notification", (event: any, message: string) => {
  console.log(message)
  notifier.notify({
    title: "Notification",
    message: message
  })
})
