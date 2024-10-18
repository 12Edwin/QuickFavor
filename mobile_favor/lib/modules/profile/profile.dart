import 'package:flutter/material.dart';
import 'package:mobile_favor/utils/app_colors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email = '';
  String phone = '';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
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
                bottom: -screenWidth * 1,
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
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print('Guardar');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(64),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: const Icon(Icons.edit, color: Colors.black),
                          ),
                        ],
                      ),
                      const Text(
                        'Repartidor a moto',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
