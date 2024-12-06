import 'package:flutter/material.dart';
import 'package:mobile_favor/config/alerts.dart';
import 'package:mobile_favor/config/error_types.dart';
import 'package:mobile_favor/config/utils.dart';
import '../customer/entity/history.entity.dart';
import '../customer/order_details.dart';
import '../customer/service/favor.service.dart';

class HistoryCourier extends StatefulWidget {
  const HistoryCourier({super.key});

  @override
  State<HistoryCourier> createState() => _HistoryCourierState();
}

class _HistoryCourierState extends State<HistoryCourier> {
  List<HistoryItemEntity> historyOrder = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCourierHistory();
  }

  Future<void> fetchCourierHistory() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = FavorService(context);
      final courier_id = await getStorageNoUser();
      if (courier_id == null) {
        showErrorAlert(context, 'No se pudo obtener la información del usuario');
        return;
      }
      final response = await service.getListCourierHistory(courier_id);
      if (response.error) {
        showErrorAlert(context, getErrorMessages(response.message));
        return;
      }
      setState(() {
        historyOrder.clear();
        for (var item in response.data) {
          historyOrder.add(HistoryItemEntity.fromJson(item));
        }
      });
    } catch (error) {
      print('Error fetching courier history: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String replaceStatus(String status) {
    switch (status) {
      case 'Pending':
        return 'Pendiente';
      case 'Canceled':
        return 'Cancelado';
      case 'Finished':
        return 'Finalizado';
      default:
        return '';
    }
  }

  Color replaceColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Canceled':
        return Colors.red;
      case 'Finished':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de pedidos'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
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
          Column(
            children: [
              const SizedBox(height: 10),
              Image.asset(
                './assets/history.webp',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : historyOrder.isEmpty
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${order.products.toString()} producto(s)",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                order.created_at.substring(0, 19).replaceAll('T', ' '),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                replaceStatus( order.status ),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: replaceColor( order.status ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetails(no_order: order.no_order),
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