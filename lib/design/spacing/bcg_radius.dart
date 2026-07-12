import 'package:flutter/material.dart';

/// Beaconnect border radius system
/// Derived from design/prototype/beaconnect.css
abstract final class BcgRadius {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double full = 9999;

  /// Common radius values as BorderRadius objects
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderFull = BorderRadius.all(Radius.circular(full));
}
