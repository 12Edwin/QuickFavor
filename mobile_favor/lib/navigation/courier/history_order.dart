import 'package:flutter/material.dart';
import 'order_details.dart'; // Asegúrate de importar esta vista

class HistoryOrderCourier extends StatefulWidget {
  const HistoryOrderCourier({super.key});

  @override
  State<HistoryOrderCourier> createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrderCourier> {
  // Lista de pedidos simulada
  List<Map<String, dynamic>> historyOrder = [
    {
      'id': 'ORD01',
      'fecha': '05-07-2024 14:04:00',
      'cantidad': 10,
    },
    {
      'id': 'ORD02',
      'fecha': '04-07-2024 12:00:00',
      'cantidad': 7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de pedidos'),
      ),
      body: Stack(
        children: [
          // Contenedor azul en el fondo
          Positioned(
            top: -screenWidth * 0.809,
            left: (screenWidth - (screenWidth * 1.5)) / 2,
            child: Container(
              width: screenWidth * 1.5,
              height: screenWidth * 1.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF34344E),
              ),
            ),
          ),
          // Contenido principal
          Column(
            children: [
              const SizedBox(height: 10),
              // Imagen superior
              Image.asset(
                './assets/history.webp',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // Card inferior para la lista
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: historyOrder.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  './assets/empty2.png',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Aún no hay pedidos en esta cuenta",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: historyOrder.length,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              final order = historyOrder[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                color: const Color(0xFFDCE8E8),
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Información del pedido
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${order['cantidad']} productos",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            order['fecha'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Número de orden y el ícono de vista
                                      Row(
                                        children: [
                                          Text(
                                            order['id'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetailsCourier(
                                                    orderId: order['id'],
                                                    fecha: order['fecha'],
                                                    cantidad: order['cantidad'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.purple,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
