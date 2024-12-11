import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_favor/utils/app_colors.dart';
import 'package:mobile_favor/navigation/customer/service/favor.service.dart';
import 'package:mobile_favor/navigation/customer/entity/order.entity.dart';

import '../../config/alerts.dart';
import '../../config/error_types.dart';
import '../../config/utils.dart';
import '../../kernel/widget/canceled_favor.dart';
import '../../kernel/widget/chat.dart';
import '../../kernel/widget/image_dialog.dart';
import '../../kernel/widget/location_preview.dart';
import '../../kernel/widget/success_favor.dart';
import '../../kernel/widget/wave_painter.dart';

class FavorProgressCustomer extends StatefulWidget {
  const FavorProgressCustomer({super.key});

  @override
  State<FavorProgressCustomer> createState() => _FavorProgressCustomerState();
}

class _FavorProgressCustomerState extends State<FavorProgressCustomer> {
  final bool _isExpanded = false;
  bool _isLoading = true; // Variable para controlar el estado de carga
  late FavorService _favorService;
  late String no_user;
  OrderPreviewEntity? _orderDetails;
  SSEOrderMessage? _orderStatus;
  Timer? _timer;
  Duration _remainingTime = const Duration(hours: 2);
  String _status = 'Cancelado';

  @override
  void initState() {
    super.initState();
    (() async {
      no_user = await getStorageNoUser() ?? '';
    })();
    _favorService = FavorService(context);
    _fetchOrderDetails();
    _startTimer();
  }

  void _fetchOrderDetails() async {
    final idFavor = await getStorageNoOrder() ?? '';
    final details = await _favorService.getDetailsFavor(idFavor);
    if (details.error) {
      showErrorAlert(context, getErrorMessages(details.message));
    } else {
      setState(() {
        _orderDetails = OrderPreviewEntity.fromJson(details.data);
        _isLoading =
            false; // Cambia el estado de carga a false cuando los datos se hayan cargado
      });

      await for (final status in _favorService.favorStatus(idFavor)) {
        setState(() {
          _orderStatus = status;
          _status = _orderStatus!.data.status;
          _remainingTime = const Duration(hours: 2) -
              DateTime.now().difference(
                  DateTime.parse(_orderStatus!.data.order_created_at));
          if (_status == 'Finished' || _status == 'Canceled') {
            _timer?.cancel();
            removeStorageNoOrder();
            if (_status == 'Finished') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessFavor(
                      timeout: _orderStatus!.data.order_created_at),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CanceledFavor(
                      timeout: _orderStatus!.data.order_created_at),
                ),
              );
            }
          }
        });
      }
    }
  }

  // Método para obtener el icono según el tipo de vehículo
  IconData _getVehicleIcon(String? vehicleType) {
    final Map<String, IconData> vehicleIcons = {
      'Carro': Icons.directions_car,
      'Moto': Icons.motorcycle,
      'Bicicleta': Icons.pedal_bike,
      'Scooter': Icons.electric_scooter,
      'Caminando': Icons.directions_walk,
      'Otro': Icons.more_horiz,
    };

    return vehicleIcons[vehicleType] ?? Icons.directions_car;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      body: _isLoading // Muestra el loader si _isLoading es true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: screenHeight,
                    child: CustomPaint(
                      painter: WavePainter(context: context, waveHeight: 200),
                      child: Container(),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Seguimiento del pedido',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                Badge(
                                  label: Text(
                                      _status.contains('In shopping')
                                          ? 'Proceso de compra'
                                          : _status.contains('In delivery')
                                              ? 'Pedido en camino'
                                              : _status.contains('Finished')
                                                  ? 'Pedido entregado'
                                                  : 'Pedido cancelado',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  padding: const EdgeInsets.all(8),
                                  backgroundColor:
                                      _status.contains('In shopping')
                                          ? Colors.orange
                                          : _status.contains('In delivery')
                                              ? Colors.green
                                              : _status.contains('Finished')
                                                  ? Colors.blue
                                                  : Colors.red,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _formatDuration(_remainingTime),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          if (_orderDetails != null) ...[
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        50.0), // Ajusta el valor según sea necesario
                                    child: Image.network(
                                        _orderDetails!.face_url ?? ''),
                                  ),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_orderDetails!.courier_name} ${_orderDetails!.courier_surname}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Repartidor',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 8),
                                          Text(
                                            _orderDetails!.courier_phone ?? '',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LocationPreview(
                                                    text:
                                                        'Ubicación de entrega',
                                                    lat: _orderDetails!
                                                        .place_lat,
                                                    lng: _orderDetails!
                                                        .place_lng,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.remove_red_eye,
                                                    color: Colors.white,
                                                    size: 16),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Ubicación',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ChatScreen(
                                                        chatId: _orderDetails
                                                                ?.no_order ??
                                                            '0',
                                                        no_user: no_user,
                                                        name: _orderDetails
                                                                ?.courier_name ??
                                                            '',
                                                        image: _orderDetails
                                                            ?.face_url)),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                            icon: Icon(Icons.chat,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Icon(
                                  _getVehicleIcon(_orderDetails?.vehicle_type),
                                  size: 100, // Tamaño del ícono
                                  color: Colors.white, // Color del ícono
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Repartidor (${_orderDetails!.vehicle_type})',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      if (_orderDetails?.brand != null)
                                        Text(
                                          _orderDetails?.brand ?? '',
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                      if (_orderDetails?.model != null)
                                        Text(
                                          _orderDetails?.model ?? '',
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                      if (_orderDetails?.vehicle_description !=
                                          null)
                                        Text(
                                          _orderDetails?.vehicle_description ??
                                              '',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      const SizedBox(height: 8),
                                      if (_orderDetails!.license_plate != null)
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                _orderDetails!.license_plate ??
                                                    '',
                                                style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            ImageDialog(
                                              imageUrl:
                                                  _orderDetails!.plate_url ??
                                                      '',
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Image.asset('assets/package.png', width: 150),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: _orderDetails!.deliveryPoints!
                                        .map((point) => _buildLocationItem(true,
                                            point.name, point.lat, point.lng))
                                        .toList(),
                                  ),
                                ),
                                // Productos desplegable
                                ExpansionTile(
                                  title: const Text("Productos"),
                                  backgroundColor: const Color(0xFF6E7E91),
                                  collapsedBackgroundColor:
                                      const Color(0xFF6E7E91),
                                  collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textColor: Colors.white,
                                  collapsedTextColor: Colors.white,
                                  iconColor: Colors.white,
                                  collapsedIconColor: Colors.white,
                                  children: _orderDetails!.products!
                                      .map((product) => ListTile(
                                            title: Text(product.name,
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                            subtitle: Text(product.description,
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Widget _buildLocationItem(
      bool isActive, String text, double lat, double lng) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationPreview(
                      text: text,
                      lat: lat,
                      lng: lng,
                    ),
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isActive ? Colors.grey : const Color(0xFF6E7E91),
                  shape: BoxShape.circle,
                ),
                child: Icon(isActive ? Icons.remove_red_eye : Icons.block,
                    color: Colors.white),
              ),
            ),
          ),
          if (text.isNotEmpty)
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
