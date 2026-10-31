import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pemmob/project/prototype/screens/account_screen.dart';
import 'package:pemmob/project/prototype/screens/admin_screen.dart';
import 'package:pemmob/project/prototype/screens/detail_screen.dart';
import 'package:pemmob/project/prototype/screens/login_screen.dart';
import 'package:pemmob/project/prototype/screens/map_screen.dart';
import 'package:pemmob/project/prototype/screens/saved_screen.dart';
import 'package:pemmob/project/prototype/state/splw_state.dart';
import 'package:pemmob/project/prototype/theme/splw_theme.dart';

void main() {
  testWidgets('Capture SPLW Prototype Screenshots', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.runAsync(_loadScreenshotFonts);

    final guestState = SplwState();
    final userState = SplwState()
      ..login(email: 'traveler@gmail.com', password: 'password123');
    final adminState = SplwState()
      ..login(email: 'admin@splw.app', password: 'admin123');

    final screens = [
      {
        'name': 'proto_01_peta',
        'widget': MapScreen(state: guestState, onRequireLogin: () {}),
      },
      {
        'name': 'proto_02_saved',
        'widget': SavedScreen(
          state: userState,
          onRequireLogin: () {},
          onRequireRegister: () {},
          onNavigateToMap: () {},
        ),
      },
      {
        'name': 'proto_03_detail',
        'widget': DetailScreen(
          state: adminState,
          nama: 'Candi Borobudur',
          latitude: -7.6079,
          longitude: 110.2038,
          kategori: 'Budaya',
          deskripsi: 'Candi Buddha terbesar peninggalan wangsa Syailendra di Magelang, Jawa Tengah.',
          savedId: 'lok-1',
        ),
      },
      {
        'name': 'proto_04_login',
        'widget': LoginScreen(state: guestState, onLoginSuccess: () {}),
      },
      {
        'name': 'proto_05_account',
        'widget': AccountScreen(state: userState, onNavigateToLogin: () {}),
      },
      {'name': 'proto_06_admin', 'widget': AdminScreen(state: adminState)},
    ];

    final outputDir = Directory('lib/project/prototype/screenshots');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    for (final item in screens) {
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: SplwTheme.lightTheme,
            home: Scaffold(body: item['widget'] as Widget),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 1.5);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();
        final file = File('${outputDir.path}/${item['name']}.png');
        file.writeAsBytesSync(pngBytes);
      });
    }
  });
}

Future<void> _loadScreenshotFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? r'C:\src\flutter';
  final fontDir = Directory('$flutterRoot/bin/cache/artifacts/material_fonts');
  if (!fontDir.existsSync()) return;

  final roboto = FontLoader('Roboto');
  for (final name in [
    'roboto-regular.ttf',
    'roboto-medium.ttf',
    'roboto-bold.ttf',
  ]) {
    final file = File('${fontDir.path}/$name');
    if (!file.existsSync()) continue;
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
