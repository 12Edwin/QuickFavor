import 'package:flutter/material.dart';
import 'package:mobile_favor/navigation/courier/entity/profile_courier.entity.dart';
import 'package:mobile_favor/navigation/courier/modal_courier_form.dart';
import 'package:mobile_favor/navigation/courier/service/profile_courier.service.dart';
import 'package:mobile_favor/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
              ),
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
              onPressed: () {
                setState(() {
                  phone = phoneController.text;
                });
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

  void _showLicenseImageModal(String? plateUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Foto de la licencia'),
          content: plateUrl != null && plateUrl.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      plateUrl,
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.05),
              child: ElevatedButton(
                  onPressed: () => print('guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.black),
                  )),
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
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      width: screenWidth * 2,
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                      ),
                                      child: const ModalCourier(),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: const CircleBorder(),
                              backgroundColor: Colors.white,
                            ),
                            child: const Icon(Icons.edit, color: Colors.black),
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
                      const Icon(
                        Icons.motorcycle,
                        size: 80,
                        color: Colors.white,
                      ),
                      Text(
                        '${profileCourier?.licensePlate ?? ''} ',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 2,
                            color: Colors.white,
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('1234 BCD',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 60,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 2,
                              color: Colors.white,
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.person,
                                            size: 20, color: Colors.black),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.directions_car,
                                            size: 20, color: Colors.black),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
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
