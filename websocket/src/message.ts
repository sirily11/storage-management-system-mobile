interface Message {
    type: "connect" | "message" | "disconnect"
    from: "scanner" | "receiver"
    body?: string
}