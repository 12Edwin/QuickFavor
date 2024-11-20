import {jwtDecode} from "jwt-decode"
import {useEncryption} from "@/config/crypt-config";
const { encrypt, decrypt } = useEncryption()

const getRoleNameByToken = async () => {
   try {
    const tokenDecrypted = decrypt(getToken() || '');
    const decode = jwtDecode(tokenDecrypted || '');
    return (decode as any).role
   } catch (error) {
        removeToken()
   }
}

export const getNamesByToken = async () => {
    try {
        const decrypted = decrypt(getToken() || '');
        const { sub } = jwtDecode(decrypted || '')
        const { name } = await JSON.parse(sub || '')
        return name
    } catch (error) {
        removeToken()
    }
}

export const getUserIdByToken = async () => {

    try {
        const decrypted = decrypt(getToken() || '');
        const { sub } = jwtDecode(decrypted || '')
        const { id } = await JSON.parse(sub || '')
        return
    } catch (error) {
        removeToken()
    }
    
}

const getToken = () => {
    return localStorage.getItem("token")
}

const removeToken = () => {
    localStorage.removeItem("token")
}

const getUserInfoByToken = async () => {
    try {
        return jwtDecode(decrypt(getToken() || '') || '')
    } catch (error) {
        removeToken()
    }
}


const limitDescription = (description: string) => {
    const words = description.split(' ');
    if (words.length === 10 && words.length < 10) {
        return description;
    } else {
        const limitedWords = words.slice(0, 10);
        return limitedWords.join(' ') + '...';
    }
}

const getErrorMessages = (errorCode: string): string => {
    const errorMessages: { [key: string]: string } = {
        'bad Request': 'Solicitud incorrecta',
        'email already exists': 'El correo electrónico ya existe',
        'curp already exists': 'La CURP ya existe',
        'phone already exists': 'El teléfono ya existe',
        'invalid credentials': 'Credenciales inválidas',
        'invalid fields': 'Campos inválidos',
        'email not verified': 'Correo electrónico no verificado',
        'user disabled': 'Usuario deshabilitado',
        'invalid email': 'Correo electrónico inválido',
        'user not found': 'Usuario no encontrado',
        'customer not found': 'Cliente no encontrado',
        'courier not found': 'Mensajero no encontrado',
        'favor not found': 'Favor no encontrado',
        'courier not available': 'Mensajero no disponible',
        'courier not near location': 'Mensajero no cerca de la ubicación',
        'time to accept is over': 'El tiempo para aceptar ha terminado',
        'weak password': 'Contraseña débil',
        'time to finish is over': 'El tiempo para finalizar ha terminado',
        'forbidden': 'Prohibido',
        'Error network': 'No se ha podido establecer conexión con el servidor',
        'too many requests': 'Demasiadas solicitudes',
        'client not connected': 'Cliente no conectado',
        'default': 'Error interno del servidor',
    };
    return errorMessages[errorCode.toLowerCase()] || 'Ocurrió un error desconocido';
};

const getIconByStatus = (status: string) => {
    let icon = "";
    switch (status) {
      case "Pendiente":
        icon = "pi pi-clock";
        break;
      case "Completada":
        icon = "pi pi-check";
        break;
      case "Cancelada":
        icon = "pi pi-calendar-minus";
        break;
      default:
        icon = "pi pi-question";
        break;
    }
    return icon;
}

const getColorByStatus = (status: string) => {
    let color = "";
    switch (status) {
      case "Pendiente":
        color = "orange";
        break;
      case "Completada":
        color = "#368368";
        break;
      case "Cancelada":
        color = "gray";
        break;
      case "Reprogramada":
        color = "#2196F3";
        break;
      default:
        color = "red";
        break;
    }
    return color;
}

const filterByName = (array: any[], name: any) => {
    return array.filter((item: any) => item.name.toLowerCase().includes(name.toLowerCase()));
}

const getStatusCourier = async () => {
    try {
        return localStorage.getItem("statusCourier");
    } catch (error) {
        return false;
    }
}

const setStatusCourier = async (status: any) => {
    try {
        localStorage.setItem("statusCourier", status);
    } catch (error) {
        return false;
    }
}


export {
    getRoleNameByToken,
    getToken,
    removeToken,
    getStatusCourier,
    setStatusCourier,
    getUserInfoByToken,
    limitDescription,
    getErrorMessages,
    getIconByStatus,
    filterByName,
    getColorByStatus,
}