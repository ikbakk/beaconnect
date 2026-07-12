import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/place_snapshot.dart';
import '../domain/place_snapshot_failure.dart';
import '../domain/place_snapshot_repository.dart';

class LocalPlaceSnapshotRepository implements PlaceSnapshotRepository {
  LocalPlaceSnapshotRepository(
    this._preferences, {
    Future<String?> Function()? capturePlaceLabel,
    DateTime Function()? now,
  }) : _capturePlaceLabelOverride = capturePlaceLabel,
       _now = now ?? DateTime.now;

  static const _snapshotKey = 'place_snapshot.latest';

  final SharedPreferences _preferences;
  final Future<String?> Function()? _capturePlaceLabelOverride;
  final DateTime Function() _now;

  @override
  Future<PlaceSnapshot> captureSnapshot() async {
    final label = await _capturePlaceLabel();
    final snapshot = PlaceSnapshot(
      placeLabel: label,
      capturedAt: _now(),
    );
    await _preferences.setString(_snapshotKey, jsonEncode(snapshot.toJson()));
    return snapshot;
  }

  @override
  Future<PlaceSnapshot?> getLatestSnapshot() async {
    final raw = _preferences.getString(_snapshotKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return PlaceSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<String> _capturePlaceLabel() async {
    if (_capturePlaceLabelOverride case final override?) {
      return _normalizePlaceLabel(await override());
    }

    if (!_supportsDeviceLocation) {
      throw const PlaceSnapshotFailure(
        'Current place could not be updated just yet.',
      );
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const PlaceSnapshotFailure(
          'Current place could not be updated just yet.',
        );
      }

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          permission == LocationPermission.unableToDetermine) {
        throw const PlaceSnapshotFailure(
          'Sharing works best when permission is enabled.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 12),
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      return _normalizePlaceLabel(_labelFromPlacemarks(placemarks));
    } on TimeoutException {
      throw const PlaceSnapshotFailure(
        'Current place could not be updated just yet.',
      );
    } on MissingPluginException {
      throw const PlaceSnapshotFailure(
        'Current place could not be updated just yet.',
      );
    } on PlaceSnapshotFailure {
      rethrow;
    } catch (_) {
      throw const PlaceSnapshotFailure(
        'Current place could not be updated just yet.',
      );
    }
  }

  bool get _supportsDeviceLocation => Platform.isAndroid || Platform.isIOS;

  String _normalizePlaceLabel(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'Current place';
    }

    return trimmed;
  }

  String? _labelFromPlacemarks(List<Placemark> placemarks) {
    for (final placemark in placemarks) {
      final candidates = [
        placemark.name,
        placemark.subLocality,
        placemark.locality,
        placemark.subAdministrativeArea,
        placemark.administrativeArea,
      ];
      for (final candidate in candidates) {
        final normalized = candidate?.trim();
        if (normalized == null || normalized.isEmpty) {
          continue;
        }
        if (RegExp(r'^\d+$').hasMatch(normalized)) {
          continue;
        }
        return normalized;
      }
    }

    return null;
  }
}
