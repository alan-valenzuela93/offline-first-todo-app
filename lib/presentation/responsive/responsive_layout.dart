import 'package:flutter/widgets.dart';

import 'app_breakpoints.dart';

class ResponsiveLayout {
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppBreakpoints.mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= AppBreakpoints.mobile && width < AppBreakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;
}
