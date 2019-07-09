"use strict";
exports.__esModule = true;
var electron_1 = require("electron");
var path = require("path");
var notifier = require("node-notifier");
var isDev = require("electron-is-dev");
var mainWindow;
var editWindow;
var menu = electron_1.Menu.buildFromTemplate([
    {
        label: 'Menu'
    }, {
        label: "File",
        submenu: [
            {
                label: 'Log out', click: function () {
                    if (mainWindow) {
                        mainWindow.webContents.send('logout');
                    }
                }
            }, {
                label: "Reload", click: function () {
                    if (mainWindow) {
                        mainWindow.reload();
                    }
                }
            }, {
                label: "Debug", click: function () {
                    if (mainWindow) {
                        mainWindow.webContents.openDevTools();
                    }
                }
            }
        ]
    }
]);
electron_1.Menu.setApplicationMenu(menu);
function createWindow() {
    mainWindow = new electron_1.BrowserWindow({
        width: 1080,
        height: 900,
        titleBarStyle: "hidden",
        webPreferences: {
            nodeIntegration: true,
            webSecurity: false
        }
    });
    editWindow = new electron_1.BrowserWindow({
        width: 720,
        height: 600,
        titleBarStyle: "hidden",
        show: false,
        webPreferences: {
            nodeIntegration: true,
            webSecurity: false
        }
    });
    mainWindow.loadURL(isDev
        ? "http://localhost:3000#/"
        : "file://" + path.join(__dirname, "../build/index.html"));
    editWindow.loadURL(isDev
        ? "http://localhost:3000#/edit"
        : "file://" + path.join(__dirname, "../build/index.html#/edit"));
    mainWindow.once("ready-to-show", function () {
        if (mainWindow) {
            mainWindow.show();
        }
    });
    if (isDev) {
        // Open the DevTools.
        //BrowserWindow.addDevToolsExtension('<location to your react chrome extension>');
        mainWindow.webContents.openDevTools();
        editWindow.webContents.openDevTools();
    }
    mainWindow.on("closed", function () {
        mainWindow = undefined;
    });
    editWindow.on("close", function (e) {
        e.preventDefault();
        editWindow.hide();
    });
}
electron_1.app.on("ready", createWindow);
electron_1.app.on("window-all-closed", function () {
    if (process.platform !== "darwin") {
        electron_1.app.quit();
    }
});
electron_1.app.on("activate", function () {
    if (mainWindow === null) {
        createWindow();
    }
});
electron_1.ipcMain.on("show-edit", function (event, message) {
    if (message.isEdit) {
        // Edit 
        if (message.id) {
            editWindow.show();
            editWindow.webContents.send("edit", message);
        }
        else {
            notifier.notify("Error when showing edit page");
        }
    }
    else {
        // Create
        editWindow.show();
        editWindow.webContents.send("edit", message);
    }
});
electron_1.ipcMain.on("close-edit", function (event, message) {
    if (message.isEdit) {
        if (message.id) {
            mainWindow.webContents.send("edit", message.item);
        }
        else {
            notifier.notify("Error when showing edit page");
        }
    }
    else {
        // Create
        mainWindow.webContents.send("create", message.item);
    }
});
electron_1.ipcMain.on("notification", function (event, message) {
    console.log(message);
    notifier.notify({
        title: "Notification",
        message: message
    });
});
