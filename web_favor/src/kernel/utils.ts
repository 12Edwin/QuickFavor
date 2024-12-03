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

export const getNo_order = async (): Promise<string | null> => {
    try {
        return await localStorage.getItem("no_order")
    } catch (error) {
        removeToken()
        return null
    }
}

const getNo_courierByToken = async (): Promise<string | null> => {
    try {
        return await localStorage.getItem("no_user")
    } catch (error) {
        removeToken()
        return null
    }
}

export const removeNo_order = async () => {
    try {
        localStorage.removeItem("no_order")
    } catch (error) {
        removeToken()
    }
}

export const setNo_order = async (no_order: string) => {
    try {
        localStorage.setItem("no_order", no_order)
    } catch (error) {
        removeToken()
    }
}

export const getCurrentLocation = async (): Promise<{ lat: number, lng: number } | null> => {
    return new Promise((resolve, reject) => {
        if (!navigator.geolocation) {
            reject(new Error('Geolocation is not supported by your browser'));
        } else {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    resolve({
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    });
                },
                (error) => {
                    reject(error);
                }
            );
        }
    });
}

export const getNamesByToken = async () => {
    try {
        const tokenDecrypted = decrypt(getToken() || '');
        const decode = jwtDecode(tokenDecrypted || '');
        return (decode as any).name
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
    localStorage.removeItem('no_user')
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
        'network error': 'Error de red',
        'default': 'Error interno del servidor',
        "lastname must be at least 3 characters": "El apellido debe tener al menos 3 caracteres",
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

function convertirImagenABase64(archivo: File): Promise<string> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
  
      reader.onloadend = () => {
        if (reader.result) {
          resolve(reader.result as string); // Resultado en base64
        }
      };
  
      reader.onerror = (error) => {
        reject("Error al leer el archivo: " + error);
      };
  
      reader.readAsDataURL(archivo); // Lee el archivo y lo convierte a base64
    });
  }  


export {
    getRoleNameByToken,
    getNo_courierByToken,
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
    convertirImagenABase64
}