import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/dio_config.dart';
import 'package:mobile_favor/config/error_types.dart';
import 'package:mobile_favor/modules/points/screens/map_customerPick.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'service/profile.service.dart';

class EditProfileModal extends StatefulWidget {
  final String currentPhone;
  final String currentAddress;
  final LatLng currentCoordinates;

  const EditProfileModal({
    Key? key,
    required this.currentPhone,
    required this.currentAddress,
    required this.currentCoordinates,
  }) : super(key: key);

  @override
  _EditProfileModalState createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  LatLng? newCoordinates;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.currentPhone;
    addressController.text = widget.currentAddress;
    newCoordinates = widget.currentCoordinates;
  }

  Future<void> _saveChanges() async {
    final String phone = phoneController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token no encontrado')),
      );
      return;
    }

    // Validación del número de teléfono (exactamente 10 dígitos y solo números)
    if (phone.isNotEmpty && (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone))) {
      showWarningAlert(context, 'El número de teléfono debe tener exactamente 10 dígitos y solo números.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final service = ProfileService(context);
    final Map<String, dynamic> data = {
      'phone': phone.isNotEmpty ? phone : widget.currentPhone,
      'lat': (newCoordinates ?? widget.currentCoordinates).latitude,
      'lng': (newCoordinates ?? widget.currentCoordinates).longitude,
    };

    final response = await service.updateCustomerProfile(data);

    if (response.error) {
      showErrorAlert(context, getErrorMessages(response.message));
      setState(() {
        isLoading = false;
      });
      return;
    }
    showSuccessAlert(context, 'Perfil actualizado con éxito. Sesión cerrada debido a cambio de ubicación.');
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

    setState(() {
      isLoading = false;
    });
  }

  void _openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapCustomerPick(
          onLocationPicked: (double lat, double lng, String address) {
            setState(() {
              addressController.text = address;
              newCoordinates = LatLng(lat, lng);
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
              keyboardType: TextInputType.number,
              maxLength: 10,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
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
