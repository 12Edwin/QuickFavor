import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  int _currentStep = 0;
  int _currentVehicleType = 0;
  String _userType = 'Cliente';
  Color _currentColor = Colors.blue;
  final List<Map<String, dynamic>> _vehicles =
      [
        {'icon': Icons.directions_car, 'name': 'car'},
        {'icon': Icons.motorcycle, 'name': 'motorcycle'},
        {'icon': Icons.pedal_bike, 'name': 'bike'},
        {'icon': Icons.electric_scooter, 'name': 'scooter'},
        {'icon': Icons.directions_walk, 'name': 'walk'},
        {'icon': Icons.more_horiz, 'name': 'other'},
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SafeArea( child: SingleChildScrollView(
      child: Stack(
          children:[
            Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(250),
                bottomRight: Radius.circular(250),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.19,
          ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
              children: [
                  Image.asset(
                    'assets/team_illustration.png',
                    height: 100,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                         Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Registro',
                            style: TextStyle(fontSize:32, color: Theme.of(context).secondaryHeaderColor),
                          ),
                        ),
                        _buildUserTypeSelector(),
                        Padding(padding: const EdgeInsets.all(20), child: _buildForm()),
                        _buildNavigationDots(),
                        _buildNextButton(),
                      ],
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text('Login', style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ],
              ),
            ),
       ],
        ),
      ),
    )
    );
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

  Widget _buildUserTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _userType = 'Cliente';
                _currentStep = 0;
              });
              },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _userType == 'Cliente' ? Colors.indigo : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Cliente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _userType == 'Cliente' ? Colors.indigo : Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _userType = 'Repartidor';
                _currentStep = 0;
              });
              },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _userType == 'Repartidor' ? Colors.indigo : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Repartidor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _userType == 'Repartidor' ? Colors.indigo : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(){
    if (_userType == 'Cliente') {
      switch (_currentStep) {
        case 0:
          return _buildForm1();
        case 1:
          return _buildForm2();
        default:
          return _buildForm1();
      }
    } else {
      switch (_currentStep){
        case 0:
          return _buildForm1();
        case 1:
          return _buildForm_car();
        case 2:
          return _buildForm2();
        default:
          return _buildForm1();
      }
    }
  }

  Widget _buildForm1() {

    return Column(
      children: [
        _buildTextField(icon: Icons.person, hint: 'Nombre', type: 'text'),
        _buildTextField(icon: Icons.person, hint: 'Apellido paterno', type: 'text'),
        _buildTextField(icon: Icons.person, hint: 'Apellido materno', type: 'text'),
        _buildTextField(icon: Icons.credit_card, hint: 'CURP', type: 'text'),
        _buildDropdown(icon: Icons.wc, hint: 'Sexo', items: ['Masculino', 'Femenino', 'Otro']),
      ],
    );
  }

  Widget _buildForm2() {

    return Column(
      children: [
        _buildMapField(),
        _buildTextField(icon: Icons.phone, hint: 'Teléfono', type: 'number'),
        _buildTextField(icon: Icons.mail, hint: 'Correo', type: 'email'),
        _buildTextField(icon: Icons.lock, hint: 'Contraseña', type: 'password'),
        _buildTextField(icon: Icons.lock, hint: 'Repetir contraseña', type: 'password'),
      ],
    );
  }

  Widget _buildForm_car() {

    return Column(
      children: [
        _buildVehicleOptions(),
        const SizedBox(height: 16),
        Divider(
          color: Theme.of(context).secondaryHeaderColor,
          thickness: 2,
          indent: 8,
          endIndent: 8,
        ),
        const SizedBox(height: 16),
        (['car', 'motorcycle'].contains(_vehicles[_currentVehicleType]['name'])) ? _buildTextField(icon: Icons.car_crash, hint: 'Marca', type: 'text'): const SizedBox.shrink(),
        (['car', 'motorcycle', 'bike', 'scooter'].contains(_vehicles[_currentVehicleType]['name'])) ? _buildTextField(icon: Icons.description, hint: 'Modelo', type: 'text'): const SizedBox.shrink(),
        (['car', 'motorcycle'].contains(_vehicles[_currentVehicleType]['name'])) ?_buildTextField(icon: Icons.credit_card, hint: 'Placas', type: 'text'): const SizedBox.shrink(),
        (['other'].contains(_vehicles[_currentVehicleType]['name'])) ?_buildTextField(icon: Icons.description, hint: 'Descripción', type: 'text'): const SizedBox.shrink(),
        Row(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.circle, color: _currentColor, size: 25),
              onPressed: _openColorPicker,
              label: const Text('Color'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMapField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        readOnly: true,
        onTap: () {
          print("Abrir mapa");
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.map, color: Theme.of(context).secondaryHeaderColor),
          labelText: 'Dirección',
          labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: Icon(Icons.location_on, color: Theme.of(context).secondaryHeaderColor),
          ),
        ),
    );
  }

  Widget _buildTextField({required IconData icon, required String hint, required String type}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          keyboardType: type == 'email' ? TextInputType.emailAddress : type == 'number' ? TextInputType.number : type == 'password' ? TextInputType.visiblePassword : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Theme.of(context).secondaryHeaderColor),
            labelText: hint,
            labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: type == 'password' ? IconButton(
              icon: const Icon(Icons.remove_red_eye),
              onPressed: () {
                print("Mostrar contraseña");
              },
            ) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),

          ),
            ),
      );
  }

  Widget _buildDropdown({required IconData icon, required String hint, required List<String> items}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            )
          ),
          hint: Row(
            children: [
              Icon(icon, color: Theme.of(context).secondaryHeaderColor),
              const SizedBox(width: 10),
              Text(hint),
            ],
          ),
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
          },
        ),
    );
  }

  Widget _buildNavigationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _userType == 'Repartidor' ? 3 : 2,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentStep == index ? Colors.indigo : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleOptions(){
    return _buildVehicleTypes(
      _vehicles
    );
  }

   Widget _buildVehicleTypes(List<Map<String, dynamic>> types) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        types.length,
        (index) => GestureDetector(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
              color: _currentVehicleType == index ? Theme.of(context).primaryColor : Colors.grey,
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
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child:
        Row(
          children:[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _currentStep > 0 ?
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text('Anterior'),
                onPressed: () {
                  setState(() {
                    if (_currentStep > 0) _currentStep--;
                  });
                },
              ) : const SizedBox.shrink(),
            ),
            Expanded(
              child:(_userType == 'Cliente' && _currentStep == 1) || (_userType == 'Repartidor' && _currentStep == 2) ?
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text('Registrar'),
                  onPressed: () {

                  },
              ) :

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text('Siguiente'),
                onPressed: () {
                  setState(() {
                    if (_userType == 'Cliente' && _currentStep < 1) _currentStep++;
                    if (_userType == 'Repartidor' && _currentStep < 2) _currentStep++;
                  });
                },
              ),
            )
          ]
        )
    );
  }
}