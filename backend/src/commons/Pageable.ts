interface PaginationOptions {
    limit: number;
    offset: number;
}

interface PaginationResult<T> {
    content: T[];
    total: number;
    page: number;
    limit: number;
    totalPages: number;
}

export {PaginationOptions, PaginationResult};

export class Pageable<T> {
    private readonly _limit: number;
    private readonly _page: number;
    private _offset: number = 0;
    private _content: T[] = [];
    private _total: number = 0;
    private _totalPages: number = 0;
    constructor(limit: number, page: number) {
        this._limit = limit;
        this._page = page;
        this.setPagination()
    }

    getLimit(): number {
        return this._limit;
    }
    getPage(): number {
        return this._page;
    }

    setPagination (noPage: number = 1, limit: number = 10) {
        this._offset = (noPage - 1) * limit;
    }

    getPagination (): PaginationOptions {
        return {limit: this._limit, offset: this._offset};
    }

    setContent(value: T[], total: number): PaginationResult<T> {
        this._content = value;
        this._total = total;
        this._totalPages = this._limit !== 0 ? Math.ceil(total / this._limit) : 1;
        return {
            content: this._content,
            total: this._total,
            page: this._page,
            limit: this._limit,
            totalPages: this._totalPages
        };
    }
}