import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../colors/bcg_colors.dart';
import '../spacing/bcg_radius.dart';
import '../spacing/bcg_spacing.dart';

const _fallbackPoint = LatLng(51.5074, -0.1278);

class BcgInteractiveMapPreview extends StatelessWidget {
  const BcgInteractiveMapPreview({
    super.key,
    required this.label,
    required this.onTap,
    this.latitude,
    this.longitude,
    this.height = 160,
  });

  final String label;
  final VoidCallback onTap;
  final double? latitude;
  final double? longitude;
  final double height;

  LatLng get _center => latitude != null && longitude != null
      ? LatLng(latitude!, longitude!)
      : _fallbackPoint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: BcgColors.surfaceVariant,
          borderRadius: BcgRadius.borderMd,
          border: Border.all(color: BcgColors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: AbsorbPointer(
                child: _TileMap(
                  center: _center,
                  zoom: 14,
                  showControls: false,
                ),
              ),
            ),
            Positioned(
              left: BcgSpacing.s3,
              bottom: BcgSpacing.s3,
              child: _MapLabel(label: label),
            ),
          ],
        ),
      ),
    );
  }
}

class BcgInteractiveMapScreen extends StatelessWidget {
  const BcgInteractiveMapScreen({
    super.key,
    required this.label,
    this.latitude,
    this.longitude,
  });

  final String label;
  final double? latitude;
  final double? longitude;

  LatLng get _center => latitude != null && longitude != null
      ? LatLng(latitude!, longitude!)
      : _fallbackPoint;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _TileMap(
            center: _center,
            zoom: latitude != null && longitude != null ? 15 : 12,
            showControls: true,
          ),
        ),
        Positioned(
          left: BcgSpacing.s5,
          right: BcgSpacing.s5,
          bottom: BcgSpacing.s5,
          child: Row(
            children: [
              Expanded(child: _MapLabel(label: label)),
              if (latitude == null || longitude == null) ...[
                const SizedBox(width: BcgSpacing.s3),
                const _MapHint(label: 'No saved coordinates yet'),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TileMap extends StatefulWidget {
  const _TileMap({
    required this.center,
    required this.zoom,
    required this.showControls,
  });

  final LatLng center;
  final double zoom;
  final bool showControls;

  @override
  State<_TileMap> createState() => _TileMapState();
}

class _TileMapState extends State<_TileMap> {
  final _mapController = MapController();
  late double _zoom;

  @override
  void initState() {
    super.initState();
    _zoom = widget.zoom;
  }

  @override
  void didUpdateWidget(covariant _TileMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.center != widget.center) {
      _mapController.move(widget.center, _zoom);
    }
  }

  void _zoomBy(double delta) {
    final nextZoom = (_zoom + delta).clamp(3.0, 18.0);
    setState(() => _zoom = nextZoom);
    _mapController.move(_mapController.camera.center, nextZoom);
  }

  void _centerMap() {
    setState(() => _zoom = widget.zoom);
    _mapController.move(widget.center, widget.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: widget.zoom,
            minZoom: 3,
            maxZoom: 18,
            interactionOptions: InteractionOptions(
              flags: widget.showControls
                  ? InteractiveFlag.all
                  : InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.beaconnect.app',
              tileBuilder: _softTileBuilder,
            ),
            CircleLayer(
              circles: [
                CircleMarker(
                  point: widget.center,
                  radius: 42,
                  color: BcgColors.success.withValues(alpha: 0.16),
                  borderStrokeWidth: 0,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: widget.center,
                  width: 54,
                  height: 54,
                  child: const _CurrentPlaceMarker(),
                ),
              ],
            ),
          ],
        ),
        if (widget.showControls)
          Positioned(
            top: BcgSpacing.s5,
            right: BcgSpacing.s5,
            child: Column(
              children: [
                _MapControl(icon: Icons.add, onTap: () => _zoomBy(1)),
                const SizedBox(height: BcgSpacing.s2),
                _MapControl(icon: Icons.remove, onTap: () => _zoomBy(-1)),
                const SizedBox(height: BcgSpacing.s2),
                _MapControl(icon: Icons.center_focus_strong, onTap: _centerMap),
              ],
            ),
          ),
      ],
    );
  }

  Widget _softTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        BcgColors.surface.withValues(alpha: 0.16),
        BlendMode.lighten,
      ),
      child: Opacity(
        opacity: 0.92,
        child: tileWidget,
      ),
    );
  }
}

class _CurrentPlaceMarker extends StatelessWidget {
  const _CurrentPlaceMarker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: BcgColors.primary.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: BcgColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: BcgColors.primaryFg, width: 3),
          ),
        ),
      ],
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: BcgSpacing.s3, vertical: 4),
      decoration: BoxDecoration(
        color: BcgColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(BcgRadius.sm),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: BcgColors.fg,
        ),
      ),
    );
  }
}

class _MapHint extends StatelessWidget {
  const _MapHint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: BcgColors.primary,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: BcgColors.primaryFg,
        ),
      ),
    );
  }
}

class _MapControl extends StatelessWidget {
  const _MapControl({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: BcgColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(BcgRadius.md),
          border: Border.all(color: BcgColors.outline),
        ),
        child: Icon(icon, color: BcgColors.fg, size: 20),
      ),
    );
  }
}
