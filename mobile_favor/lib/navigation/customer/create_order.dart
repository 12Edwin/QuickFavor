import 'package:flutter/material.dart';
import 'package:mobile_favor/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _LoginState();
}

class _LoginState extends State<CreateOrder> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

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
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.45,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Direcciones de Recolección',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Pedir',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60), // Aumenta la altura del espacio
                    // Primer input con ícono de check_circle y edit_note como botón
                    _buildIconWithInput(
                      hintText: 'San Antonio Smog Check',
                      icon: Icons.check_circle,
                      showEditIcon: true,
                    ),
                    const SizedBox(
                        height: 40), // Aumenta el espacio entre los inputs
                    // Segundo input con ícono add_circle sin edit_note
                    _buildIconWithInput(
                      hintText: 'Nueva Dirección',
                      icon: Icons.add_circle,
                      showEditIcon: false,
                    ),
                    const SizedBox(
                        height: 40), // Aumenta el espacio entre los inputs
                    // Tercer input con ícono add_circle sin edit_note
                    _buildIconWithInput(
                      hintText: 'Nueva Dirección',
                      icon: Icons.add_circle,
                      showEditIcon: false,
                    ),
                    const SizedBox(
                        height:
                            40), // Espacio entre el último input y el contenedor
                    // Nuevo contenedor que abarca casi todo el ancho y largo restante
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.9, // Casi todo el ancho
                      height: MediaQuery.of(context).size.height *
                          0.5, // Casi todo el largo restante
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3), // Baja opacidad
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(
                          20.0), // Espacio interno opcional
                      child: Column(
                        children: [
                          const SizedBox(
                              height:
                                  40), // Aumenta el espacio dentro del contenedor
                          // Input con color primary y el ícono a la derecha
                          _buildIconWithInput(
                            hintText: 'Lista de productos',
                            icon: Icons.add_circle,
                            showEditIcon: false,
                            isPrimaryColor: true, // Ahora acepta este parámetro
                          ),
                          const SizedBox(
                              height: 40), // Espacio entre el input y la imagen
                          // Imagen centrada
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/empty2.png', // Ruta de la imagen en assets
                                    width: 150, // Ancho de la imagen
                                    height: 150, // Alto de la imagen
                                  ),
                                  const SizedBox(height: 20),
                                  // Texto centrado debajo de la imagen
                                  const Text(
                                    'Aún no hay productos para este pedido',
                                    style: TextStyle(
                                      fontSize:
                                          14, // Tamaño de letra más pequeño
                                      color: Colors.black, // Color del texto
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modificación para aceptar isPrimaryColor y cambiar el color de fondo
  Widget _buildIconWithInput({
    required String hintText,
    required IconData icon,
    required bool showEditIcon,
    bool isPrimaryColor =
        false, // Nuevo parámetro para cambiar el color de fondo
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // El input con borde redondeado
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isPrimaryColor
                ? Theme.of(context)
                    .primaryColor // Usa primaryColor si se especifica
                : Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 60), // Espacio para el botón
              // Input de texto
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: isPrimaryColor ? Colors.white : Colors.black,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: isPrimaryColor ? Colors.white : Colors.black,
                  ),
                ),
              ),
              // Mostrar el ícono de edición como botón solo si showEditIcon es true
              if (showEditIcon)
                IconButton(
                  icon: Icon(
                    Icons.edit_note,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: 24,
                  ),
                  onPressed: () {
                    // Acción cuando se presiona el botón de editar
                    print("Edit button pressed for $hintText");
                  },
                ),
            ],
          ),
        ),
        // Botón redondeado que sobresale del input
        Positioned(
          top: -8, // Para que sobresalga verticalmente
          left: -15, // Para moverlo hacia la izquierda
          child: Container(
            width: 60,
            height: 60, // Tamaño más grande del círculo
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Cambiar el color de fondo a blanco
            ),
            child: IconButton(
              icon: Icon(
                icon,
                color: AppColors.info, // Color info
              ),
              iconSize: 40, // Tamaño del ícono más grande
              onPressed: () {
                // Acción cuando se presiona el botón
                print("$hintText button pressed");
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_emailController.text == 'courier@gmail.com') {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'courier');
      Navigator.pushNamed(context, '/navigation');
    } else if (_emailController.text == 'customer@gmail.com') {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'customer');
      Navigator.pushNamed(context, '/navigation');
    }
  }
}
