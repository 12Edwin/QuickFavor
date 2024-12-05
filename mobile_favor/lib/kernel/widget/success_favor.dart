import 'package:flutter/material.dart';
import 'package:mobile_favor/kernel/widget/wave_painter.dart';

class SuccessFavor extends StatelessWidget {
  final String timeout;

  const SuccessFavor({super.key, required this.timeout});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children:[
          SizedBox(
            height: screenHeight,
            child: CustomPaint(
              painter: WavePainter(context: context, waveHeight: 100),
              child: Container(),
            ),
          ),
          Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 64),
              const Text(
                'Favor Finalizado',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/navigation');
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        ),
    ]
      ),
    );
  }
}