import 'package:flutter/material.dart';

import '../../../kernel/widget/wave_painter.dart';

class FavorFinished extends StatefulWidget {
  const FavorFinished({super.key});

  @override
  State<FavorFinished> createState() => _FavorFinishedState();
}

class _FavorFinishedState extends State<FavorFinished> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: WavePainter(context: context, waveHeight: 200),
            child: Container(),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Seguimiento del pedido',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '01:01:18',
                        style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 60, color: Color(0xFF3B4056)),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Favor finalizado',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).secondaryHeaderColor,
                        ),
                        onPressed: () {  },
                        child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                        ),
                    ],
                  ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: () {  },
                        child: const Text('Finalizado', style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
