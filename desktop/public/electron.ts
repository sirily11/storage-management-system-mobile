import { app, BrowserWindow, ipcMain, Menu, remote, Notification } from "electron";
import * as path from "path";
import * as fs from 'fs';
import * as notifier from "node-notifier"

const isDev = require("electron-is-dev");

let mainWindow: Electron.BrowserWindow | undefined;
let editWindow: Electron.BrowserWindow | undefined;

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

  editWindow = new BrowserWindow({
    width: 720,
    height: 600,
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

  editWindow.loadURL(
    isDev
      ? "http://localhost:3000#/edit"
      : `file://${path.join(__dirname, "../build/index.html#/edit")}`
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
    editWindow.webContents.openDevTools()
  }
  mainWindow.on("closed", () => {
    mainWindow = undefined;
  })

  editWindow.on("close", e => {
    e.preventDefault()
    editWindow.hide()
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


interface EditMessage {
  isEdit: boolean;
  id?: number;
  item?: any
}

ipcMain.on("show-edit", (event: any, message: EditMessage) => {
  if (message.isEdit) {
    // Edit 
    if (message.id) {
      editWindow.show()
      editWindow.webContents.send("edit", message)
    } else {
      notifier.notify("Error when showing edit page")
    }
  } else {
    // Create
    editWindow.show()
    editWindow.webContents.send("edit", message)
  }
})

ipcMain.on("close-edit", (event: any, message: EditMessage) => {
  if (message.isEdit) {
    if (message.id) {
      mainWindow.webContents.send("edit", message.item)
    } else {
      notifier.notify("Error when showing edit page")
    }
  } else {
    // Create
    mainWindow.webContents.send("create", message.item)
  }
})

ipcMain.on("notification", (event: any, message: string) => {
  console.log(message)
  notifier.notify({
    title: "Notification",
    message: message
  })
})

