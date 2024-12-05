import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/error_types.dart';
import 'package:mobile_favor/kernel/widget/photo_picker.dart';
import 'package:mobile_favor/modules/auth/service/auth_service.dart';
import '../../kernel/widget/location-picker.dart';
import 'entity/auth.entity.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  final _nameKey = GlobalKey<FormState>();
  final _surnameKey = GlobalKey<FormState>();
  final _lastnameKey = GlobalKey<FormState>();
  final _curpKey = GlobalKey<FormState>();
  final _sexKey = GlobalKey<FormState>();
  final _brandKey = GlobalKey<FormState>();
  final _modelKey = GlobalKey<FormState>();
  final _plateKey = GlobalKey<FormState>();
  final _descriptionKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _repeatPasswordKey = GlobalKey<FormState>();
  int _currentStep = 0;
  int _currentVehicleType = 0;
  String _userType = 'Cliente';
  Color _currentColor = Colors.transparent;
  final List<Map<String, dynamic>> _vehicles = [
    {'icon': Icons.directions_car, 'name': 'car', 'id': 'Carro'},
    {'icon': Icons.motorcycle, 'name': 'motorcycle', 'id': 'Motocicleta'},
    {'icon': Icons.pedal_bike, 'name': 'bike', 'id': 'Bicicleta'},
    {'icon': Icons.electric_scooter, 'name': 'scooter', 'id': 'Scooter'},
    {'icon': Icons.directions_walk, 'name': 'walk', 'id': 'Caminando'},
    {'icon': Icons.more_horiz, 'name': 'other', 'id': 'Otro'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _curpController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _licensePhotoController = TextEditingController();
  final TextEditingController _facePhotoController = TextEditingController();
  final TextEditingController _inePhotoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  Map<String, bool> validationForm = {};

  @override
  initState() {
    super.initState();
    _vehicleTypeController.text = _vehicles[0]['id'];
    _sexController.text = 'Masculino';
    validationForm['lastname'] = true;
    validationForm['description'] = true;
  }

  bool _validateFields() {
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _curpController.text.isEmpty ||
        _sexController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _facePhotoController.text.isEmpty ||
        _inePhotoController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _repeatPasswordController.text.isEmpty ||
        ([1,2].contains(_currentVehicleType) && _licensePhotoController.text.isEmpty) ||
        !(validationForm['name'] ?? false) ||
        !(validationForm['surname'] ?? false) ||
        !(validationForm['lastname'] ?? false) ||
        !(validationForm['curp'] ?? false) ||
        !(validationForm['brand'] ?? false) ||
        !(validationForm['model'] ?? false) ||
        !(validationForm['plate'] ?? false) ||
        !(validationForm['color'] ?? false) ||
        !(validationForm['description'] ?? false) ||
        !(validationForm['phone'] ?? false) ||
        !(validationForm['email'] ?? false) ||
        !(validationForm['password'] ?? false) ||
        !(validationForm['repeatPassword'] ?? false)) {
      return false;
    }
    return true;
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    if (_userType == 'Cliente') {
      await _registerCustomer();
    } else {
      await _registerCourier();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _registerCourier() async {
    final courier = RegisterCourierEntity(
        name: _nameController.text,
        surname: _surnameController.text,
        lastname: _lastnameController.text.isNotEmpty ? _lastnameController.text : null,
        CURP: _curpController.text,
        sex: _sexController.text,
        phone: _phoneController.text,
        brand: _brandController.text.isNotEmpty ? _brandController.text : null,
        model: _modelController.text.isNotEmpty ? _modelController.text : null,
        license_plate: _plateController.text.isNotEmpty ? _plateController.text : null,
        color: _colorController.text.isNotEmpty ? _colorController.text : null,
        plate_photo: _licensePhotoController.text.isNotEmpty ? _licensePhotoController.text : null,
        face_photo: _facePhotoController.text,
        INE_photo: _inePhotoController.text,
        email: _emailController.text,
        password: _passwordController.text,
        vehicle_type: _vehicleTypeController.text,
      );
    if (!_validateFields()) {
      print(courier.toJson());
      print(validationForm);
      showErrorAlert(context, 'Llena los campos correctamente');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final AuthService authService = AuthService(context);
    final response = await authService.registerCourier(courier);
    print(response.message);
    if (response.error){
      showErrorAlert(context, getErrorMessages(response.message));
    }else{
      showSuccessAlert(context, 'Registro exitoso, Verifica tu correo electrónico');
      Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  bool _validateCustomerFields() {
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _curpController.text.isEmpty ||
        _sexController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _latitudeController.text.isEmpty ||
        _longitudeController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _repeatPasswordController.text.isEmpty ||
        !(validationForm['name'] ?? false) ||
        !(validationForm['surname'] ?? false) ||
        !(validationForm['lastname'] ?? false) ||
        !(validationForm['curp'] ?? false) ||
        !(validationForm['phone'] ?? false) ||
        !(validationForm['email'] ?? false) ||
        !(validationForm['password'] ?? false) ||
        !(validationForm['repeatPassword'] ?? false)) {
      return false;
    }
    return true;
  }

  Future<void> _registerCustomer() async {
    final customer = RegisterCustomerEntity(
        name: _nameController.text,
        surname: _surnameController.text,
        lastname: _lastnameController.text.isNotEmpty ? _lastnameController.text : null,
        CURP: _curpController.text,
        sex: _sexController.text,
        direction: _addressController.text,
        lat: _latitudeController.text.isNotEmpty ? double.parse(_latitudeController.text) : 0,
        lng: _longitudeController.text.isNotEmpty ? double.parse(_longitudeController.text) : 0,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text);
    if (!_validateCustomerFields()) {
      print(validationForm);
      showErrorAlert(context, 'Llena los campos correctamente');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    print(customer.toJson());
    final AuthService authService = AuthService(context);
    final response = await authService.registerCustomer(customer);
    print(response.data);
    print(response.message);
    if (response.error) {
      showErrorAlert(context, getErrorMessages(response.message));
    } else {
      showSuccessAlert(context, 'Registro exitoso. Verifica tu correo electrónico');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
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
                            style: TextStyle(
                                fontSize: 32,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                        ),
                        _buildUserTypeSelector(),
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: _buildForm()),
                        _buildNavigationDots(),
                        _buildNextButton(),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: Text('Login',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
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
                  validationForm['color'] = true;
                  _colorController.text = '${color.red},${color.green},${color.blue}';
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
                    color: _userType == 'Cliente'
                        ? Colors.indigo
                        : Colors.transparent,
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
                    color: _userType == 'Repartidor'
                        ? Colors.indigo
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Repartidor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      _userType == 'Repartidor' ? Colors.indigo : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
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
      switch (_currentStep) {
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

  String? validateName(String? value, String id) {
    if (value == null || value.isEmpty) {
      validationForm[id] = false;
      return 'Campo obligatorio';
    }
    if(value.length < 5){
      validationForm[id] = false;
      return 'Campo muy corto';
    }
    if(value.length > 80){
      validationForm[id] = false;
      return 'Campo muy largo';
    }
    final pattern = RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚäëïöüÄËÏÖÜ\s]+$");
    if (!pattern.hasMatch(value)) {
      validationForm[id] = false;
      return 'Campo no válido';
    }
    validationForm[id] = true;
    return null;
  }

  String? validateOptionalName(String? value, String id) {
    if (value == null || value.isEmpty) {
      validationForm[id] = true;
      return null;
    }
    if(value.length < 3){
      validationForm[id] = false;
      return 'Campo muy corto';
    }
    if(value.length > 80){
      validationForm[id] = false;
      return 'Campo muy largo';
    }
    final pattern = RegExp(r"^[a-zA-ZñÑáéíóúÁÉÍÓÚäëïöüÄËÏÖÜ\s]+$");
    if (!pattern.hasMatch(value)) {
      validationForm[id] = false;
      return 'Campo no válido';
    }
    validationForm[id] = true;
    return null;
  }

  Widget _buildForm1() {
    return Column(
      children: [
        _buildTextField(id: 'name', icon: Icons.person, hint: 'Nombre', type: 'text', formKey: _nameKey, validator: validateName),
        _buildTextField(id: 'surname', icon: Icons.person, hint: 'Apellido paterno', type: 'text', formKey: _surnameKey, validator: validateName),
        _buildTextField(id: 'lastname', icon: Icons.person, hint: 'Apellido materno', type: 'text', formKey: _lastnameKey, validator: validateOptionalName),
        _buildCurpField(),
        _buildDropdown(
            icon: Icons.wc,
            hint: 'Sexo',
            items: ['Masculino', 'Femenino'],
            controller: _sexController,
            validator: validateSex,
            formKey: _sexKey
        ),

      ],
    );
  }

  String? validatePhone(String? value, String id) {
    if (value == null || value.isEmpty) {
      validationForm[id] = false;
      return 'Campo obligatorio';
    }
    final pattern = RegExp(r'^\d{10}$');
    if (!pattern.hasMatch(value)) {
      validationForm[id] = false;
      return 'Campo no válido';
    }
    validationForm[id] = true;
    return null;
  }

  String? validatePassword(String? value, String id) {
    if (value == null || value.isEmpty) {
      validationForm[id] = false;
      return 'Campo obligatorio';
    }
    if (value.length < 6) {
      validationForm[id] = false;
      return 'Campo no válido';
    }
    validationForm[id] = true;
    return null;
  }

  String? validateRepeatedPassword(String? value, String id) {
    if (value == null || value.isEmpty) {
      validationForm[id] = false;
      return 'Campo obligatorio';
    }
    if (value != _passwordController.text) {
      validationForm[id] = false;
      return 'Las contraseñas no coinciden';
    }
    validationForm[id] = true;
    return null;
  }

  String? validateEmail(String? value, String id) {
    if (value == null || value.isEmpty) {
      validationForm[id] = false;
      return 'Campo obligatorio';
    }
    final pattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!pattern.hasMatch(value)) {
      validationForm[id] = false;
      return 'Campo no válido';
    }
    validationForm[id] = true;
    return null;
  }

  Widget _buildForm2() {
    return Column(
      children: [
        if (_userType == 'Repartidor')
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PhotoPicker(
                    label: 'Rostro',
                    textDialog: 'Foto de su rostro',
                    widthImg: 200,
                    controller: _facePhotoController,
                    heightImg: 200),
                PhotoPicker(
                    label: 'INE',
                    textDialog: 'Foto de su INE',
                    widthImg: 856,
                    controller: _inePhotoController,
                    heightImg: 540)
              ],
            ),
          )
        else
          _buildMapField(),
        _buildTextField(id: 'phone', icon: Icons.phone, hint: 'Teléfono', type: 'number', formKey: _phoneKey, validator: validatePhone),
        _buildTextField(id: 'email', icon: Icons.mail, hint: 'Correo', type: 'email', formKey: _emailKey, validator: validateEmail),
        _buildTextField(id: 'password', icon: Icons.lock, hint: 'Contraseña', type: 'password', formKey: _passwordKey, validator: validatePassword),
        _buildTextField(
            id:'repeatPassword', icon: Icons.lock, hint: 'Repetir contraseña', type: 'password', formKey: _repeatPasswordKey, validator: validateRepeatedPassword),
      ],
    );
  }

  String? validateCar(String? value, String id) {
    if (value == null || value.isEmpty) {
      validationForm[id] = false;
      return 'Campo obligatorio';
    }
    if (value.length < 3) {
      validationForm[id] = false;
      return 'El tamaño mínimo es de 3 caracteres';
    }
    validationForm[id] = true;
    return null;
  }

  String? validateLicensePlate(String? value, String id) {
    if (value == null || value.isEmpty) {
      validationForm[id] = false;
      return 'Campo obligatorio';
    }
    final pattern = RegExp(r'^[A-Z0-9]+-[A-Z0-9]+$');
    if (!pattern.hasMatch(value)) {
      validationForm[id] = false;
      return 'Placas no válidas';
    }
    validationForm[id] = true;
    return null;
  }

  Widget _buildForm_car() {
    return Column(
      children: [
        _buildVehicleOptions(_vehicleTypeController),
        const SizedBox(height: 16),
        Divider(
          color: Theme.of(context).secondaryHeaderColor,
          thickness: 2,
          indent: 8,
          endIndent: 8,
        ),
        const SizedBox(height: 16),
        (['car', 'motorcycle'].contains(_vehicles[_currentVehicleType]['name']))
            ? _buildTextField(
                id: 'brand', icon: Icons.car_crash, hint: 'Marca', type: 'text', formKey: _brandKey, validator: validateCar)
            : const SizedBox.shrink(),
        (['car', 'motorcycle', 'bike', 'scooter']
                .contains(_vehicles[_currentVehicleType]['name']))
            ? _buildTextField(
                id: 'model', icon: Icons.description, hint: 'Modelo', type: 'text', formKey: _modelKey, validator: validateCar)
            : const SizedBox.shrink(),
        (['car', 'motorcycle'].contains(_vehicles[_currentVehicleType]['name']))
            ? _buildTextField(
                id: 'plate', icon: Icons.credit_card, hint: 'Placas', type: 'text', formKey: _plateKey, validator: validateLicensePlate)
            : const SizedBox.shrink(),
        (['other'].contains(_vehicles[_currentVehicleType]['name']))
            ? _buildTextField(
                id: 'description', icon: Icons.description, hint: 'Descripción', type: 'text', formKey: _descriptionKey, validator: validateCar)
            : const SizedBox.shrink(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (['car', 'motorcycle', 'bike', 'scooter']
                .contains(_vehicles[_currentVehicleType]['name']))
              ElevatedButton.icon(
                icon: Icon(Icons.circle, color: _currentColor, size: 25),
                onPressed: _openColorPicker,
                label: const Text('Color'),
              ),
            if (['car', 'motorcycle']
                .contains(_vehicles[_currentVehicleType]['name']))
              PhotoPicker(
                label: 'Licencia',
                textDialog: 'Liciencia de conducir',
                widthImg: 856,
                controller: _licensePhotoController,
                heightImg: 540,
              ),
          ],
        ),
        if (['walk'].contains(_vehicles[_currentVehicleType]['name']))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.asset('assets/walk.png', height: 200),
          )
      ],
    );
  }

  Widget _buildMapField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        readOnly: true,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationPicker(
                onLocationPicked: (LatLng location, String address) {
                  _latitudeController.text = location.latitude.toString();
                  _longitudeController.text = location.longitude.toString();
                  _addressController.text = address;
                },
              ),
            ),
          );
        },
        controller: _addressController,
        decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.map, color: Theme.of(context).secondaryHeaderColor),
          labelText: 'Dirección',
          labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: Icon(Icons.location_on,
              color: Theme.of(context).secondaryHeaderColor),
        ),
      ),
    );
  }

  Widget _buildTextField({
  required String id,
  required IconData icon,
  required String hint,
  required String type,
  required GlobalKey<FormState> formKey,
  required String? Function(String?, String) validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Form(
      key: formKey,
      child: TextFormField(
        controller: _getController(hint),
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
          labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: type == 'password'
              ? IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () {
                    print("Mostrar contraseña");
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        validator: (String? value) => validator(value, id),
        onChanged: (value) {
          formKey.currentState?.validate();
        },
      ),
    ),
  );
}

  TextEditingController _getController(String hint) {
    switch (hint) {
      case 'Nombre':
        return _nameController;
      case 'Apellido paterno':
        return _surnameController;
      case 'Apellido materno':
        return _lastnameController;
      case 'CURP':
        return _curpController;
      case 'Sexo':
        return _sexController;
      case 'Teléfono':
        return _phoneController;
      case 'Correo':
        return _emailController;
      case 'Contraseña':
        return _passwordController;
      case 'Repetir contraseña':
        return _repeatPasswordController;
      case 'Marca':
        return _brandController;
      case 'Modelo':
        return _modelController;
      case 'Placas':
        return _plateController;
      case 'Color':
        return _colorController;
      case 'Descripción':
        return _descriptionController;
      default:
        return TextEditingController();
    }
  }

  String? validateSex(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  Widget _buildDropdown({
  required IconData icon,
  required String hint,
  required List<String> items,
  required TextEditingController controller,
  required String? Function(String?) validator,
  required GlobalKey<FormState> formKey,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Focus(
      onFocusChange: (hasFocus) {
        formKey.currentState?.validate();
      },
      child: Form(
        key: _sexKey,
        child: DropdownButtonFormField<String>(
          value: items.contains(controller.text) ? controller.text : 'Masculino',
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            ),
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
            controller.text = value!;
          },
          validator: validator,
        ),
      ),
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

  Widget _buildVehicleOptions(TextEditingController controller) {
    return _buildVehicleTypes(_vehicles, controller);
  }

  Widget _buildVehicleTypes(List<Map<String, dynamic>> types, TextEditingController controller) {
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
            shape: BoxShape.circle,
            color: _currentVehicleType == index ? Colors.indigo : Colors.grey,
          ),
          child: Icon(types[index]['icon'], color: Colors.white),
        ),
        onTap: () {
          setState(() {
            _currentVehicleType = index;
            controller.text = types[index]['id'];
            _modelController.clear();
            _brandController.clear();
            _plateController.clear();
            _descriptionController.clear();
            _colorController.clear();
            _licensePhotoController.clear();
            _currentColor = Colors.transparent;
          });
          switch (index){
          case 0 || 1:
            validationForm['model'] = false;
            validationForm['brand'] = false;
            validationForm['plate'] = false;
            validationForm['color'] = false;
            validationForm['plate_photo'] = false;
            validationForm['description'] = true;
            break;
          case 2 || 3:
            validationForm['model'] = false;
            validationForm['brand'] = true;
            validationForm['plate'] = true;
            validationForm['color'] = false;
            validationForm['plate_photo'] = true;
            validationForm['description'] = true;
            break;
          case 4:
            validationForm['model'] = true;
            validationForm['brand'] = true;
            validationForm['plate'] = true;
            validationForm['color'] = true;
            validationForm['plate_photo'] = true;
            validationForm['description'] = true;
            break;
          case 5:
            validationForm['model'] = true;
            validationForm['brand'] = true;
            validationForm['plate'] = true;
            validationForm['color'] = true;
            validationForm['plate_photo'] = true;
            validationForm['description'] = false;
            break;
          }
        },
      ),
    ),
  );
}

