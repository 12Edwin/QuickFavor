import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_favor/config/error_types.dart';
import 'package:mobile_favor/navigation/courier/service/courier.service.dart';
import 'package:mobile_favor/navigation/courier/entity/notification.entity.dart';

import '../../config/alerts.dart';
import '../../config/utils.dart';
import 'notification_detail.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationEntity> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final CourierService favorService = CourierService(context);
    final String? courierId = await getStorageNoUser();
    final response = await favorService.readNotifications(courierId ?? '');
    if (response.error) {
      showErrorAlert(context, getErrorMessages(response.message));
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      notifications = (response.data as List)
          .map((json) => NotificationEntity.fromJson(json))
          .toList();
      isLoading = false;
    });
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(parsedDate);
  }

  List<Map<String, dynamic>> notification = [
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
        title: const Text('Notificaciones'),
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
                './assets/notificationLogo.png',
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
                    child: notification.isEmpty
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
                            itemCount: notification.length,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              final order = notification[index];
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
                                                      NotificationDetail(
                                                          order_id:
                                                              order['id']),
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
