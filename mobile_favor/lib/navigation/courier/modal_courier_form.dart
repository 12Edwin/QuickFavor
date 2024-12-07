import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mobile_favor/kernel/widget/photo_picker.dart';

class ModalCourier extends StatefulWidget {
  const ModalCourier({Key? key}) : super(key: key);

  @override
  _ModalCourierState createState() => _ModalCourierState();
}

class _ModalCourierState extends State<ModalCourier> {
  String email = '';
  String phone = '';
  int _currentVehicleType = 0;
  Color _currentColor = Colors.blue;
  final TextEditingController _photoController = TextEditingController();

  final List<Map<String, dynamic>> _vehicles = [
    {'icon': Icons.directions_car, 'name': 'car'},
    {'icon': Icons.motorcycle, 'name': 'motorcycle'},
    {'icon': Icons.pedal_bike, 'name': 'bike'},
    {'icon': Icons.electric_scooter, 'name': 'scooter'},
    {'icon': Icons.directions_walk, 'name': 'walk'},
    {'icon': Icons.more_horiz, 'name': 'other'},
  ];

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
              });
            },
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
            if (['car', 'motorcycle']
                .contains(_vehicles[_currentVehicleType]['name']))
              _buildTextField(
                  icon: Icons.car_crash, hint: 'Marca', type: 'text'),
            if (['car', 'motorcycle', 'bike', 'scooter']
                .contains(_vehicles[_currentVehicleType]['name']))
              _buildTextField(
                  icon: Icons.description, hint: 'Modelo', type: 'text'),
            if (['car', 'motorcycle']
                .contains(_vehicles[_currentVehicleType]['name']))
              _buildTextField(
                  icon: Icons.credit_card, hint: 'Placas', type: 'text'),
            if (['other'].contains(_vehicles[_currentVehicleType]['name']))
              _buildTextField(
                  icon: Icons.description, hint: 'Descripción', type: 'text'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (['car', 'motorcycle', 'bike', 'scooter']
                    .contains(_vehicles[_currentVehicleType]['name']))
                  Flexible(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.circle, color: _currentColor, size: 25),
                      onPressed: _openColorPicker,
                      label: const Text('Color'),
                    ),
                  ),
                if (['car', 'motorcycle']
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
            if (['walk'].contains(_vehicles[_currentVehicleType]['name']))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.asset('assets/walk.png', height: 200),
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
                    onPressed: () {},
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

  Widget _buildTextField(
      {required IconData icon, required String hint, required String type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: type == 'email'
            ? TextInputType.emailAddress
            : type == 'number'
                ? TextInputType.number
                : type == 'password'
                    ? TextInputType.visiblePassword
                    : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Theme.of(context).secondaryHeaderColor),
          labelText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2), // Focused border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(
                color: Theme.of(context).secondaryHeaderColor,
                width: 1), // Enabled border
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
