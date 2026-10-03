import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pemmob/pert1/Praktikum/praktikum1_page.dart';
import 'package:pemmob/pert1/Tugas/tugas1_page.dart';
import 'package:pemmob/pert2/Praktikum/hello_app_page.dart';
import 'package:pemmob/pert2/Tugas/tugas2_page.dart';
import 'package:pemmob/pert3/Praktikum/praktikum3_page.dart';
import 'package:pemmob/pert3/Tugas/tugas3_page.dart';

void main() {
  setUpAll(() {
    Directory('screenshots').createSync(recursive: true);
  });

  testWidgets('Capture all screenshots using real flutter widgets', (WidgetTester tester) async {
    // Typical modern Android phone dimensions (412 x 892 dp, 2.625 ratio = 1080 x 2340 px)
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;

    // Suppress render overflow noise in test log
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    final pages = [
      {'name': 'pert1_praktikum', 'widget': const Praktikum1Page()},
      {'name': 'pert1_tugas', 'widget': const Tugas1Page()},
      {'name': 'pert2_praktikum', 'widget': const Praktikum2Page()},
      {'name': 'pert2_tugas', 'widget': const Tugas2Page()},
      {'name': 'pert3_praktikum', 'widget': const Praktikum3Page()},
      {'name': 'pert3_tugas', 'widget': const Tugas3Page()},
    ];

    for (var p in pages) {
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.indigo,
            ),
            home: p['widget'] as Widget,
          ),
        ),
      );
      await tester.pump();

      await tester.runAsync(() async {
        final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 2.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        final file = File('screenshots/${p['name']}.png');
        file.writeAsBytesSync(pngBytes);
        print('Captured real widget screenshot: ${file.path}');
      });
    }

    FlutterError.onError = originalOnError;
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
