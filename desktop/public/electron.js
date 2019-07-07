"use strict";
exports.__esModule = true;
var electron_1 = require("electron");
var path = require("path");
var fs = require("fs");
var isDev = require("electron-is-dev");
var mainWindow;
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
    console.log("Starting the webserver");
    mainWindow.loadURL(isDev
        ? "http://localhost:3000#/"
        : "file://" + path.join(__dirname, "../build/index.html"));
    mainWindow.once("ready-to-show", function () {
        if (mainWindow) {
            mainWindow.show();
        }
    });
    if (isDev) {
        // Open the DevTools.
        //BrowserWindow.addDevToolsExtension('<location to your react chrome extension>');
        mainWindow.webContents.openDevTools();
    }
    mainWindow.on("closed", function () {
        mainWindow = undefined;
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
electron_1.ipcMain.on("get-image", function (imagePath) {
    var data = fs.readFileSync(imagePath, { encoding: "base64" });
    console.log("Got the image", imagePath);
    if (mainWindow) {
        mainWindow.webContents.send("preview-image", data);
    }
});
electron_1.ipcMain.on("hello", function () {
    if (mainWindow) {
        mainWindow.webContents.send("helloback", "hello");
    }
});
