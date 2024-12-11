import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_favor/config/dio_config.dart';
import 'package:mobile_favor/modules/points/screens/map_customerPick.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El número de teléfono debe tener exactamente 10 dígitos')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final dio = DioConfig.createDio(context);
      final Map<String, dynamic> data = {
        'phone': phone.isNotEmpty ? phone : widget.currentPhone,
        'lat': (newCoordinates ?? widget.currentCoordinates).latitude,
        'lng': (newCoordinates ?? widget.currentCoordinates).longitude,
      };

      // Imprimir los datos enviados para depuración
      print('Datos enviados: $data');

      final response = await dio.put(
        '/customer/profile',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Respuesta de la API: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        bool isLocationUpdated = newCoordinates != null && newCoordinates != widget.currentCoordinates;

        if (isLocationUpdated) {
          await prefs.clear();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado con éxito. Sesión cerrada debido a cambio de ubicación.')),
          );
        } else {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Número de teléfono actualizado con éxito')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil: ${response.statusCode}')),
        );
      }
    } on DioException catch (e) {
      // Capturar y mostrar detalles del error de Dio
      print('Error de Dio: ${e.message}');
      print('Detalles del error: ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de Dio: ${e.response?.data ?? e.message}')),
      );
    } catch (e) {
      // Capturar cualquier otro tipo de error
      print('Error general: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
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
