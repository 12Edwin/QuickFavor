import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/error_types.dart';
import 'package:mobile_favor/kernel/widget/collection-picker.dart';
import 'package:mobile_favor/navigation/customer/entity/order.entity.dart';
import 'package:mobile_favor/navigation/customer/service/favor.service.dart';
import 'package:mobile_favor/utils/app_colors.dart';

import '../../config/utils.dart';
import 'component/search_couriers.dart';

class CreateOrder extends StatefulWidget {
  final double? lat;
  final double? lng;
  final String? address;

  const CreateOrder({super.key, this.lat, this.lng, this.address});

  @override
  State<CreateOrder> createState() => _LoginState();
}

class _LoginState extends State<CreateOrder> {
  final List<Products> products = [];
  final _nameKey = GlobalKey<FormState>();
  final _descriptionKey = GlobalKey<FormState>();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _address3Controller = TextEditingController();
  late LatLng? _coordinates1;
  LatLng? _coordinates2;
  LatLng? _coordinates3;

  @override
  void initState() {
    super.initState();
    if (widget.lat != null && widget.lng != null) {
      _coordinates1 = LatLng(widget.lat!, widget.lng!);
      _address1Controller.text = widget.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Crear pedido'),
        automaticallyImplyLeading: widget.address != null,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: _searchForCourier,
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
                  fontSize: 14,
                ),
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
                      hintText: 'Nueva Dirección',
                      controller: _address1Controller,
                      coordinates: _coordinates1,
                      showClear: false,
                      updateCoordinates: updateCoordinates1,
                      icon: _address1Controller.text.isEmpty
                          ? Icons.add_circle
                          : Icons.check_circle,
                    ),
                    const SizedBox(height: 40),
                    _buildIconWithInput(
                      hintText: 'Nueva Dirección',
                      controller: _address2Controller,
                      coordinates: _coordinates2,
                      showClear: true,
                      clearFunction: () {
                        setState(() {
                          _address2Controller.clear();
                          _coordinates2 = null;
                        });
                      },
                      updateCoordinates: updateCoordinates2,
                      icon: _address2Controller.text.isEmpty
                          ? Icons.add_circle
                          : Icons.check_circle,
                    ),
                    const SizedBox(height: 40),
                    _buildIconWithInput(
                      hintText: 'Nueva Dirección',
                      controller: _address3Controller,
                      coordinates: _coordinates3,
                      showClear: true,
                      clearFunction: () {
                        setState(() {
                          _address3Controller.clear();
                          _coordinates3 = null;
                        });
                      },
                      updateCoordinates: updateCoordinates3,
                      icon: _address3Controller.text.isEmpty
                          ? Icons.add_circle
                          : Icons.check_circle,
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
                            child: products.isEmpty
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
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
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
                                                product.name,
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
                                                    producto: product);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  products.removeAt(index);
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
    required TextEditingController controller,
    required LatLng? coordinates,
    required bool showClear,
    Function()? clearFunction,
    required Function(LatLng) updateCoordinates,
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
              const SizedBox(width: 40),
              Expanded(
                child: TextField(
                  onTap: () {
                    _pickCollectionLocation(
                        coordinates, controller, updateCoordinates);
                  },
                  readOnly: true,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: isPrimaryColor ? Colors.white : Colors.black,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: isPrimaryColor ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (showClear)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearFunction,
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

  void _showProductModal(BuildContext context, {Products? producto}) {
    final TextEditingController nombreController =
        TextEditingController(text: producto != null ? producto.name : '');
    final TextEditingController descripcionController = TextEditingController(
        text: producto != null ? producto.description : '');
    int cantidad = producto != null ? producto.amount : 1;

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
                    Form(
                      key: _nameKey,
                      child: TextFormField(
                        controller: nombreController,
                        validator: validateName,
                        onChanged: (value) {
                          _nameKey.currentState!.validate();
                        },
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
                    ),
                    const SizedBox(height: 10),
                    // Controles para cantidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón para disminuir cantidad
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
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
                    Form(
                      key: _descriptionKey,
                      child: TextFormField(
                        controller: descripcionController,
                        validator: validateDescription,
                        onChanged: (value) {
                          _descriptionKey.currentState!.validate();
                        },
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
                    if (!_nameKey.currentState!.validate() ||
                        !_descriptionKey.currentState!.validate()) {
                      showErrorAlert(context,
                          'Por favor, rellena los campos correctamente');
                      return;
                    }
                    setState(() {
                      if (producto != null) {
                        // Editar producto existente
                        final index =
                            products.indexWhere((p) => p.id == producto.id);
                        if (index != -1) {
                          products[index] = Products(
                              id: producto.id,
                              name: nombreController.text,
                              amount: cantidad,
                              description: descripcionController.text);
                        }
                      } else {
                        // Agregar nuevo producto
                        products.add(Products(
                            id: products.length + 1,
                            name: nombreController.text,
                            amount: cantidad,
                            description: descripcionController.text));
                      }
                    });
                    Navigator.pop(context);
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

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'La descripción no puede estar vacía';
    } else if (value.length < 10) {
      return 'La descripción debe tener al menos 10 caracteres';
    } else if (value.length > 200) {
      return 'La descripción no puede tener más de 200 caracteres';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre no puede estar vacío';
    } else if (value.length < 5) {
      return 'El nombre debe tener al menos 5 caracteres';
    } else if (value.length > 100) {
      return 'El nombre no puede tener más de 100 caracteres';
    }
    return null;
  }

  Future<void> _searchForCourier() async {
    if (_coordinates1 == null) {
      showWarningAlert(context,
          'Por favor, selecciona al menos una dirección de recolección');
      return;
    }
    if (products.isEmpty) {
      showWarningAlert(context, 'Por favor, agrega al menos un producto');
      return;
    }
    final String? noOrder = await getStorageNoOrder();
    if (noOrder != null) {
      showWarningAlert(context, 'Ya tienes un pedido en curso');
      return;
    }

    final LatLng customerCoordinates = await getLatLngFromStorageOrCurrent();
    final String idCustomer = await getStorageNoUser() ?? '';

    final order = CreateOrderEntity(
      id_customer: idCustomer,
      products: products,
      customer_direction: CustomerDirection(
        name: 'Dirección de entrega',
        lat: customerCoordinates.latitude,
        lng: customerCoordinates.longitude,
      ),
      collection_points: [
        CollectionPoints(
          name: _address1Controller.text,
          lat: _coordinates1!.latitude,
          lng: _coordinates1!.longitude,
        ),
        if (_coordinates2 != null)
          CollectionPoints(
            name: _address2Controller.text,
            lat: _coordinates2!.latitude,
            lng: _coordinates2!.longitude,
          ),
        if (_coordinates3 != null)
          CollectionPoints(
            name: _address3Controller.text,
            lat: _coordinates3!.latitude,
            lng: _coordinates3!.longitude,
          ),
      ],
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchCouriers(order: order),
      ),
    );
  }

  void _pickCollectionLocation(LatLng? coordinates,
      TextEditingController controller, Function(LatLng) updateCoordinates) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionPicker(
          initialLat: coordinates?.latitude,
          initialLng: coordinates?.longitude,
          onLocationPicked: (double lat, double lng, String address) {
            setState(() {
              LatLng newCoordinates = LatLng(lat, lng);
              updateCoordinates(newCoordinates);
              controller.text = address;
            });
          },
        ),
      ),
    );
  }

  void updateCoordinates1(LatLng coordinates) {
    _coordinates1 = coordinates;
  }

  void updateCoordinates2(LatLng coordinates) {
    _coordinates2 = coordinates;
  }

  void updateCoordinates3(LatLng coordinates) {
    _coordinates3 = coordinates;
  }
}
