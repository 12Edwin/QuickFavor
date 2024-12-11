import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_favor/kernel/widget/collection-picker.dart'; // Importa el widget del mapa

class EditProfileModal extends StatefulWidget {
  final String currentPhone;
  final String currentAddress;

  const EditProfileModal({
    Key? key,
    required this.currentPhone,
    required this.currentAddress,
  }) : super(key: key);

  @override
  _EditProfileModalState createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  LatLng? coordinates;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.currentPhone;
    addressController.text = widget.currentAddress;
  }

  Future<void> _saveChanges() async {
    final String phone = phoneController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token no encontrado en localStorage')),
      );
      return;
    }

    if (coordinates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una dirección en el mapa')),
      );
      return;
    }

    final url = Uri.parse('http://54.243.28.11:3000/customer/profile');
    setState(() {
      isLoading = true;
    });

    try {
      final body = {
        'phone': phone,
        'lat': coordinates!.latitude,
        'lng': coordinates!.longitude,
      };

      print(jsonEncode(body)); // Depuración: imprimir el cuerpo de la petición

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil: ${response.statusCode}')),
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

  void _openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionPicker(
          onLocationPicked: (double lat, double lng, String address) {
            setState(() {
              addressController.text = address;
              coordinates = LatLng(lat, lng);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Perfil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Número de Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: addressController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Dirección',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: _openMap,
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
