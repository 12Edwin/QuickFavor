import 'package:flutter/material.dart';
import 'package:mobile_favor/utils/app_colors.dart';

import '../../kernel/widget/wave_painter.dart';

class FavorProgressCourier extends StatefulWidget {
  const FavorProgressCourier({super.key});

  @override
  State<FavorProgressCourier> createState() => _FavorProgressCourierState();
}

class _FavorProgressCourierState extends State<FavorProgressCourier> {
  bool _isExpanded = false;


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: screenHeight,
              child: CustomPaint(
                painter: WavePainter(context: context, waveHeight: 80),
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
                        children:[
                          const Text(
                            'Detalles del pedido',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
        
                          Badge(
                            label: const Text('Proceso de compra', style: TextStyle(fontWeight: FontWeight.bold)),
                            padding: const EdgeInsets.all(8),
                            backgroundColor:customColors.warning,
                          ),
                        ]
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '01:01:18',
                          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColors.danger,
                          ),
                          child: const Text('Cancelar'),
                        )
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset('assets/profile.png'),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Juan Rodrígo',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Repartidor',
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                children:[
                                  Icon(Icons.phone, color: Colors.white, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    '7774547357',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ]
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () { },
                                    child: const Row(
                                      children:[
                                        Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
                                        SizedBox(width: 8),
                                        Text(
                                          'Ubicación',
                                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ]
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {  },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    icon: Icon(Icons.chat, color: Theme.of(context).primaryColor),
                                  ),
                                ]
                              ),
                            ],
                          ),
                        ),
                      ]
                    ),
                    const SizedBox(height: 32),
                    Image.asset('assets/package.png', width: 150),
                    const SizedBox(height: 16,),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLocationItem(true, "San Antonio\nsmog check"),
                              _buildLocationItem(false, ""),
                              _buildLocationItem(false, ""),
                            ],
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
                          children: const [
                            ListTile(title: Text("Producto 1", style: TextStyle(color: Colors.white))),
                            ListTile(title: Text("Producto 2", style: TextStyle(color: Colors.white))),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStateButton(Icons.shopping_cart, true),
                              Icon(Icons.chevron_right, color: Color(0xFF6E7E91)),
                              _buildStateButton(Icons.person_outline, false),
                              Icon(Icons.chevron_right, color: Color(0xFF6E7E91)),
                              _buildStateButton(Icons.attach_money, false),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActionButton(Icons.attach_money, "Monto", (value) {
                              if (value == null || value.isEmpty) {
                                return 'El monto es requerido';
                              }
                              return null;
                            }),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Factura"),
                              onPressed: () {  },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]
                )
              ),
            )
          ],
        ),
      ),
    );


  }

  Widget _buildLocationItem(bool isActive, String text) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? Colors.grey : Color(0xFF6E7E91),
            shape: BoxShape.circle,
          ),
          child: Icon(isActive ? Icons.remove_red_eye : Icons.block, color: Colors.white),
        ),
        if (text.isNotEmpty)
          Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStateButton(IconData icon, bool isActive) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF6E7E91) : Color(0xFFA4B0BD),
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
