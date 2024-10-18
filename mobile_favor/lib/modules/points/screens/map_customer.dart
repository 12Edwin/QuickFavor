import 'package:flutter/material.dart';
import 'package:mobile_favor/modules/points/widgets/map_widget.dart';

class MapCustomer extends StatefulWidget {
  const MapCustomer({super.key});

  @override
  _MapCustomerState createState() => _MapCustomerState();
}

class _MapCustomerState extends State<MapCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Necesitas algo Merri?'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20), // Esquinas redondeadas
                    color:
                        Colors.white, // Color de fondo (ajusta según necesites)
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none, // Quitar el borde por defecto
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12), // Ajustar padding interno
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 550, // Ajustar la altura del mapa según sea necesario
                  child: MapWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
