import 'package:flutter/material.dart';

import 'grid_background.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, this.color,required this.header, this.bottom, required this.child});

  final Widget header;
  final Widget? bottom;
  final Widget child;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFF2D55), Color(0xFFFF3B30)]),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: GridBackground()),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  header,
                  const SizedBox(height: 20),
                  Expanded(child: child),
                  if (bottom != null) bottom!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
