String getErrorMessages(String errorCode) {
  final Map<String, String> errorMessages = {
    'bad request': 'Solicitud incorrecta',
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
    'error network': 'No se ha podido establecer conexión con el servidor',
    'too many requests': 'Demasiadas solicitudes',
    'client not connected': 'Cliente no conectado',
    'internal server error': 'Error interno del servidor',
    'default': 'Error interno del servidor',
  };

  return errorMessages[errorCode.toLowerCase()] ?? 'Ocurrió un error desconocido';
}