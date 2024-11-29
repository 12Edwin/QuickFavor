interface ErrorData {
    type: string;
    msg: string;
    path: string;
    location: string;
}

export interface ResponseEntity {
    code: number;
    error: boolean;
    message: string;
    data: any;
}

export function getErrorMessages(response: ResponseEntity): ResponseEntity {
    const errors = response.data.map((error: ErrorData) => error.msg);
    return {
        code: response.code,
        error: true,
        message: errors[0],
        data: null
    }
}