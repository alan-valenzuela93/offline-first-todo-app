import 'package:flutter/material.dart';

class ResponsivePageContainer extends StatelessWidget {
  const ResponsivePageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 600 ? 14.0 : 28.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            width < 600 ? 12 : 22,
            horizontalPadding,
            96,
          ),
          child: child,
        ),
      ),
    );
  }
}
