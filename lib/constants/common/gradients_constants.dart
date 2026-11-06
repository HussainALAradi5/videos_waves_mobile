import 'package:flutter/material.dart';

import 'app_colors_constants.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandStart, AppColors.brandMiddle, AppColors.brandEnd],
  );
}
