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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).primaryColor,
        ),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(80),
              bottomRight: Radius.circular(80),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Notificaciones de favores',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Image.asset('assets/box.png', width: 250, height: 250),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : notifications.isEmpty
                        ? Center(child: Image.asset('assets/empty2.png', width: 200, height: 200))
                        : ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: const Color(0xFF6A9F9F).withOpacity(0.5),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      width: 10,
                                      color: const Color(0xFF6A9F9F),
                                    ),
                                    title: Text("${notification.amount.toString()} producto(s)"),
                                    subtitle: Text(_formatDate(notification.created_at)),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NotificationDetail(order_id: notification.order_id),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF6A9F9F),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Icon(Icons.remove_red_eye),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}