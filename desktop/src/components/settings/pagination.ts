export default class Pagination<T> {

    items: T[]
    itemPerPage: number;
    currentPage: number;
    totalPage: number;

    constructor(items: T[], itemPerPage: number) {
        this.items = items
        this.itemPerPage = itemPerPage
        this.currentPage = 0
        this.totalPage = Math.ceil(items.length / itemPerPage)
    }

    getTotalNumOfPage(): number {
        return this.totalPage
    }

    getCurrentPageNum(): number {
        return this.currentPage
    }

    getCurrentPage(currentPage?: number): T[] {
        if (currentPage) {
            let item = this.items.slice(currentPage, currentPage + this.itemPerPage)
            this.currentPage = currentPage
            return item
        }
        let item = this.items.slice(this.currentPage, this.currentPage + this.itemPerPage)
        return item
    }

    next(): number {
        this.currentPage = Math.min(this.currentPage + 1, this.totalPage - 1)
        return this.currentPage
    }

    prev(): number {
        this.currentPage = Math.max(this.currentPage - 1, 0)
        return this.currentPage
    }

}