Widget _buildCurpField() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
      child: Form(
        key: _curpKey,
        child: TextFormField(
          controller: _curpController,
          inputFormatters: [UpperCaseTextFormatter()],
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.credit_card, color: Theme.of(context).secondaryHeaderColor),
            labelText: 'CURP',
            labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
          onChanged: (value) {
            _curpKey.currentState?.validate();
          },
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              validationForm['curp'] = false;
              return 'CURP obligatoria';
            }
            final pattern = RegExp(r'^[A-Z]{4}\d{6}[A-Z]{6}\d{2}$');
            if (!pattern.hasMatch(value)) {
              validationForm['curp'] = false;
              return 'CURP no válido';
            }
            validationForm['curp'] = true;
            return null;
          },
        ),
      ),
  );
}

  Widget _buildNextButton() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _currentStep > 0
              ? ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    setState(() {
                      _currentStep -= 1;
                    });
                  },
                  child: const Text('Anterior'),
                )
              : const SizedBox.shrink(),
        ),
        Expanded(
          child: (_userType == 'Cliente' && _currentStep == 1) ||
                  (_userType == 'Repartidor' && _currentStep == 2)
              ? ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Registrar'),
                )
              : ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    setState(() {
                      _currentStep += 1;
                    });
                  },
                  child: const Text('Siguiente'),
                ),
        ),
      ],
    ),
  );
}
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}