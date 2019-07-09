export interface AbstractStorageItem {
    id: number;
    uuid: string;
    name: string;
    description: string;
    author: number;
    author_name: string;
    category_name: string;
    column: number;
    row: number;
    position: string;
}

export abstract class Uploadable {
    
}

interface Base {
    id: number;
    name: string;
}

export interface Author extends Base {
    description?: string;
}

export interface Series extends Base {
    description?: string;
}

export interface Category extends Base {

}

export interface Location {
    id: number;
    country?: string;
    city?: string;
    street?: string;
    building?: string;
    unit?: string;
    room_number?: string;
}

export interface Position {
    id: number;
    position: string;
    description: string;
}

export interface DetailStorageItem extends Base {
    author_name: Author;
    series_name: Series;
    category_name: Category;
    price: number;
    qr_code: string;
    location_name: Location;
    position_name: Position;
    images: string[];
    files: string[];
    row: number;
    column: number;
    uuid: string;
    description: string;
}

export interface Settings {
    categories: Category[],
    series: Series[],
    authors: Author[],
    locations: Location[],
    positions: Position[]
}