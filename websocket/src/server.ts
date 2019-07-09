import * as express from "express";
import * as http from "http";
import * as WebSocket from "ws";
import * as url from "url";

const app = express();
app.use(express.json());
//initialize a simple http server
const server = http.createServer(app);
//initialize the WebSocket server instance
const wss = new WebSocket.Server({ server: server, path: "" });
const scanner: WebSocket[] = [];
const recievers: WebSocket[] = [];

wss.on("connection", async (ws: WebSocket, req: any) => {
  let type = "";
  if (req.url) {
    try {
      type = url.parse(req.url, true).query.type.toString();
      let scannerMsg: Message = {
        type: "connect",
        from: "scanner"
      };

      let receiverMsg: Message = {
        type: "connect",
        from: "receiver"
      };

      if (type === "scanner") {
        console.log("Scanner online");
        if (recievers.length > 0) {
          ws.send(JSON.stringify(receiverMsg))
        }
        scanner.push(ws);
        recievers.forEach(reciever => {
          reciever.send(JSON.stringify(scannerMsg));
        });
      } else if (type === "receiver") {
        console.log("Receiver online")
        if (scanner.length > 0) {
          ws.send(JSON.stringify(scannerMsg))
        }
        recievers.push(ws);

        scanner.forEach(s => {
          s.send(JSON.stringify(receiverMsg));
        });
      }
    } catch (err) {
      console.error(err);
    }
  }

  ws.on("close", () => {
    console.log("Connection closed", type);
    if (type === "scanner") {
      let index = scanner.indexOf(ws);
      let message: Message = {
        type: "disconnect",
        from: "scanner"
      };
      scanner.splice(index, 1);
      recievers.forEach(reciever => {
        reciever.send(JSON.stringify(message));
      });
    } else if (type === "receiver") {
      let index = recievers.indexOf(ws);
      let message: Message = {
        type: "disconnect",
        from: "receiver"
      };
      recievers.splice(index, 1);
      scanner.forEach(s => {
        s.send(JSON.stringify(message));
      });
    }
  });

  ws.on("message", (msg: string) => {
    let messgae: Message = JSON.parse(msg);
    if (messgae.from === "scanner" && messgae.type === "message") {
      recievers.forEach(r => {
        r.send(msg);
      });
    }

  });
});

//start our server
server.listen(8000, () => {
  console.log(`server start`);
});
