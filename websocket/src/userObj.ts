export interface User{
    _id?: string
    userName?: string
    password?: string
    dateOfBirth?: string
    sex?: string
    friends? : [User]
}