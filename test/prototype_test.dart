import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemmob/project/prototype/main.dart';
import 'package:pemmob/project/prototype/state/splw_state.dart';

void main() {
  group('SplwState business rules', () {
    test('guest tidak dapat menyimpan dan akun nonaktif ditolak', () {
      final state = SplwState();

      expect(state.currentUser, isNull);
      expect(
        state.saveLokasi(
          nama: 'Test',
          lat: -6.2,
          lng: 106.8,
          deskripsi: '',
          kategori: 'Kota',
        ),
        contains('BR-01'),
      );
      expect(
        state.login(email: 'budi@gmail.com', password: 'password123'),
        contains('BR-10'),
      );
      expect(
        state.login(email: 'traveler@gmail.com', password: 'salah'),
        'Email atau password salah.',
      );
      expect(
        state.login(email: 'traveler@gmail.com', password: 'password123'),
        isNull,
      );
      expect(state.currentUser?.name, 'Traveler Nusantara');
    });

    test(
      'registrasi, profil, dan ganti password memakai validasi BR-06/BT-01',
      () {
        final state = SplwState();

        expect(
          state.register(
            name: ' ',
            email: 'baru@example.com',
            password: 'password123',
            confirmPassword: 'password123',
          ),
          'Nama wajib diisi.',
        );
        expect(
          state.register(
            name: 'Pengguna Baru',
            email: 'bukan-email',
            password: 'password123',
            confirmPassword: 'password123',
          ),
          'Format email tidak valid.',
        );
        expect(
          state.register(
            name: 'Pengguna Baru',
            email: 'traveler@gmail.com',
            password: 'password123',
            confirmPassword: 'password123',
          ),
          'Email sudah terdaftar.',
        );
        expect(
          state.register(
            name: 'Pengguna Baru',
            email: ' BARU@Example.com ',
            password: 'password123',
            confirmPassword: 'password123',
          ),
          isNull,
        );
        expect(state.currentUser?.email, 'baru@example.com');

        expect(
          state.updateProfile(name: 'Nama Baru', email: 'baru@example.com'),
          isNull,
        );
        expect(state.currentUser?.name, 'Nama Baru');
        expect(
          state.changePassword(
            oldPassword: 'salah',
            newPassword: 'password456',
            confirmPassword: 'password456',
          ),
          'Password lama tidak sesuai.',
        );
        expect(
          state.changePassword(
            oldPassword: 'password123',
            newPassword: 'password456',
            confirmPassword: 'password456',
          ),
          isNull,
        );

        state.logout();
        expect(
          state.login(email: 'baru@example.com', password: 'password123'),
          'Email atau password salah.',
        );
        expect(
          state.login(email: 'baru@example.com', password: 'password456'),
          isNull,
        );
      },
    );

    test('simpan, validasi duplikat, ubah, share, dan hapus lokasi', () {
      final state = SplwState();
      state.login(email: 'traveler@gmail.com', password: 'password123');

      expect(
        state.saveLokasi(
          nama: '',
          lat: -8.7,
          lng: 115.2,
          deskripsi: '',
          kategori: 'Pantai',
        ),
        'Nama lokasi wajib diisi.',
      );
      expect(
        state.saveLokasi(
          nama: 'Duplikat Bromo',
          lat: -7.9425,
          lng: 112.9530,
          deskripsi: '',
          kategori: 'Gunung',
        ),
        contains('BR-09'),
      );
      expect(
        state.saveLokasi(
          nama: 'Pantai Test',
          lat: -8.7,
          lng: 115.2,
          deskripsi: 'Pantai untuk pengujian.',
          kategori: 'Pantai',
        ),
        isNull,
      );

      final saved = state.lokasis.firstWhere(
        (lokasi) => lokasi.namaLokasi == 'Pantai Test',
      );
      expect(saved.userId, state.currentUser?.id);
      expect(
        state.updateLokasi(
          id: saved.id,
          nama: 'Pantai Test Baru',
          lat: -8.7,
          lng: 115.2,
          deskripsi: 'Deskripsi baru.',
          kategori: 'Pantai',
        ),
        isNull,
      );
      expect(
        state.lokasis.firstWhere((lokasi) => lokasi.id == saved.id).namaLokasi,
        'Pantai Test Baru',
      );

      expect(state.enableShareLokasi(saved.id), isNull);
      final shared = state.lokasis.firstWhere(
        (lokasi) => lokasi.id == saved.id,
      );
      expect(shared.shareToken, isNotNull);
      expect(shared.shareToken!.length, 16);
      expect(state.revokeShareLokasi(saved.id), isNull);
      expect(
        state.lokasis.firstWhere((lokasi) => lokasi.id == saved.id).shareToken,
        isNull,
      );
      expect(state.deleteLokasi(saved.id), isNull);
      expect(state.lokasis.any((lokasi) => lokasi.id == saved.id), isFalse);
    });

    test(
      'admin tidak dapat menurunkan/menghapus diri dan delete user cascade',
      () {
        final state = SplwState();
        state.login(email: 'admin@splw.app', password: 'admin123');
        final admin = state.currentUser!;

        expect(
          state.updateUserByAdmin(
            id: admin.id,
            name: admin.name,
            email: admin.email,
            role: 'user',
          ),
          contains('BR-13'),
        );
        expect(state.toggleUserStatusByAdmin(admin.id), contains('BR-13'));
        expect(state.deleteUserByAdmin(admin.id), contains('BR-13'));

        expect(
          state.updateUserByAdmin(
            id: 'u-user-2',
            name: 'Budi Baru',
            email: 'budi@gmail.com',
            role: 'admin',
          ),
          isNull,
        );
        final promoted = state.users.firstWhere(
          (user) => user.id == 'u-user-2',
        );
        expect(promoted.name, 'Budi Baru');
        expect(promoted.role, 'admin');

        expect(state.deleteUserByAdmin('u-user-1'), isNull);
        expect(state.users.any((user) => user.id == 'u-user-1'), isFalse);
        expect(
          state.lokasis.any((lokasi) => lokasi.userId == 'u-user-1'),
          isFalse,
        );
      },
    );

    test('reset password OTP membatasi percobaan dan mengganti password', () {
      final state = SplwState();

      expect(state.requestPasswordReset('traveler@gmail.com'), isNull);
      expect(
        state.resetPassword(
          email: 'traveler@gmail.com',
          otp: '000000',
          newPassword: 'password456',
          confirmPassword: 'password456',
        ),
        contains('Sisa percobaan: 4'),
      );
      expect(
        state.resetPassword(
          email: 'traveler@gmail.com',
          otp: SplwState.demoOtpCode,
          newPassword: 'password456',
          confirmPassword: 'password456',
        ),
        isNull,
      );
      expect(
        state.login(email: 'traveler@gmail.com', password: 'password123'),
        'Email atau password salah.',
      );
      expect(
        state.login(email: 'traveler@gmail.com', password: 'password456'),
        isNull,
      );
    });
  });

  group('SPLW widget flows', () {
    testWidgets('tamu melihat peta, wajib login, dan bisa membuka registrasi', (
      tester,
    ) async {
      await _pumpPrototype(tester);

      expect(find.byKey(const Key('map_search_field')), findsOneWidget);
      expect(find.byKey(const Key('nav_admin')), findsNothing);

      await tester.tap(find.byKey(const Key('map_save_button')));
      await tester.pumpAndSettle();
      expect(find.text('Login Diperlukan (BR-01)'), findsOneWidget);

      await tester.tap(find.byKey(const Key('map_save_login')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login_email')), findsOneWidget);

      await tester.tap(find.text('Daftar').last);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('register_name')), findsOneWidget);
    });

    testWidgets('reset password OTP dapat diselesaikan dari layar login', (
      tester,
    ) async {
      await _pumpPrototype(tester);

      await tester.tap(find.byKey(const Key('nav_tersimpan')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('saved_guest_login')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('forgot_password')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('forgot_email')), findsOneWidget);
      await tester.tap(find.byKey(const Key('forgot_request')));
      await tester.pumpAndSettle();
      expect(find.text('Masukkan kode OTP'), findsOneWidget);

      for (var i = 0; i < SplwState.demoOtpCode.length; i++) {
        await tester.enterText(
          find.byKey(Key('otp_${i + 1}')),
          SplwState.demoOtpCode[i],
        );
      }
      await tester.ensureVisible(find.byKey(const Key('reset_new_password')));
      await tester.enterText(
        find.byKey(const Key('reset_new_password')),
        'password456',
      );
      await tester.ensureVisible(
        find.byKey(const Key('reset_confirm_password')),
      );
      await tester.enterText(
        find.byKey(const Key('reset_confirm_password')),
        'password456',
      );
      await tester.ensureVisible(find.byKey(const Key('reset_submit')));
      await tester.tap(find.byKey(const Key('reset_submit')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Password berhasil direset'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('login_password')),
        'password456',
      );
      await tester.ensureVisible(find.byKey(const Key('login_submit')));
      await tester.tap(find.byKey(const Key('login_submit')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('nav_admin')), findsNothing);
    });

    testWidgets('user dapat menyimpan lokasi baru dari peta', (tester) async {
      await _pumpPrototype(tester);
      await _loginDemo(tester, 'demo_user');

      await tester.tap(find.byKey(const Key('nav_peta')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('quick_chip_Raja Ampat')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('map_save_button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('form_nama')),
        'Raja Ampat Test',
      );
      await tester.ensureVisible(find.byKey(const Key('form_save_button')));
      await tester.tap(find.byKey(const Key('form_save_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav_tersimpan')));
      await tester.pumpAndSettle();
      expect(find.text('Raja Ampat Test'), findsOneWidget);
    });

    testWidgets('admin melihat ringkasan, pengguna, dan log aktivitas', (
      tester,
    ) async {
      await _pumpPrototype(tester);
      await _loginDemo(tester, 'demo_admin');

      expect(find.byKey(const Key('nav_admin')), findsOneWidget);
      await tester.tap(find.byKey(const Key('nav_admin')));
      await tester.pumpAndSettle();
      expect(find.text('Menu Admin'), findsOneWidget);
      expect(find.byKey(const Key('admin_stat_users')), findsOneWidget);
      expect(find.byKey(const Key('admin_stat_locations')), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('admin_menu_users')));
      await tester.tap(find.byKey(const Key('admin_menu_users')));
      await tester.pumpAndSettle();
      expect(find.text('Kelola Pengguna'), findsOneWidget);
      expect(find.byKey(const Key('admin_user_u-user-2')), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('admin_menu_logs')));
      await tester.tap(find.byKey(const Key('admin_menu_logs')));
      await tester.pumpAndSettle();
      expect(find.text('Log Aktivitas'), findsOneWidget);
      expect(find.byKey(const Key('admin_log_filter_Semua')), findsOneWidget);
    });
  });
}

Future<void> _pumpPrototype(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const SplwPrototypeApp());
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Future<void> _loginDemo(WidgetTester tester, String demoKey) async {
  await tester.tap(find.byKey(const Key('nav_tersimpan')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('saved_guest_login')));
  await tester.pumpAndSettle();

  final demo = find.byKey(Key(demoKey));
  await tester.ensureVisible(demo);
  await tester.pumpAndSettle();
  await tester.tap(demo);
  await tester.pumpAndSettle();

  final submit = find.byKey(const Key('login_submit'));
  await tester.ensureVisible(submit);
  await tester.pumpAndSettle();
  await tester.tap(submit);
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}
