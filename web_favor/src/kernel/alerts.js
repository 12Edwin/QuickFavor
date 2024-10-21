import SweetAlert from "sweetalert2";

export const onError = async (title, text) => {
    await SweetAlert.fire({
        icon: 'error',
        title: title,
        text: text
    })
}

export const onWarning = async (title, text) => {
    await SweetAlert.fire({
        icon: 'warning',
        title: title,
        text: text
    })
}

export const onQuestion = async (title, text) => {
    return await SweetAlert.fire({
        icon: 'question',
        title: title,
        text: text,
        showCancelButton: true,
        confirmButtonColor: '#2a715a',
        cancelButtonColor: '#607D8B',
        confirmButtonText: 'Aceptar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        return result.isConfirmed
    })
}

export const onSuccess = async (title, text) => {
    await SweetAlert.fire({
        icon: 'success',
        title: title,
        text: text
    })
}