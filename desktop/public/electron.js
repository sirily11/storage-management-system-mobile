"use strict";
exports.__esModule = true;
var electron_1 = require("electron");
var path = require("path");
var notifier = require("node-notifier");
var contextMenu = require("electron-context-menu");
var isDev = require("electron-is-dev");
var mainWindow;
var settingWindow;
contextMenu({
    prepend: function (actions, params, browserWindow) { return ([]); }
});
var menu = electron_1.Menu.buildFromTemplate([
    {
        label: 'Menu'
    }, {
        label: "设置",
        submenu: [
            {
                label: '打开设置页面', click: function () {
                    settingWindow.show();
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
    settingWindow = new electron_1.BrowserWindow({
        width: 400,
        height: 300,
        titleBarStyle: "hidden",
        show: false
    });
    mainWindow.loadURL(isDev
        ? "http://localhost:3000#/"
        : "file://" + path.join(__dirname, "../build/index.html"));
    settingWindow.loadURL(isDev
        ? "http://localhost:3000#/setting"
        : "file://" + path.join(__dirname, "../build/index.html#/setting"));
    mainWindow.once("ready-to-show", function () {
        if (mainWindow) {
            mainWindow.show();
        }
    });
    if (isDev) {
        // Open the DevTools.
        //BrowserWindow.addDevToolsExtension('<location to your react chrome extension>');
        mainWindow.webContents.openDevTools();
        // qrWindow.webContents.openDevTools()
    }
    mainWindow.on("closed", function () {
        mainWindow = undefined;
    });
    mainWindow.on("close", function (e) {
        mainWindow = undefined;
    });
    settingWindow.on("close", function (e) {
        e.preventDefault();
        settingWindow.hide();
    });
}
electron_1.app.on("ready", function () {
    createWindow();
    electron_1.globalShortcut.register('CommandOrControl+Q', function () {
        electron_1.app.quit();
    });
});
electron_1.app.on("window-all-closed", function () {
    electron_1.app.quit();
});
electron_1.app.on("activate", function () {
    if (mainWindow === null) {
        createWindow();
    }
});
if (settingWindow) {
}
electron_1.ipcMain.on("notification", function (event, message) {
    console.log(message);
    notifier.notify({
        title: "Notification",
        message: message
    });
});
