import 'package:flutter/material.dart';
import 'package:mobile_favor/navigation/courier/entity/profile_courier.entity.dart';
import 'package:mobile_favor/navigation/courier/modal_courier_form.dart';
import 'package:mobile_favor/navigation/courier/service/profile_courier.service.dart';
import 'package:mobile_favor/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Import necesario para FilteringTextInputFormatter

import '../customer/service/profile.service.dart';

class ProfileCourier extends StatefulWidget {
  const ProfileCourier({super.key});

  @override
  State<ProfileCourier> createState() => _ProfileCourierState();
}

class _ProfileCourierState extends State<ProfileCourier> {
  String email = '';
  String phone = '';
  ProfileCourierEntity? profileCourier;
  late ProfileCourierService _profileCourierService;

  @override
  @override
  void initState() {
    super.initState();
    _profileCourierService = ProfileCourierService(context);
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      ProfileCourierEntity? profile =
          await _profileCourierService.getProfileCourier();
      if (profile != null) {
        setState(() {
          profileCourier = profile;
          phone = profile.phone ?? '';
          email = profile.email ?? '';
        });
      } else {
        print('No se pudo cargar el perfil');
      }
    } catch (e) {
      print('Error al cargar el perfil: $e');
    }
  }

  // Método para mostrar el modal de edición de teléfono
  void _showEditPhoneModal(String currentPhone) {
    TextEditingController phoneController =
        TextEditingController(text: currentPhone);
    ProfileCourierService profileService = ProfileCourierService(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Modifica tu número de teléfono'),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Permite solo números
              LengthLimitingTextInputFormatter(10), // Limita a 10 caracteres
            ],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              hintText: 'Ingresa tu número de 10 dígitos',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CERRAR'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newPhone = phoneController.text;

                // Validar que el número tiene exactamente 10 dígitos
                if (newPhone.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'El número debe tener exactamente 10 dígitos')),
                  );
                  return;
                }

                // Crear una copia del perfil con el nuevo número
                ProfileCourierEntity updatedProfile =
                    profileCourier!.copyWith(phone: newPhone);

                // Llamar al servicio para actualizar el perfil
                bool success =
                    await profileService.updateProfile(updatedProfile);

                if (success) {
                  setState(() {
                    phone = newPhone;
                    profileCourier =
                        updatedProfile; // Actualizar el perfil en la vista
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Número de teléfono actualizado exitosamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Error al actualizar el número de teléfono')),
                  );
                }

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34344E),
              ),
              child: const Text(
                'GUARDAR',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLicenseImageModal(String? plate_url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Foto de la licencia'),
          content: plate_url != null && plate_url.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      plate_url,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Aquí está la imagen de tu licencia.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                )
              : const Text('No hay imagen de licencia disponible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CERRAR'),
            ),
          ],
        );
      },
    );
  }

  void _showINEImageModal(String? ineUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Foto de la INE'),
          content: ineUrl != null && ineUrl.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      ineUrl,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Aquí está la imagen de tu INE.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                )
              : const Text('No hay imagen de INE disponible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CERRAR'),
            ),
          ],
        );
      },
    );
  }

  IconData _getVehicleIcon(String? vehicleType) {
    final Map<String, IconData> vehicleIcons = {
      'Carro': Icons.directions_car,
      'Moto': Icons.motorcycle,
      'Bicicleta': Icons.pedal_bike,
      'Scooter': Icons.electric_scooter,
      'Caminando': Icons.directions_walk,
      'Otro': Icons.more_horiz,
    };

    return vehicleIcons[vehicleType] ?? Icons.directions_car;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.05),
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Positioned(
                top: -screenWidth * 0.809,
                left: (screenWidth - (screenWidth * 1.5)) / 2,
                child: Container(
                  width: screenWidth * 1.5,
                  height: screenWidth * 1.5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF34344E),
                  ),
                ),
              ),
              Positioned(
                bottom: -screenWidth * 0.8,
                left: (screenWidth - (screenWidth * 1.5)) / 2,
                child: Container(
                  width: screenWidth * 1.5,
                  height: screenWidth * 1.5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryColor2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[
                            300], // Color de fondo por si la imagen no carga
                        backgroundImage: profileCourier?.faceUrl != null &&
                                profileCourier!.faceUrl!.isNotEmpty
                            ? NetworkImage(profileCourier!.faceUrl!)
                            : null, // Mostrar la imagen si faceUrl no es null o vacío
                        child: profileCourier?.faceUrl == null ||
                                profileCourier!.faceUrl!.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              )
                            : null, // Mostrar el ícono por defecto si no hay imagen
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${profileCourier?.name ?? ''} ${profileCourier?.surname ?? ''} ${profileCourier?.lastname ?? ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            profileCourier?.phone ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                        color: Colors.white.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Repartidor',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Expanded(child: Text('CURP:')),
                                  Expanded(
                                    child: Text(profileCourier?.curp ?? ''),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Expanded(child: Text('SEXO:')),
                                  Expanded(
                                      child: Text(profileCourier?.sex ?? '')),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Expanded(child: Text('CORREO:')),
                                  Expanded(
                                      child: Text(profileCourier?.email ?? '')),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Expanded(child: Text('TELÉFONO:')),
                                  Expanded(
                                      child: Text(profileCourier?.phone ?? '')),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Botón para editar el número de teléfono
                          IconButton(
                            onPressed: () {
                              _showEditPhoneModal(phone);
                            },
                            icon: const Icon(Icons.phone, color: Colors.black),
                            iconSize: 36,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Botón para información personal (similar al segundo icono de la imagen)
                          IconButton(
                            onPressed: () {
                              _showLicenseImageModal(profileCourier?.plateUrl);
                            },
                            icon: const Icon(Icons.badge, color: Colors.black),
                            iconSize: 36,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Botón para credencial o tarjeta (similar al tercer icono de la imagen)
                          IconButton(
                            onPressed: () {
                              _showINEImageModal(profileCourier?.ineUrl);
                            },
                            icon: const Icon(Icons.credit_card,
                                color: Colors.black),
                            iconSize: 36,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (profileCourier != null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                        ),
                                        child: ModalCourier(
                                            profile:
                                                profileCourier!), // Pasar el perfil aquí
                                      ),
                                    );
                                  },
                                );
                              } else {
                                // Mostrar un mensaje si el perfil no está disponible
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Perfil no disponible, intenta nuevamente')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.white, // Color blanco para el botón
                              shape: const CircleBorder(), // Forma circular
                              padding: const EdgeInsets.all(
                                  16), // Padding para que el botón sea circular y tenga buen tamaño
                              elevation: 2, // Sombra para un efecto elevado
                            ),
                            child: const Icon(
                              Icons.edit, // Ícono de editar (lápiz)
                              color: Colors.black, // Color del ícono
                              size: 24, // Tamaño del ícono
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove('isLoggedIn');
                              prefs.remove('uid');
                              prefs.remove('role');
                              prefs.remove('token');
                              prefs.remove('no_user');
                              prefs.remove('name');
                              prefs.remove('lat');
                              prefs.remove('lng');
                              prefs.remove('availability');
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(
                                  15), // Hacer el padding cuadrado
                              shape:
                                  const CircleBorder(), // Cambiar a CircleBorder para hacerlo redondo
                              backgroundColor: Colors.white,
                            ),
                            child:
                                const Icon(Icons.logout, color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        profileCourier?.vehicleType ?? '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(
                        _getVehicleIcon(profileCourier?.vehicleType),
                        size: 80,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Card que muestra el valor de licensePlate
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 2,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profileCourier?.licensePlate ??
                                        'N/A', // Mostrar licensePlate
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Card que muestra el icono del vehículo
                          SizedBox(
                            height: 60,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 2,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Icon(Icons.person,
                                            size: 20, color: Colors.black),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          _getVehicleIcon(profileCourier
                                              ?.vehicleType), // Icono dinámico
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
