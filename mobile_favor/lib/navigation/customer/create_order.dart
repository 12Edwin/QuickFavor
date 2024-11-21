import 'package:flutter/material.dart';
import 'package:mobile_favor/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _LoginState();
}

class _LoginState extends State<CreateOrder> {
  final List<Map<String, dynamic>> productos = [
    {
      'id': 1,
      'nombre': 'Aceite',
      'cantidad': 1,
      'descripcion': '1 Lt de aceite 123',
    },
  ];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Direcciones de Recolección',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: _onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
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
                    const SizedBox(height: 60),
                    _buildIconWithInput(
                      hintText: 'San Antonio Smog Check',
                      icon: Icons.check_circle,
                      showEditIcon: true,
                    ),
                    const SizedBox(height: 40),
                    _buildIconWithInput(
                      hintText: 'Nueva Dirección',
                      icon: Icons.add_circle,
                      showEditIcon: false,
                    ),
                    const SizedBox(height: 40),
                    _buildIconWithInput(
                      hintText: 'Nueva Dirección',
                      icon: Icons.add_circle,
                      showEditIcon: false,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text(
                                    'Lista de productos',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    // Llama a la función para abrir el modal
                                    _showProductModal(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: productos.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/empty2.png',
                                        width: 150,
                                        height: 150,
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Aún no hay productos para este pedido',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    itemCount: productos.length,
                                    itemBuilder: (context, index) {
                                      final producto = productos[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                producto['nombre'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                _showProductModal(context,
                                                    producto: producto);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  productos.removeAt(index);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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

  Widget _buildIconWithInput({
    required String hintText,
    required IconData icon,
    required bool showEditIcon,
    bool isPrimaryColor = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color:
                isPrimaryColor ? Theme.of(context).primaryColor : Colors.white,
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
              const SizedBox(width: 60),
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
              if (showEditIcon)
                IconButton(
                  icon: Icon(
                    Icons.edit_note,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: 24,
                  ),
                  onPressed: () {
                    print("Edit button pressed for $hintText");
                  },
                ),
            ],
          ),
        ),
        Positioned(
          top: -8,
          left: -15,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              icon: Icon(
                icon,
                color: AppColors.info,
              ),
              iconSize: 40,
              onPressed: () {
                print("$hintText button pressed");
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showProductModal(BuildContext context,
      {Map<String, dynamic>? producto}) {
    final TextEditingController nombreController =
        TextEditingController(text: producto != null ? producto['nombre'] : '');
    final TextEditingController descripcionController = TextEditingController(
        text: producto != null ? producto['descripcion'] : '');
    int cantidad = producto != null ? producto['cantidad'] : 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                producto != null ? 'Editar producto' : 'Nuevo producto',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(thickness: 1, color: Colors.grey),
                    const SizedBox(height: 10),
                    // Input para el nombre del producto
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        hintText: 'Nombre del producto',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Controles para cantidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón para disminuir cantidad
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white),
                            onPressed: () {
                              if (cantidad > 1) {
                                setModalState(() {
                                  cantidad--;
                                });
                              }
                            },
                          ),
                        ),
                        // Muestra la cantidad actual
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$cantidad',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        // Botón para aumentar cantidad
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              setModalState(() {
                                cantidad++;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Input para la descripción
                    TextField(
                      controller: descripcionController,
                      decoration: InputDecoration(
                        hintText: 'Descripción',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              actions: [
                // Botón para cerrar el modal
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                // Botón para agregar o actualizar producto
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (producto != null) {
                        // Editar producto existente
                        final index = productos
                            .indexWhere((p) => p['id'] == producto['id']);
                        if (index != -1) {
                          productos[index] = {
                            'id': producto['id'],
                            'nombre': nombreController.text,
                            'cantidad': cantidad,
                            'descripcion': descripcionController.text,
                          };
                        }
                      } else {
                        // Agregar nuevo producto
                        productos.add({
                          'id': productos.length + 1,
                          'nombre': nombreController.text,
                          'cantidad': cantidad,
                          'descripcion': descripcionController.text,
                        });
                      }
                    });
                    Navigator.pop(context);
                    print(
                        "${producto != null ? 'Producto editado' : 'Producto añadido'}: ${nombreController.text}");
                  },
                  child: Text(
                    producto != null ? 'Guardar cambios' : 'Agregar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
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
