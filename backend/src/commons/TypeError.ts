import {Response400, Response401, Response403, Response500, ResponseApi} from "./TypeResponse";

const errors: { [x: string]: ResponseApi<any> } = {
    'bad Request': Response400(null, 'Bad Request'),
    'email already exists': Response400(null, 'Email already exists'),
    'curp already exists': Response400(null, 'CURP already exists'),
    'phone already exists': Response400(null, 'Phone already exists'),
    'invalid credentials': Response400(null, 'Invalid credentials'),
    'invalid fields': Response400(null, 'Invalid fields'),
    'email not verified': Response401(null, 'Email not verified'),
    'user disabled': Response400(null, 'User disabled'),
    'invalid email': Response400(null, 'Invalid email'),
    'user not found': Response400(null, 'User not found'),
    'customer not found': Response400(null, 'Customer not found'),
    'courier not found': Response400(null, 'Courier not found'),
    'favor not found': Response400(null, 'Favor not found'),
    'courier not available': Response400(null, 'Courier not available'),
    'courier not near location': Response400(null, 'Courier not near location'),
    'time to accept is over': Response400(null, 'Time to accept is over'),
    'weak password': Response400(null, 'Weak password'),
    'time to finish is over': Response400(null, 'Time to finish is over'),
    'forbidden': Response403(null, 'Forbidden'),
    'too many requests': Response400(null, 'Too many requests'),
    'client not connected': Response400(null, 'client not connected'),
    'default': Response500(null, 'Internal server error'),
}

const validateError = (error: Error): ResponseApi<any> => {
    const message = error.message.toLowerCase();
    return errors[message] || errors['default'];
}

export {validateError}