import 'package:flutter/material.dart';

class Spacing {
  const Spacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class Radii {
  const Radii._();

  static const double md = 12;
  static const double lg = 16;
}

class AppColors {
  const AppColors._();

  static const Color seed = Color(0xFF0891B2);
  static const Color like = Color(0xFFE53E3E);
  static const Color pending = Color(0xFFD69E2E);
  static const Color accepted = Color(0xFF38A169);
  static const Color rejected = Color(0xFFE53E3E);
  static const Color cancelled = Color(0xFF718096);
  static const Color admin = Color(0xFF805AD5);
  static const Color videoBackground = Color(0xFF000000);
  static const Color onVideo = Color(0xFFFFFFFF);
  static const Color onVideoMuted = Color(0xB3FFFFFF);
}

class Layout {
  const Layout._();

  static const double videoAspectRatio = 16 / 9;
  static const double maxContentWidth = 720;
  static const double avatarSmall = 16;
  static const double avatarLarge = 40;
}
