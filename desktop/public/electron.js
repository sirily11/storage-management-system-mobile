"use strict";
exports.__esModule = true;
var electron_1 = require("electron");
var path = require("path");
var notifier = require("node-notifier");
var contextMenu = require("electron-context-menu");
var isDev = require("electron-is-dev");
var mainWindow;
var qrWindow;
contextMenu({
    prepend: function (actions, params, browserWindow) { return ([]); }
});
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
    qrWindow = new electron_1.BrowserWindow({
        width: 300,
        height: 300,
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
    qrWindow.loadURL(isDev
        ? "http://localhost:3000#/qr"
        : "file://" + path.join(__dirname, "../build/index.html#/qr"));
    mainWindow.once("ready-to-show", function () {
        if (mainWindow) {
            mainWindow.show();
            // qrWindow.show()
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
    qrWindow.on("close", function (e) {
        e.preventDefault();
        qrWindow.hide();
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
electron_1.ipcMain.on("print", function (e, qrCode) {
    // console.log({ code: qrCode })
    // qrWindow.show()
    qrWindow.webContents.send("qrCode", { code: qrCode });
    setTimeout(function () {
        qrWindow.webContents.print({ silent: false });
    });
});
electron_1.ipcMain.on("notification", function (event, message) {
    console.log(message);
    notifier.notify({
        title: "Notification",
        message: message
    });
});
