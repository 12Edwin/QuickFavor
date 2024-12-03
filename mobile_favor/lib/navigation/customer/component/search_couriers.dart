import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mobile_favor/navigation/customer/entity/order.entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/alerts.dart';
import '../../../config/error_types.dart';
import '../../../kernel/widget/wave_painter.dart';
import '../service/favor.service.dart';
import '../entity/sse.entity.dart';

class SearchCouriers extends StatefulWidget {
  final CreateOrderEntity order;

  const SearchCouriers({Key? key, required this.order}) : super(key: key);

  @override
  _SearchCouriersState createState() => _SearchCouriersState();
}

class _SearchCouriersState extends State<SearchCouriers> {
  late bool _isCancelled;
  late double _progress;
  bool isDisabled = false;
  bool isCreating = true;
  bool isSearching = true;
  late Timer _timer;
  int _countdown = 600; // 10 minutes in seconds
  late StreamSubscription<SSEMessage> _sseSubscription;
  SSEMessage? sseMessage;

  @override
  void initState() {
    super.initState();
    _isCancelled = false;
    _progress = 0.0;
    _startProgress();
  }

  void _startProgress() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isCancelled) return;
      setState(() {
        _progress += 0.02;
      });
      if (_progress < 1.0) {
        _startProgress();
      } else {
        _createFavor();
      }
    });
  }

  Future<void> _createFavor() async {
    if (!_isCancelled) {
      isDisabled = true;
      final service = FavorService(context);
      final response = await service.registerFavor(widget.order);
      if (response.error) {
        showErrorAlert(context, getErrorMessages(response.message));
        Navigator.pop(context);
      } else {
        showSuccessAlert(context, 'Favor registrado correctamente');
        isCreating = false;
        _startCountdown();
        _searchCouriers(response.data['no_order']);
      }
    }
  }

  Future<void> _searchCouriers(String noOrder) async {
    final service = FavorService(context);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _sseSubscription = service.listenToSSE(SearchCourierEntity(
      no_order: noOrder,
      delivery_point: DeliveryPoint(lat: widget.order.customer_direction.lat, lng: widget.order.customer_direction.lng),
      distance_km: 5,
    )).listen((message) {
      setState(() {
        sseMessage = message;
        if (message.data.status == 'In shopping') {
          isSearching = false;
          _timer.cancel();
          prefs.setString('no_order', noOrder);
          Navigator.pushReplacementNamed(context, '/navigation');
        }
        if (message.data.status == 'Timeout') {
          showErrorAlert(context, 'No se encontraron repartidores disponibles');
          Navigator.pop(context);
        }
      });
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer.cancel();
        _onCountdownComplete();
      }
    });
  }

  void _onCountdownComplete() {
    print('Countdown complete. Triggering function...');
    // Trigger the function you want to call when the countdown completes
  }

  void _cancel() {
    setState(() {
      _isCancelled = true;
    });
    _timer.cancel();
    _sseSubscription.cancel();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer.cancel();
    _sseSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitando favor'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: isDisabled ? null : _cancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text('Cancelar', style: TextStyle(fontSize: 14,),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children:[
          SizedBox(
                height: screenHeight,
                child: CustomPaint(
                  painter: WavePainter(context: context, waveHeight: 30),
                  child: Container(),
                ),
              ),
          Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 64,),
                isCreating ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5A808E)),
                          minHeight: 64,
                        ),
                      ),
                    ),
                    const Text(
                      'Creando pedido...',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ): const Icon(Icons.fact_check, color: Colors.white, size: 100),
                const SizedBox(height: 64),
                Image.asset('assets/box.png', width: 200),
                const SizedBox(height: 32),

                _buildIconWithInput(hintText: "Crear pedido", icon: Icons.location_on, loading: isCreating),
                const SizedBox(height: 32),
                _buildIconWithInput(hintText: "Buscando repartidores", icon: Icons.search, loading: isSearching),
                if (!isCreating) ...[
                  const SizedBox(height: 32),
                  Text(
                    'Buscando repartidor...',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(_countdown ~/ 60).toString().padLeft(2, '0')}:${(_countdown % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ]
      ),
    );
  }

  Widget _buildIconWithInput({required String hintText, required IconData icon, required bool loading}) {
      return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
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
              const SizedBox(width: 64),
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -8,
          left: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: loading
              ? const Padding(padding: EdgeInsets.all(16),
                child: CircularProgressIndicator())
              : IconButton(
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  iconSize: 35,
                  onPressed: () {},
                ),
          ),
        ),
      ],
    );
    }
}