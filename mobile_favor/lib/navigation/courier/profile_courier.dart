import 'package:flutter/material.dart';
import 'package:mobile_favor/navigation/courier/modal_courier_form.dart';
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
                      const Text(
                        'Juan Rodrigo',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '777-234-4325',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                        color: Colors.white.withOpacity(0.8),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Repartidor',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: Text('CURP:')),
                                  Expanded(child: Text('OOAZ900824MTSRLL08')),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: Text('SEXO:')),
                                  Expanded(child: Text('Masculino')),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: Text('COREREO:')),
                                  Expanded(child: Text('correo@gmail.com')),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone),
                          label: const Text('Nuevo teléfono'),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          label: const Text('Nuevo correo'),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
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
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.remove('isLoggedIn');
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
                      const Text(
                        'Repartidor a moto',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Icon(
                        Icons.motorcycle,
                        size: 80,
                        color: Colors.white,
                      ),
                      Text(
                        'Yamaha YBR 125 ZR 2023 COLOR ROJO',
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
