export function getURL(path: string): string {
    var base = "http://192.168.31.19:8080/storage_management"
    return `${base}/${path}`
}

export function getWebSocket(path: string): string {
    var base = "ws://192.168.31.19:4000"
    return `${base}/?type=receiver`
    // return "ws://0.0.0.0:8000/?type=receiver"
}