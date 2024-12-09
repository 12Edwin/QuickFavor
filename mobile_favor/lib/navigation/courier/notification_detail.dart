import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_favor/navigation/courier/entity/notification.entity.dart';
import 'package:mobile_favor/navigation/courier/service/courier.service.dart';
import 'package:mobile_favor/navigation/navigation.dart';
import 'package:mobile_favor/utils/app_colors.dart';
import 'package:mobile_favor/navigation/customer/service/favor.service.dart';
import 'package:mobile_favor/navigation/customer/entity/order.entity.dart';

import '../../config/alerts.dart';
import '../../config/error_types.dart';
import '../../config/utils.dart';
import '../../kernel/widget/canceled_favor.dart';
import '../../kernel/widget/location_preview.dart';
import '../../kernel/widget/photo_picker.dart';
import '../../kernel/widget/success_favor.dart';
import '../../kernel/widget/wave_painter.dart';

class NotificationDetail extends StatefulWidget {
  final String order_id;

  const NotificationDetail({super.key, required this.order_id});

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  final bool _isExpanded = false;
  final bool _isExpanded2 = false;
  bool _isLoading = true; // Variable para controlar el estado de carga
  late FavorService _favorService;
  OrderPreviewEntity? _orderDetails;
  SSEOrderMessage? _orderStatus;
  Timer? _timer;
  Duration _remainingTime = const Duration(hours: 2);
  final String _status = 'Cancelado';

  final TextEditingController _receiptPhotoController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _keyMount = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _favorService = FavorService(context);
    _fetchOrderDetails();
    _startTimer();
  }

  void _fetchOrderDetails() async {
  final idFavor = widget.order_id;
  final details = await _favorService.getDetailsFavor(idFavor);
  if (details.error) {
    showErrorAlert(context, getErrorMessages(details.message));
  } else {
    setState(() {
      _orderDetails = OrderPreviewEntity.fromJson(details.data);
      final DateTime orderCreatedAt = DateTime.parse(_orderDetails!.order_created_at);
      final DateTime targetTime = orderCreatedAt.add(const Duration(minutes: 10));
      final Duration remainingTime = targetTime.difference(DateTime.now());
      _remainingTime = remainingTime.isNegative ? Duration.zero : remainingTime;
      _isLoading = false;
    });
  }
}

  void _changeState(String state) async {
    final idFavor = await getStorageNoOrder() ?? '';

    if(state.contains('Reject')){
      _rejectFavor();
    }else{
      _acceptFavor();
    }

  }

  void _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _rejectFavor();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Navigation(tap: 1),
            ),
          );
        }
      });
    });
  }

  void _rejectFavor() async {
    final service = CourierService(context);
    Position position = await getCurrentLocation();
    final AcceptFavorEntity payload = AcceptFavorEntity(
      order_id: widget.order_id,
      courier_id: await getStorageNoUser() ?? '',
      location: Location(lat: position.latitude, lng: position.longitude),
    );
    final response = await service.rejectFavor(payload);
    if (response.error) {
      showErrorAlert(context, getErrorMessages(response.message));
    }else{
      Navigator.pushReplacement(context,
        MaterialPageRoute(
          builder: (context) => const Navigation(tap: 1),
        ),
      );
    }
  }

  void _acceptFavor() async {
    final service = CourierService(context);
    Position position = await getCurrentLocation();
    final AcceptFavorEntity payload = AcceptFavorEntity(
      order_id: widget.order_id,
      courier_id: await getStorageNoUser() ?? '',
      location: Location(lat: position.latitude, lng: position.longitude),
    );
    final response = await service.acceptFavor(payload);
    if (response.error) {
      showErrorAlert(context, getErrorMessages(response.message));
    }else{
      await addStorageNoOrder(payload.order_id);
      showSuccessAlert(context, 'Pedido aceptado correctamente');
      Navigator.pushReplacementNamed(context, '/navigation');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return an error
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return an error
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, return an error
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
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
      appBar: AppBar(
        title: const Text(
                'Detalles del pedido',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
      ),
      body: _isLoading // Muestra el loader si _isLoading es true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: screenHeight,
                    child: CustomPaint(
                      painter: WavePainter(context: context, waveHeight: 60),
                      child: Container(),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            _formatDuration(_remainingTime),
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
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
                                    borderRadius: BorderRadius.circular(50.0), // Ajusta el valor según sea necesario
                                    child: Image.asset('assets/profile.png'),
                                  ),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_orderDetails!.customer_name} ${_orderDetails!.customer_surname}',
                                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Cliente',
                                        style: TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone, color: Colors.white, size: 16),
                                          const SizedBox(width: 8),
                                          Text(
                                            _orderDetails!.customer_phone ?? '',
                                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Image.asset('assets/box.png', width: 200),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: _orderDetails!.deliveryPoints!.length > 1 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                                    children: _orderDetails!.deliveryPoints!
                                        .map((point) => _buildLocationItem(true, point.name, point.lat, point.lng))
                                        .toList(),
                                  ),
                                ),
                                // Productos desplegable
                                ExpansionTile(
                                  title: const Text("Productos"),
                                  backgroundColor: const Color(0xFF6E7E91),
                                  collapsedBackgroundColor: const Color(0xFF6E7E91),
                                  collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textColor: Colors.white,
                                  collapsedTextColor: Colors.white,
                                  iconColor: Colors.white,
                                  collapsedIconColor: Colors.white,
                                  children: _orderDetails!.products!
                                      .map((product) => ListTile(
                                            title: Text(product.name, style: const TextStyle(color: Colors.white)),
                                            subtitle: Text(product.description, style: const TextStyle(color: Colors.white)),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => confirmAndChangeState('Reject', 'Rechazar'),
                                  icon: const Icon(Icons.cancel, color: Colors.white),
                                  label: const Text('Rechazar', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => confirmAndChangeState('Accept', 'Aceptar'),
                                  icon: const Icon(Icons.check_circle, color: Colors.white),
                                  label: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
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
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}

  Future<void> confirmAndChangeState(String state, String text) async {
  bool? confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación'),
        content: Text('¿Estás seguro de que deseas $text?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );

  if (confirm == true) {
    _changeState(state);
  }
}

  Widget _buildLocationItem(bool isActive, String text, double lat, double lng) {
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
                child: Icon(isActive ? Icons.remove_red_eye : Icons.block, color: Colors.white),
              ),
            ),
          ),
          if (text.isNotEmpty) Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStateButton(IconData icon, bool isActive) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6E7E91) : const Color(0xFFA4B0BD),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildActionButton(IconData icon, String text, FormFieldValidator<String>? validation) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: text,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validation,
      ),
    );
  }
}