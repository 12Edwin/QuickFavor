import { decrypt } from "@/config/security"
import jwtDecode from "jwt-decode"

const getRoleNameBytoken = async () => {
   try {
    const tokenDecrypted = await decrypt(getToken());
    const { role : {name}} = jwtDecode(tokenDecrypted)
    return name
   } catch (error) {
        removeToken()
   }
}

export const getNamesByToken = async () => {
    try {
        const decrypted = await decrypt(getToken());
        const { name } = jwtDecode(decrypted)
        return name
    } catch (error) {
        removeToken()
    }
}

export const getUserIdByToken = async () => {

    try {
        const decrypted = await decrypt(getToken());
        const { user_id } = jwtDecode(decrypted)
        return user_id
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
async function encodeBase64(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => {
            resolve(reader.result);
        };
        reader.onerror = (error) => reject("");
    });
}

const getUserInfoByToken = async () => {
    try {
        return jwtDecode(await decrypt(getToken()))
    } catch (error) {
        removeToken()
    }
}


const limitDescription = (description) => {
    const words = description.split(' ');
    if (words.length === 10 && words.length < 10) {
        return description;
    } else {
        const limitedWords = words.slice(0, 10);
        return limitedWords.join(' ') + '...';
    }
}

const getErrorMessages = (errorCode) => {
    const errorMessages = {
        'User not found': 'Usuario no encontrado',
        'Not found': 'Cita no encontrada',
        'Treatment not found': 'Tratamiento no encontrado',
        'Expedient not found': 'Expediente no encontrado',
        'Unauthorized user': 'Usuario no autorizado',
        "Maximum 5 hours": 'La cita no puede durar más de 5 horas',
        "Minimum 1 hour": 'La cita debe durar al menos 1 hora',
        "Invalid schedule": 'Horario no válido',
        "The space is busy in this schedule": 'El espacio está ocupado en este horario',
        "Cannot be more than one month from now": 'La cita no puede programarse después de un mes',
        "The appointment has not yet started" : 'Aún no ha comenzado la cita',
        "Cannot update a canceled or completed appointment": 'No se puede actualizar una cita cancelada o completada',
        "Speciality is used" : "La especialidad está en uso",
        "Speciality not deleted" : "La especialidad no se pudo eliminar",
        "Duplicated speciality" : "Esta especialidad ya existe",
        "Speciality not updated" : "La especialidad no se pudo actualizar",
        "Duplicated service" : "Este servicio ya existe",
        "Speciality not found" : "Especialidad no encontrada",
        "Service is used" : "El servicio está en uso",
        "Space already exists" : "El espacio ya existe",
        "Unregistered space" : "Espacio no registrado",
        "Type pathology already exists" : "Tipo de patología ya existe",
        "Nombre inválido" : "Nombre inválido",
        "Apellido inválido" : "Apellido inválido",
        "Sexo inválido" : "Sexo inválido",
        "code already exists": "El código ya existe",
        "Space is used": "El espacio está en uso",
        "Type pathology is used" : "Patología está en uso",
    };
    return errorMessages[errorCode] || 'Ocurrió un error desconocido en el servidor';
}


const getSuccesMessage = (successCode) => {
    const successCodes = {
        'Appoint rescheduled': 'Cita reprogramada',
        'Appoint canceled': 'Cita cancelada',
        'Appoint registered': 'Cita registrada',
    }
    return successCodes[successCode] || 'Operación exitosa';
}

const getIconByStatus = (status) => {
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

const getColorByStatus = (status) => {
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

const filterByName = (array, name) => {
    return array.filter((item) => item.name.toLowerCase().includes(name.toLowerCase()));
}
export default { 
    getRoleNameBytoken,
    getToken,
    removeToken,
    encodeBase64,
    getUserInfoByToken,
    limitDescription,
    getErrorMessages,
    getSuccesMessage,
    getIconByStatus,
    filterByName,
    getColorByStatus,
}