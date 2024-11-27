import 'dart:async';
import 'package:flutter/material.dart';
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

class FavorProgressCourier extends StatefulWidget {
  const FavorProgressCourier({super.key});

  @override
  State<FavorProgressCourier> createState() => _FavorProgressCourierState();
}

class _FavorProgressCourierState extends State<FavorProgressCourier> {
  bool _isExpanded = false;
  bool _isExpanded2 = false;
  bool _isLoading = true; // Variable para controlar el estado de carga
  late FavorService _favorService;
  OrderPreviewEntity? _orderDetails;
  SSEOrderMessage? _orderStatus;
  Timer? _timer;
  Duration _remainingTime = Duration(hours: 2);
  String _status = 'Cancelado';

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
    final idFavor = await getStorageNoOrder() ?? '';
    final details = await _favorService.getDetailsFavor(idFavor);
    if (details.error) {
      showErrorAlert(context, getErrorMessages(details.message));
    } else {
      setState(() {
        _orderDetails = OrderPreviewEntity.fromJson(details.data);
        _isLoading = false; // Cambia el estado de carga a false cuando los datos se hayan cargado
      });

      await for (final status in _favorService.favorStatus(idFavor)) {
        setState(() {
          _orderStatus = status;
          _status = _orderStatus!.data.status;
          _remainingTime = const Duration(hours: 2) - DateTime.now().difference(DateTime.parse(_orderStatus!.data.order_created_at));
          if (_status == 'Finished' || _status == 'Canceled') {
            _timer?.cancel();
            removeStorageNoOrder();
            if(_status == 'Finished') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SuccessFavor(timeout: _orderStatus!.data.order_created_at),
                ),
              );
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CanceledFavor(timeout: _orderStatus!.data.order_created_at),
                ),
              );
            }
          }
        });
      }
    }
  }

  void _changeState(String state) async {
    final idFavor = await getStorageNoOrder() ?? '';

    if(state == 'Finished'){
      if(!_keyMount.currentState!.validate()) return showWarningAlert(context, 'Ingrese un monto válido');
      if(_receiptPhotoController.text.isEmpty) return showWarningAlert(context, 'Ingrese una foto de su factura');
    }

    final ChangeStateEntity changeState = ChangeStateEntity(
      no_order: idFavor,
      newStatus: state,
      cost: state == 'Finished' ? double.parse(_amountController.text): null,
      receipt: state == 'Finished' ? _receiptPhotoController.text : null,
    );
    print(changeState.toJson());
    final response = await _favorService.changeState(changeState);
    if (response.error) {
      showErrorAlert(context, getErrorMessages(response.message));
    } else {
      showSuccessAlert(context, 'Estado actualizado correctamente');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= Duration(seconds: 1);
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
          ? Center(child: CircularProgressIndicator())
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
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Seguimiento del pedido',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
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
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  padding: const EdgeInsets.all(8),
                                  backgroundColor: _status.contains('In shopping')
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
                                        '${_orderDetails!.courier_name} ${_orderDetails!.courier_surname}',
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
                                            _orderDetails!.courier_phone ?? '',
                                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => LocationPreview(
                                                    text: 'Ubicación de entrega',
                                                    lat: _orderDetails!.place_lat,
                                                    lng: _orderDetails!.place_lng,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Ubicación',
                                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                            icon: Icon(Icons.chat, color: Theme.of(context).primaryColor),
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
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16,),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStateButton(Icons.shopping_cart, true),
                                  GestureDetector(
                                    onTap: () => confirmAndChangeState('In delivery', 'En camino'),
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF6E7E91),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.chevron_right, color: Colors.white),
                                    ),
                                  ),
                                  _buildStateButton(Icons.person_outline, _status.contains('In delivery')),
                                  GestureDetector(
                                    onTap: () => confirmAndChangeState('Finished', 'Finalizado'),
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF6E7E91),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.chevron_right, color: Colors.white),
                                    ),
                                  ),
                                  _buildStateButton(Icons.attach_money, false),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Form(
                                    key: _keyMount,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        _keyMount.currentState!.validate();
                                      },
                                      controller: _amountController,
                                      decoration: InputDecoration(
                                        labelText: 'Monto',
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelStyle: const TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'El monto es obligatorio';
                                        }
                                        final amount = double.tryParse(value);
                                        if (amount == null || amount <= 0 || amount > 1000000) {
                                          return 'Ingrese un monto válido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                PhotoPicker(
                                  label: 'Factura',
                                  textDialog: 'Foto de su factura',
                                  widthImg: 856,
                                  controller: _receiptPhotoController,
                                  heightImg: 540),
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

  Future<void> confirmAndChangeState(String state, String text) async {
  bool? confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación'),
        content: Text('¿Estás seguro de que deseas cambiar el estado a $text?'),
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
        color: isActive ? const Color(0xFF6E7E91) : Color(0xFFA4B0BD),
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