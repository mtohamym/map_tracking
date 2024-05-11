import 'package:flutter/material.dart';
import 'package:untitled/feature/map_tracking/view/map_tracking.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Maps',
      home: MapTracking(),
    );
  }
}
