import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../design/colors/bcg_colors.dart';
import '../../../design/components/bcg_app_header.dart';
import '../../../design/components/bcg_interactive_map.dart';

class MapDetailScreen extends StatelessWidget {
  const MapDetailScreen({
    super.key,
    required this.label,
    this.latitude,
    this.longitude,
  });

  final String label;
  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BcgColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BcgAppHeader(
              title: 'Current place',
              label: 'Map',
              subtitle: 'Pinch, drag, or use the controls to look closer.',
              backLabel: 'Home',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: BcgInteractiveMapScreen(
                label: label,
                latitude: latitude,
                longitude: longitude,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
