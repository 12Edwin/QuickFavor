import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_modal.dart';

class ProfileCustomer extends StatefulWidget {
  const ProfileCustomer({super.key});

  @override
  State<ProfileCustomer> createState() => _ProfileCustomerState();
}

class _ProfileCustomerState extends State<ProfileCustomer> {
  String email = '';
  String phone = '';
  String address = '';
  String name = '';
  String curp = '';
  String sex = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          address = "${place.street}, ${place.locality}, ${place.country}";
        });
      } else {
        setState(() {
          address = '(Dirección no encontrada)';
        });
      }
    } catch (e) {
      setState(() {
        address = '(Error al obtener la dirección)';
      });
      print('Error al obtener la dirección: $e');
    }
  }

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uid = prefs.getString('uid');

    if (token == null || uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error: Token o UID no encontrados en localStorage')),
      );
      return;
    }

    final url = Uri.parse('http://54.243.28.11:3000/customer/profile/$uid');

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          name = data['name'] ?? '';
          email = data['email'] ?? '';
          phone = data['phone'] ?? '';
          curp = data['curp'] ?? '';
          sex = data['sex'] ?? '';
        });

        // Convertir coordenadas a dirección
        final double? latitude = data['lat'] != null
            ? double.tryParse(data['lat'].toString())
            : null;
        final double? longitude = data['lng'] != null
            ? double.tryParse(data['lng'].toString())
            : null;

        if (latitude != null && longitude != null) {
          _getAddressFromLatLng(LatLng(latitude, longitude));
        } else {
          setState(() {
            address = '(Dirección no disponible)';
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al obtener perfil: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            name,
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
                                phone,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Cliente',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildInfoRow('CURP:', curp),
                                  _buildInfoRow('SEXO:', sex),
                                  _buildInfoRow('CORREO:', email),
                                  _buildInfoRow('DIRECCIÓN:', address),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: EditProfileModal(
                                      currentPhone: phone,
                                      currentAddress: address,
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              shape: const CircleBorder(),
                              backgroundColor: Colors.white,
                            ),
                            child: const Icon(Icons.edit, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value.isNotEmpty ? value : '(vacío)'),
          ),
        ],
      ),
    );
  }
}
