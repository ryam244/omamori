// lib/core/constants/layout.dart

import 'package:flutter/material.dart';

/// Fortune Vault App Layout Constants
/// Consistent spacing, sizing, and layout values
class AppLayout {
  AppLayout._();

  // Spacing Scale (8px base)
  static const double space0 = 0;
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space64 = 64;

  // Edge Insets (Padding/Margin)
  static const EdgeInsets paddingZero = EdgeInsets.zero;
  static const EdgeInsets paddingXS = EdgeInsets.all(space4);
  static const EdgeInsets paddingSM = EdgeInsets.all(space8);
  static const EdgeInsets paddingMD = EdgeInsets.all(space16);
  static const EdgeInsets paddingLG = EdgeInsets.all(space24);
  static const EdgeInsets paddingXL = EdgeInsets.all(space32);

  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: space8);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: space16);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: space24);

  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: space8);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: space16);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: space24);

  // Screen Padding (Safe Area + Content)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: space20,
    vertical: space16,
  );

  static const EdgeInsets screenPaddingLarge = EdgeInsets.symmetric(
    horizontal: space24,
    vertical: space20,
  );

  // Border Radius
  static const double radiusXS = 4;
  static const double radiusSM = 8;
  static const double radiusMD = 12;
  static const double radiusLG = 16;
  static const double radiusXL = 20;
  static const double radiusXXL = 24;
  static const double radiusCircle = 9999;

  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL = BorderRadius.all(Radius.circular(radiusXXL));

  // Icon Sizes
  static const double iconXS = 16;
  static const double iconSM = 20;
  static const double iconMD = 24;
  static const double iconLG = 32;
  static const double iconXL = 40;
  static const double iconXXL = 48;

  // Button Sizes
  static const double buttonHeightSM = 36;
  static const double buttonHeightMD = 48;
  static const double buttonHeightLG = 56;

  static const double buttonWidthSM = 80;
  static const double buttonWidthMD = 120;
  static const double buttonWidthLG = 160;

  // Card Sizes
  static const double cardElevation = 2;
  static const double cardElevationHover = 4;
  static const double cardMinHeight = 120;

  // Fortune Card Specific
  static const double fortuneCardHeight = 140;
  static const double fortuneCardImageSize = 100;
  static const double fortuneGradeBadgeSize = 56;

  // Camera Guide
  static const double cameraGuideFrameThickness = 2;
  static const double cameraGuideCornerLength = 24;
  static const Size cameraGuideSize = Size(280, 400); // おみくじのアスペクト比

  // Result Card Sections
  static const double resultCardMinHeight = 100;
  static const double resultSectionSpacing = space24;

  // List Item
  static const double listItemHeight = 72;
  static const double listItemImageSize = 56;
  static const double listItemSpacing = space12;

  // AppBar
  static const double appBarHeight = 56;
  static const double appBarElevation = 0;

  // Bottom Navigation
  static const double bottomNavHeight = 64;

  // Divider
  static const double dividerThickness = 1;
  static const double dividerIndent = space16;

  // Shadow
  static const List<BoxShadow> shadowSM = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> shadowMD = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static const List<BoxShadow> shadowLG = [
    BoxShadow(
      color: Color(0x24000000),
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  // Duration (Animations)
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Breakpoints (Responsive)
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;

  // Max Width
  static const double maxContentWidth = 600;

  /// Check if screen is mobile size
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMobile;
  }

  /// Check if screen is tablet size
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointMobile && width < breakpointTablet;
  }

  /// Check if screen is desktop size
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointTablet;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return screenPaddingLarge;
    }
    return screenPadding;
  }
}
