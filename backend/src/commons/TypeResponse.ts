export interface ResponseApi<T> {
    code: number;
    error: boolean;
    message: string;
    data: T;

}
export function Response200<T>(data: T, message= "Success"): ResponseApi<T> {
    return {
        code: 200,
        error: false,
        message: message,
        data: data
    };
}

export function Response400<T>(data: T, message= 'Bad request'): ResponseApi<T> {
    return {
        code: 400,
        error: true,
        message: message,
        data: data
    };
}

export function Response401<T>(data: T, message= "Unauthorized"): ResponseApi<T> {
    return {
        code: 401,
        error: true,
        message: message,
        data: data
    };
}

export function Response403<T>(data: T, message= "Forbidden"): ResponseApi<T> {
    return {
        code: 403,
        error: true,
        message: message,
        data: data
    };
}

export function Response404<T>(data: T, message= "Not found"): ResponseApi<T> {
    return {
        code: 404,
        error: true,
        message: message,
        data: data
    };
}

export function Response500<T>(data: T, message= "'Internal server error'"): ResponseApi<T> {
    return {
        code: 500,
        error: true,
        message: message,
        data: data
    };
}