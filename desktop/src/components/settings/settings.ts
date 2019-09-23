export function getURL(path: string): string {
    var base = "http://0.0.0.0/storage_management"
    let store = localStorage.getItem("address")
    if (store) {
        base = store
    }
    return `${base}/${path}`
}

export function getWebSocket(path: string): string {
    var base = "ws://192.168.31.19:4000"
    return `${base}/?type=receiver`
    // return "ws://0.0.0.0:8000/?type=receiver"
}