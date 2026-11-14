import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabungku_layout/main.dart';

void main() {
  testWidgets('Capture TabungKu layout screenshots', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.runAsync(_loadScreenshotFonts);

    final outputDir = Directory('docs');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    const captures = [
      _ScreenshotCapture(
        name: '01-hp',
        size: Size(390, 844),
        devicePixelRatio: 2,
      ),
      _ScreenshotCapture(
        name: '02-tablet',
        size: Size(1024, 1366),
        devicePixelRatio: 1.5,
      ),
    ];

    for (final capture in captures) {
      tester.view.physicalSize = Size(
        capture.size.width * capture.devicePixelRatio,
        capture.size.height * capture.devicePixelRatio,
      );
      tester.view.devicePixelRatio = capture.devicePixelRatio;

      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: const TabungKuApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Ringkasan Tabungan'), findsOneWidget);
      expect(find.text('Tabungan Kamera'), findsOneWidget);
      expect(find.text('Menu Cepat'), findsOneWidget);
      expect(find.text('Menabung'), findsOneWidget);
      expect(find.text('Aktivitas Terakhir'), findsOneWidget);

      await tester.runAsync(() async {
        final boundary =
            boundaryKey.currentContext!.findRenderObject()
                as RenderRepaintBoundary;
        final image = await boundary.toImage(
          pixelRatio: capture.devicePixelRatio,
        );
        final byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        final file = File('${outputDir.path}/${capture.name}.png');
        await file.writeAsBytes(
          byteData!.buffer.asUint8List(),
          flush: true,
        );
        image.dispose();

        expect(await file.length(), greaterThan(0));
      });
    }
  });
}

class _ScreenshotCapture {
  const _ScreenshotCapture({
    required this.name,
    required this.size,
    required this.devicePixelRatio,
  });

  final String name;
  final Size size;
  final double devicePixelRatio;
}

Future<void> _loadScreenshotFonts() async {
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ?? r'C:\src\flutter';
  final fontDir = Directory('$flutterRoot/bin/cache/artifacts/material_fonts');
  if (!fontDir.existsSync()) {
    return;
  }

  final roboto = FontLoader('Roboto');
  for (final name in [
    'roboto-regular.ttf',
    'roboto-medium.ttf',
    'roboto-bold.ttf',
  ]) {
    final file = File('${fontDir.path}/$name');
    if (!file.existsSync()) {
      continue;
    }
    roboto.addFont(
      Future.value(ByteData.sublistView(await file.readAsBytes())),
    );
  }
  await roboto.load();

  final iconsFile = File('${fontDir.path}/materialicons-regular.otf');
  if (iconsFile.existsSync()) {
    final icons = FontLoader('MaterialIcons')
      ..addFont(
        Future.value(ByteData.sublistView(await iconsFile.readAsBytes())),
      );
    await icons.load();
  }
}
