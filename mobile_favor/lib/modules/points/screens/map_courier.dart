import 'package:flutter/material.dart';
import 'package:mobile_favor/modules/points/widgets/map_widget.dart';

class MapCourier extends StatefulWidget {
  const MapCourier({super.key});

  @override
  _MapCourierState createState() => _MapCourierState();
}

class _MapCourierState extends State<MapCourier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Donde estas?'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(1.0),
              child: SizedBox(
                width: double.infinity,
                height: 700,
                child: MapWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
