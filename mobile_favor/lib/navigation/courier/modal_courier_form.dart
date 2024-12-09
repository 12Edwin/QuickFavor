import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mobile_favor/kernel/widget/photo_picker.dart';
import 'package:mobile_favor/navigation/courier/entity/profile_courier.entity.dart';

class ModalCourier extends StatefulWidget {
    final ProfileCourierEntity profile; // Asegúrate de tener esta línea

  const ModalCourier({Key? key, required this.profile}) : super(key: key);

  @override
  _ModalCourierState createState() => _ModalCourierState();
}

class _ModalCourierState extends State<ModalCourier> {
  int _currentVehicleType = 0;
  Color _currentColor = Colors.blue;
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placasController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  final List<Map<String, dynamic>> _vehicles = [
    {'icon': Icons.directions_car, 'name': 'Carro'},
    {'icon': Icons.motorcycle, 'name': 'Moto'},
    {'icon': Icons.pedal_bike, 'name': 'Bicicleta'},
    {'icon': Icons.electric_scooter, 'name': 'Scooter'},
    {'icon': Icons.directions_walk, 'name': 'Caminando'},
    {'icon': Icons.more_horiz, 'name': 'Otro'},
  ];

  @override
void initState() {
  super.initState();
  _currentVehicleType = _getVehicleIndex(widget.profile.vehicleType);

  // Inicializar los controladores con la información del perfil
  _marcaController.text = widget.profile.brand ?? '';
  _modeloController.text = widget.profile.model ?? '';
  _placasController.text = widget.profile.licensePlate ?? '';
  _descripcionController.text = widget.profile.description ?? '';

  _currentColor = widget.profile.color != null
      ? Color(int.parse(widget.profile.color!.replaceFirst('#', '0xFF')))
      : Colors.blue;
}

int _getVehicleIndex(String? vehicleType) {
  return _vehicles.indexWhere((v) => v['name'].toLowerCase() == vehicleType?.toLowerCase());
}

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  _currentColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Elegir color'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildVehicleTypes(List<Map<String, dynamic>> types) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          types.length,
          (index) => GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
                color: _currentVehicleType == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              child: Icon(types[index]['icon'], color: Colors.white),
            ),
onTap: () {
  setState(() {
    _currentVehicleType = index;

    // Actualizar los controladores con los datos del perfil correspondientes al nuevo tipo de vehículo
    switch (_vehicles[_currentVehicleType]['name']) {
      case 'car':
      case 'Moto':
        _marcaController.text = widget.profile.brand ?? '';
        _modeloController.text = widget.profile.model ?? '';
        _placasController.text = widget.profile.licensePlate ?? '';
        _descripcionController.clear();
        break;
      case 'bike':
      case 'scooter':
        _marcaController.clear();
        _modeloController.text = widget.profile.model ?? '';
        _placasController.clear();
        _descripcionController.clear();
        break;
      case 'other':
        _marcaController.clear();
        _modeloController.clear();
        _placasController.clear();
        _descripcionController.text = widget.profile.description ?? '';
        break;
      default:
        _marcaController.clear();
        _modeloController.clear();
        _placasController.clear();
        _descripcionController.clear();
        break;
    }
  });
}
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildVehicleTypes(_vehicles),
            const SizedBox(height: 16),
            Divider(
              color: Theme.of(context).secondaryHeaderColor,
              thickness: 2,
              indent: 8,
              endIndent: 8,
            ),
            const SizedBox(height: 16),
            if (['car', 'Moto']
                .contains(_vehicles[_currentVehicleType]['name']))
              _buildTextField(
                  icon: Icons.car_crash, hint: 'Marca', controller: _marcaController),
            if (['car', 'Moto', 'bike', 'scooter']
                .contains(_vehicles[_currentVehicleType]['name']))
              _buildTextField(
                  icon: Icons.description, hint: 'Modelo', controller: _modeloController),
            if (['car', 'Moto']
                .contains(_vehicles[_currentVehicleType]['name']))
              _buildTextField(
                  icon: Icons.credit_card, hint: 'Placas', controller: _placasController),
                  
if (_vehicles[_currentVehicleType]['name'] == 'other' || _vehicles[_currentVehicleType]['name'] == 'walk')              _buildTextField(
                  icon: Icons.description, hint: 'Descripción', controller: _descripcionController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (['car', 'Moto', 'bike', 'scooter']
                    .contains(_vehicles[_currentVehicleType]['name']))
                  Flexible(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.circle, color: _currentColor, size: 25),
                      onPressed: _openColorPicker,
                      label: const Text('Color'),
                    ),
                  ),
                if (['car', 'Moto']
                    .contains(_vehicles[_currentVehicleType]['name']))
                  Flexible(
                    child: PhotoPicker(
                      label: 'Licencia',
                      textDialog: 'Licencia de conducir',
                      widthImg: 856,
                      controller: _photoController,
                      heightImg: 540,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí puedes guardar los cambios
                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Theme.of(context).secondaryHeaderColor),
          labelText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
