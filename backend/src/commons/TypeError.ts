import {Response400, Response401, Response403, Response500, ResponseApi} from "./TypeResponse";

const errors: { [x: string]: ResponseApi<any> } = {
    'bad Request': Response400(null, 'Bad Request'),
    'email already exists': Response400(null, 'Email already exists'),
    'invalid credentials': Response400(null, 'Invalid credentials'),
    'email not verified': Response401(null, 'Email not verified'),
    'user disabled': Response400(null, 'User disabled'),
    'invalid email': Response400(null, 'Invalid email'),
    'user not found': Response400(null, 'User not found'),
    'weak password': Response400(null, 'Weak password'),
    'forbidden': Response403(null, 'Forbidden'),
    'too many requests': Response400(null, 'Too many requests'),
    'default': Response500(null, 'Internal server error'),
}

const validateError = (error: Error): ResponseApi<any> => {
    const message = error.message.toLowerCase();
    return errors[message] || errors['default'];
}

export {validateError}