import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_favor/navigation/customer/service/favor.service.dart';

import '../../config/alerts.dart';
import '../../config/error_types.dart';
import '../../config/utils.dart';
import '../../kernel/widget/location_preview.dart';
import 'entity/order.entity.dart';

class OrderDetails extends StatefulWidget {
  final String no_order;

  const OrderDetails({Key? key, required this.no_order}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isProductsExpanded = false;
  bool isFirstLocked = false;
  bool isSecondLocked = true;
  bool isThirdLocked = true;
  bool _isLoading = true;
  OrderPreviewEntity? orderDetails;
  late final String role;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
    (() async =>{
      role = await getStorageRole() ?? 'Customer'
    })();
  }

  Future<void> _fetchOrderDetails() async {
    final service = FavorService(context);
    try {
      final response = await service.getDetailsFavor(widget.no_order);
      if (response.error) {
        showErrorAlert(context, getErrorMessages(response.message));
        return;
      }
      setState(() {
        orderDetails = OrderPreviewEntity.fromJson(response.data);
      });
    } catch (error) {
      print('Error fetching order details: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String mapOrderStatus(String status) {
    switch (status) {
      case 'Finished':
        return 'Finalizado';
      case 'Canceled':
        return 'Cancelado';
      case 'Pending':
        return 'Pendiente';
      default:
        return 'Desconocido';
    }
  }

  Color mapOrderStatusColor(String status) {
    switch (status) {
      case 'Finished':
        return const Color(0xFF5A6E7F);
      case 'Canceled':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  int _calculateMinutesTaken(String? createdAt, String? finishedAt) {
    if (finishedAt == null || createdAt == null) return 0;
    final created = DateTime.parse(createdAt);
    final finished = DateTime.parse(finishedAt);
    return finished.difference(created).inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3E50),
        automaticallyImplyLeading: false,
        toolbarHeight: 15.0,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Encabezado
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D3E50),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Este es tu pedido',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                orderDetails?.order_created_at != null ? DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(orderDetails!.order_created_at)) : '',
                                style: TextStyle(
                                  color: Color(0xFFCBDAD5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Contenedor completo
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Botón "Finalizado" alineado arriba a la derecha
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: mapOrderStatusColor(orderDetails?.status ?? ''),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                mapOrderStatus(orderDetails?.status ?? ''),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Sección del repartidor centrada con barra verde
                          orderDetails?.courier_name != null ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Imagen del repartidor a la izquierda
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blue[100],
                                backgroundImage: role == 'Courier' ? const AssetImage('assets/profile.png') : NetworkImage( orderDetails?.face_url ?? ''),
                              ),
                              const SizedBox(width: 16),
                              // Barra divisoria verde
                              Container(
                                width: 2,
                                height: 80,
                                color: const Color(0xFF91A4A3),
                              ),
                              const SizedBox(width: 16),
                              // Información del repartidor a la derecha
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200, // Ajusta el ancho según sea necesario
                                    child: Text(
                                      role == 'Courier' ? '${orderDetails?.customer_name ?? ''} ${orderDetails?.customer_surname ?? ''}' : '${orderDetails?.courier_name ?? ''} ${orderDetails?.courier_surname ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D3E50),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    role == 'Courier' ? 'Cliente' : 'Repartidor',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF91A4A3),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if(orderDetails?.status == 'Finished') ...[
                                  const Text(
                                    'Completado en',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                  Text(
                                    '${_calculateMinutesTaken(orderDetails!.order_created_at, orderDetails!.order_finished_at)} / 120 min',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  )]
                                ],
                              ),
                            ],
                          ):
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'No hubo asignación de repartidor',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2D3E50),
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Barra de "Direcciones de recolección"
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: const BoxDecoration(
                              color: Color(0xFF5A6E7F),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            width: double.infinity,
                            child: const Text(
                              'Direcciones de recolección',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Botones de direcciones
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orderDetails?.deliveryPoints?.map((point) {
                              return SizedBox(
                                width: 100,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LocationPreview(
                                              text: point.name,
                                              lat: point.lat,
                                              lng: point.lng,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Color(0xFFA5C3C3),
                                        child: Icon(
                                          Icons.location_on,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      point.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF91A4A3),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList() ?? [],
                          ),
                          const SizedBox(height: 20),
                          // Sección de "Productos" con funcionalidad expandible
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isProductsExpanded = !isProductsExpanded;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF5A6E7F),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  width: double.infinity,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Productos',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isProductsExpanded) ...[
                                  const SizedBox(height: 16),
                                  // Lista de productos
                                  Column(
                                    children: orderDetails?.products?.map((product) {
                                      return ProductItem(
                                        number: product.amount,
                                        name: product.name,
                                        details: product.description,
                                        onTap: () => showProductModal(
                                          context,
                                          product.name,
                                          product.description,
                                          '${product.amount}',
                                        ),
                                      );
                                    }).toList() ?? [],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                // Barra inferior verde con el ícono de flecha que queda abajo de los productos
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD9E6E5),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  width: double.infinity,
                                  child: Center(
                                    child: Icon(
                                      isProductsExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Sección de Subtotal, Costo de Servicio, Total y Botón "Factura"
                          orderDetails?.status == 'Finished' ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Subtotal:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Costo de servicio:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${orderDetails?.cost ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  const Text(
                                    '\$100',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '\$${(orderDetails?.cost ?? 0) + 100}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                ],
                              ),
                              // Botón de Factura con estilo
                              GestureDetector(
                                onTap: () {
                                  showInvoiceModal(context, orderDetails?.receipt_url ?? '');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: const Color(0xFFD9E6E5),
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 10.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blueAccent,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.receipt_long,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ):
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'El pedido no contiene información de costos',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2D3E50),
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
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

  void showProductModal(BuildContext context, String title, String description, String quantity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descripción: $description'),
              const SizedBox(height: 8),
              Text('Cantidad: $quantity'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showInvoiceModal(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Factura'),
          content: Image.network(url),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final int number;
  final String name;
  final String details;
  final VoidCallback onTap;

  const ProductItem({
    super.key,
    required this.number,
    required this.name,
    required this.details,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (details.isNotEmpty)
                    Text(
                      '($details)',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.visibility,
              color: Color(0xFF2D3E50),
            ),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}