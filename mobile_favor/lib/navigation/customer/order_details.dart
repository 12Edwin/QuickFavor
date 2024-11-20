import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isProductsExpanded = false; // Control para expandir/comprimir productos
  bool isFirstLocked = false;
  bool isSecondLocked = true;
  bool isThirdLocked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    const Column(
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
                          '05-07-2024 14:04:00',
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
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                          color: const Color(0xFF5A6E7F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Finalizado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Sección del repartidor centrada con barra verde
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrar horizontalmente
                      crossAxisAlignment: CrossAxisAlignment.center, // Alinear verticalmente en el centro
                      children: [
                        // Imagen del repartidor a la izquierda
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(width: 16),
    
                        // Barra divisoria verde
                        Container(
                          width: 2, // Ancho de la barra
                          height: 80, // Altura que coincida con el contenido
                          color: const Color(0xFF91A4A3), // Color verde de la barra
                        ),
    
                        const SizedBox(width: 16),
    
                        // Información del repartidor a la derecha
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Juan Rodrigo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                            Text(
                              'Repartidor',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF91A4A3),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Completado en',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                            Text(
                              '40 min / 120 min',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                      children: [
                        // Primer botón
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFirstLocked = !isFirstLocked;
                                });
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xFFA5C3C3),
                                child: Icon(
                                  isFirstLocked ? Icons.visibility : Icons.block,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'San Antonio',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF91A4A3),
                              ),
                            ),
                          ],
                        ),
                        // Segundo botón
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSecondLocked = !isSecondLocked;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFFA5C3C3),
                            child: Icon(
                              isSecondLocked ? Icons.block : Icons.visibility,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Tercer botón
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isThirdLocked = !isThirdLocked;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFFA5C3C3),
                            child: Icon(
                              isThirdLocked ? Icons.block : Icons.visibility,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                              children: [
                                ProductItem(
                                  number: 1,
                                  name: '1 Lt de aceite',
                                  details: 'Aceite 123 de litro',
                                  onTap: () => showProductModal(
                                    context,
                                    '1 Lt de aceite',
                                    'Aceite de oliva extra virgen',
                                    'Cantidad: 1',
                                  ),
                                ),
                                ProductItem(
                                  number: 2,
                                  name: '1 kg de jitomate',
                                  details: 'Jitomate maduro',
                                  onTap: () => showProductModal(
                                    context,
                                    '1 kg de jitomate',
                                    'Jitomate rojo maduro, ideal para salsas.',
                                    'Cantidad: 1 kg',
                                  ),
                                ),
                                ProductItem(
                                  number: 3,
                                  name: '1 kg de arroz',
                                  details: '',
                                  onTap: () => showProductModal(
                                    context,
                                    '1 kg de arroz',
                                    'Arroz blanco para preparar comidas.',
                                    'Cantidad: 1 kg',
                                  ),
                                ),
                                ProductItem(
                                  number: 4,
                                  name: '3 cebollas',
                                  details: 'Cebollas moradas',
                                  onTap: () => showProductModal(
                                    context,
                                    '3 cebollas',
                                    'Cebollas moradas grandes.',
                                    'Cantidad: 3 unidades',
                                  ),
                                ),
                                ProductItem(
                                  number: 5,
                                  name: '3 paquetes de galletas Marías',
                                  details: 'Si no hay, otro tipo',
                                  onTap: () => showProductModal(
                                    context,
                                    '3 paquetes de galletas Marías',
                                    'Galletas dulces ideales para acompañar con café.',
                                    'Cantidad: 3 paquetes',
                                  ),
                                ),
                              ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subtotal:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Costo de servicio:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                          ],
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$300',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\$100',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\$400',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3E50),
                              ),
                            ),
                          ],
                        ),
                        // Botón de Factura con estilo
                        GestureDetector(
                          onTap: () {
                            // Acción para el botón de Factura
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
                                        Icons.visibility,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Factura',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF2D3E50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  // Método para mostrar el modal con la información del producto
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
}

class ProductItem extends StatelessWidget {
  final int number;
  final String name;
  final String details;
  final VoidCallback onTap;

  const ProductItem({
    Key? key,
    required this.number,
    required this.name,
    required this.details,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '$number. ',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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
