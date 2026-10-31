import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/splw_models.dart';

class SplwState with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  final List<String> _searchHistory = [];
  final List<UserModel> _users = [];
  final Map<String, String> _passwords = {};
  final List<LokasiModel> _lokasis = [];
  final List<ActivityLogModel> _logs = [];

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  String? _otpEmail;
  String? _otpCode;
  DateTime? _otpExpiresAt;
  int _otpAttempts = 0;

  static const String demoOtpCode = '482917';
  static const int maxOtpAttempts = 5;
  static const int maxSearchHistory = 6;

  SplwState() {
    _seedDemoData();
  }

  void _seedDemoData() {
    _themeMode = ThemeMode.system;
    _searchHistory
      ..clear()
      ..addAll(['Borobudur', 'Pantai Kuta', 'Gunung Bromo']);

    _users
      ..clear()
      ..addAll([
        UserModel(
          id: 'u-admin-1',
          name: 'Admin SPLW',
          email: 'admin@splw.app',
          role: 'admin',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        UserModel(
          id: 'u-user-1',
          name: 'Traveler Nusantara',
          email: 'traveler@gmail.com',
          role: 'user',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        UserModel(
          id: 'u-user-2',
          name: 'Budi Santoso',
          email: 'budi@gmail.com',
          role: 'user',
          isActive: false,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ]);

    _passwords
      ..clear()
      ..addAll({
        'admin@splw.app': 'admin123',
        'traveler@gmail.com': 'password123',
        'budi@gmail.com': 'password123',
      });

    _lokasis
      ..clear()
      ..addAll([
        LokasiModel(
          id: 'lok-1',
          userId: 'u-admin-1',
          namaLokasi: 'Candi Borobudur',
          latitude: -7.6079,
          longitude: 110.2038,
          kategori: 'Budaya',
          deskripsi: 'Candi Buddha abad ke-8 termegah di dunia dengan relief indah dan stupa megah di Magelang.',
          shareToken: 'share-borobudur-2026',
        ),
        LokasiModel(
          id: 'lok-2',
          userId: 'u-admin-1',
          namaLokasi: 'Raja Ampat',
          latitude: -0.5367,
          longitude: 130.5594,
          kategori: 'Pantai',
          deskripsi: 'Gugusan kepulauan karang eksotis di Papua Barat Daya dengan keanekaragaman biota laut terlengkap dunia.',
        ),
        LokasiModel(
          id: 'lok-3',
          userId: 'u-user-1',
          namaLokasi: 'Gunung Bromo',
          latitude: -7.9425,
          longitude: 112.9530,
          kategori: 'Gunung',
          deskripsi: 'Lautan pasir berbisik dan kawah aktif spektakuler di kawasan Taman Nasional Bromo Tengger Semeru.',
        ),
        LokasiModel(
          id: 'lok-4',
          userId: 'u-user-1',
          namaLokasi: 'Danau Toba',
          latitude: 2.6845,
          longitude: 98.8756,
          kategori: 'Alam',
          deskripsi: 'Danau vulkanik terbesar di Asia Tenggara dengan Pulau Samosir di tengahnya yang sarat budaya Batak.',
        ),
        LokasiModel(
          id: 'lok-5',
          userId: 'u-admin-1',
          namaLokasi: 'Monumen Nasional (Monas)',
          latitude: -6.1754,
          longitude: 106.8272,
          kategori: 'Kota',
          deskripsi: 'Ikon kebanggaan ibu kota Jakarta dengan tugu setinggi 132 meter berlapis lidah api emas murni.',
        ),
      ]);

    _logs
      ..clear()
      ..addAll([
        ActivityLogModel(
          id: 'log-1',
          userId: 'u-admin-1',
          userName: 'Admin SPLW',
          action: 'ADMIN_TOGGLE_STATUS',
          entity: 'user',
          entityId: 'u-user-2',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        ActivityLogModel(
          id: 'log-2',
          userId: 'u-user-1',
          userName: 'Traveler Nusantara',
          action: 'CREATE',
          entity: 'lokasi',
          entityId: 'lok-3',
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        ActivityLogModel(
          id: 'log-3',
          userId: 'u-admin-1',
          userName: 'Admin SPLW',
          action: 'CREATE',
          entity: 'lokasi',
          entityId: 'lok-1',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        ActivityLogModel(
          id: 'log-4',
          userId: 'u-admin-1',
          userName: 'Admin SPLW',
          action: 'LOGIN',
          entity: 'auth',
          createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
      ]);

    _currentUser = null;
    _otpEmail = null;
    _otpCode = null;
    _otpExpiresAt = null;
    _otpAttempts = 0;
  }

  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  List<UserModel> get users => List.unmodifiable(_users);
  List<LokasiModel> get lokasis => List.unmodifiable(_lokasis);
  List<ActivityLogModel> get logs => List.unmodifiable(_logs);

  int get totalUsers => _users.length;
  int get totalLokasi => _lokasis.length;
  double get averageLokasiPerUser =>
      _users.isEmpty ? 0 : _lokasis.length / _users.length;

  UserModel? get mostActiveUser {
    if (_users.isEmpty || _lokasis.isEmpty) return null;
    final counts = <String, int>{};
    for (final lokasi in _lokasis) {
      counts[lokasi.userId] = (counts[lokasi.userId] ?? 0) + 1;
    }
    UserModel? result;
    var maxCount = 0;
    for (final user in _users) {
      final count = counts[user.id] ?? 0;
      if (count > maxCount) {
        maxCount = count;
        result = user;
      }
    }
    return result;
  }

  String? get topCategory {
    if (_lokasis.isEmpty) return null;
    final counts = <String, int>{};
    for (final lokasi in _lokasis) {
      counts[lokasi.kategori] = (counts[lokasi.kategori] ?? 0) + 1;
    }
    String? result;
    var maxCount = 0;
    for (final entry in counts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        result = entry.key;
      }
    }
    return result;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void addSearchHistory(String query) {
    final clean = query.trim();
    if (clean.isEmpty) return;
    _searchHistory.remove(clean);
    _searchHistory.insert(0, clean);
    if (_searchHistory.length > maxSearchHistory) {
      _searchHistory.removeLast();
    }
    notifyListeners();
  }

  void removeSearchHistory(String query) {
    _searchHistory.remove(query);
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  String? login({required String email, required String password}) {
    final normalized = _normalizeEmail(email);
    if (normalized.isEmpty) return 'Email wajib diisi.';
    if (password.isEmpty) return 'Password wajib diisi.';

    final index = _users.indexWhere(
      (user) => _normalizeEmail(user.email) == normalized,
    );
    if (index == -1 || _passwords[normalized] != password) {
      return 'Email atau password salah.';
    }

    final user = _users[index];
    if (!user.isActive) {
      return 'BR-10: Akun Anda dinonaktifkan oleh Administrator.';
    }

    _currentUser = user;
    _addLog('LOGIN', 'auth', user.id);
    notifyListeners();
    return null;
  }

  void loginAs(UserModel user) {
    if (!user.isActive) return;
    _currentUser = user;
    _addLog('LOGIN', 'auth', user.id);
    notifyListeners();
  }

  String? register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    final cleanName = name.trim();
    final normalized = _normalizeEmail(email);

    if (cleanName.isEmpty) return 'Nama wajib diisi.';
    if (cleanName.length > 255) return 'Nama maksimal 255 karakter.';
    if (!_isValidEmail(normalized)) return 'Format email tidak valid.';
    if (_users.any((user) => _normalizeEmail(user.email) == normalized)) {
      return 'Email sudah terdaftar.';
    }
    if (password.length < 8) return 'Password minimal 8 karakter.';
    if (password != confirmPassword) {
      return 'Konfirmasi password tidak cocok.';
    }

    final user = UserModel(
      id: 'u-${DateTime.now().millisecondsSinceEpoch}',
      name: cleanName,
      email: normalized,
      role: 'user',
      isActive: true,
      createdAt: DateTime.now(),
    );

    _users.add(user);
    _passwords[normalized] = password;
    _currentUser = user;
    _addLog('REGISTER', 'auth', user.id);
    _addLog('LOGIN', 'auth', user.id);
    notifyListeners();
    return null;
  }

  String? updateProfile({required String name, required String email}) {
    if (_currentUser == null) return 'Harap login terlebih dahulu.';
    final cleanName = name.trim();
    final normalized = _normalizeEmail(email);
    if (cleanName.isEmpty) return 'Nama wajib diisi.';
    if (cleanName.length > 255) return 'Nama maksimal 255 karakter.';
    if (!_isValidEmail(normalized)) return 'Format email tidak valid.';
    if (_users.any(
      (user) =>
          user.id != _currentUser!.id &&
          _normalizeEmail(user.email) == normalized,
    )) {
      return 'Email sudah digunakan akun lain.';
    }

    final index = _users.indexWhere((user) => user.id == _currentUser!.id);
    if (index == -1) return 'Akun tidak ditemukan.';

    final oldEmail = _normalizeEmail(_users[index].email);
    final updated = _users[index].copyWith(name: cleanName, email: normalized);
    _users[index] = updated;
    if (oldEmail != normalized) {
      final password = _passwords.remove(oldEmail);
      if (password != null) _passwords[normalized] = password;
    }
    _currentUser = updated;
    _addLog('UPDATE_PROFILE', 'user', updated.id);
    notifyListeners();
    return null;
  }

  String? changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    if (_currentUser == null) return 'Harap login terlebih dahulu.';
    final email = _normalizeEmail(_currentUser!.email);
    if (_passwords[email] != oldPassword) {
      return 'Password lama tidak sesuai.';
    }
    if (newPassword.length < 8) return 'Password baru minimal 8 karakter.';
    if (newPassword != confirmPassword) {
      return 'Konfirmasi password baru tidak cocok.';
    }
    _passwords[email] = newPassword;
    _addLog('CHANGE_PASSWORD', 'auth', _currentUser!.id);
    notifyListeners();
    return null;
  }

  String? requestPasswordReset(String email) {
    final normalized = _normalizeEmail(email);
    if (!_isValidEmail(normalized)) return 'Format email tidak valid.';
    _otpEmail = normalized;
    _otpCode = demoOtpCode;
    _otpExpiresAt = DateTime.now().add(const Duration(minutes: 15));
    _otpAttempts = 0;
    notifyListeners();
    return null;
  }

  String? resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) {
    final normalized = _normalizeEmail(email);
    if (_otpEmail == null || _otpCode == null) {
      return 'Minta kode OTP terlebih dahulu.';
    }
    if (_otpEmail != normalized) {
      return 'Kode OTP tidak cocok dengan email ini.';
    }
    if (_otpExpiresAt == null || DateTime.now().isAfter(_otpExpiresAt!)) {
      _clearOtp();
      return 'Kode OTP sudah kedaluwarsa. Minta kode baru.';
    }
    if (_otpAttempts >= maxOtpAttempts) {
      _clearOtp();
      return 'Kode OTP terkunci. Minta kode baru.';
    }
    if (newPassword.length < 8) return 'Password baru minimal 8 karakter.';
    if (newPassword != confirmPassword) {
      return 'Konfirmasi password baru tidak cocok.';
    }
    if (otp.trim() != _otpCode) {
      _otpAttempts++;
      if (_otpAttempts >= maxOtpAttempts) {
        _clearOtp();
        return 'Kode OTP salah. Kode terkunci, minta kode baru.';
      }
      return 'Kode OTP salah. Sisa percobaan: ${maxOtpAttempts - _otpAttempts}.';
    }

    final index = _users.indexWhere(
      (user) => _normalizeEmail(user.email) == normalized,
    );
    if (index == -1) {
      _clearOtp();
      return null;
    }

    final user = _users[index];
    _passwords[normalized] = newPassword;
    _otpEmail = null;
    _otpCode = null;
    _otpExpiresAt = null;
    _otpAttempts = 0;
    _addLog('RESET_PASSWORD', 'auth', user.id, actor: user);
    if (_normalizeEmail(_currentUser?.email ?? '') == normalized) {
      _currentUser = null;
    }
    notifyListeners();
    return null;
  }

  void logout() {
    if (_currentUser != null) {
      _addLog('LOGOUT', 'auth', _currentUser!.id);
    }
    _currentUser = null;
    notifyListeners();
  }

  void switchDemoRole(String role) {
    if (role == 'guest') {
      _currentUser = null;
      _addLog('DEMO_ROLE_GUEST', 'auth', null);
    } else if (role == 'admin') {
      final admin = _firstUserByRole('admin');
      if (admin == null) return;
      _currentUser = admin;
      _addLog('DEMO_ROLE_ADMIN', 'auth', admin.id);
    } else {
      final user = _firstUserByRole('user');
      if (user == null) return;
      _currentUser = user;
      _addLog('DEMO_ROLE_USER', 'auth', user.id);
    }
    notifyListeners();
  }

  bool isDuplicateCoordinate(
    double lat,
    double lng, {
    String? excludeLokasiId,
    String? ownerId,
  }) {
    final effectiveOwner = ownerId ?? _currentUser?.id;
    if (effectiveOwner == null) return false;
    final roundedLat = _roundCoordinate(lat);
    final roundedLng = _roundCoordinate(lng);

    return _lokasis.any((lokasi) {
      if (lokasi.id == excludeLokasiId) return false;
      if (lokasi.userId != effectiveOwner) return false;
      return _roundCoordinate(lokasi.latitude) == roundedLat &&
          _roundCoordinate(lokasi.longitude) == roundedLng;
    });
  }

  String? saveLokasi({
    required String nama,
    required double lat,
    required double lng,
    required String deskripsi,
    String? kategori,
  }) {
    if (_currentUser == null) {
      return 'BR-01: Pengunjung wajib login sebelum dapat menyimpan lokasi.';
    }

    final kat = (kategori == null || kategori.trim().isEmpty)
        ? 'Lainnya'
        : kategori.trim();
    final validation = _validateLokasiFields(
      nama: nama,
      kategori: kat,
      deskripsi: deskripsi,
      lat: lat,
      lng: lng,
    );
    if (validation != null) return validation;

    if (isDuplicateCoordinate(lat, lng)) {
      return 'BR-09: Koordinat ini sudah pernah disimpan dalam daftar pribadi Anda (dibulatkan 4 desimal).';
    }

    final newLokasi = LokasiModel(
      id: 'lok-${DateTime.now().microsecondsSinceEpoch}',
      userId: _currentUser!.id,
      namaLokasi: nama.trim(),
      latitude: lat,
      longitude: lng,
      deskripsi: deskripsi.trim(),
      kategori: kat,
    );

    _lokasis.insert(0, newLokasi);
    _addLog('CREATE', 'lokasi', newLokasi.id);
    notifyListeners();
    return null;
  }

  String? updateLokasi({
    required String id,
    required String nama,
    required double lat,
    required double lng,
    required String deskripsi,
    required String kategori,
  }) {
    if (_currentUser == null) return 'Harap login terlebih dahulu.';

    final index = _lokasis.indexWhere((lokasi) => lokasi.id == id);
    if (index == -1) return 'Lokasi tidak ditemukan.';

    final target = _lokasis[index];
    if (target.userId != _currentUser!.id && !isAdmin) {
      return 'BR-02: Anda tidak berwenang mengubah lokasi milik pengguna lain.';
    }

    final validation = _validateLokasiFields(
      nama: nama,
      kategori: kategori,
      deskripsi: deskripsi,
      lat: lat,
      lng: lng,
    );
    if (validation != null) return validation;

    if (isDuplicateCoordinate(
      lat,
      lng,
      excludeLokasiId: id,
      ownerId: target.userId,
    )) {
      return 'BR-09: Koordinat duplikat dengan lokasi lain milik pengguna ini.';
    }

    _lokasis[index] = target.copyWith(
      namaLokasi: nama.trim(),
      latitude: lat,
      longitude: lng,
      deskripsi: deskripsi.trim(),
      kategori: kategori,
      updatedAt: DateTime.now(),
    );

    _addLog('UPDATE', 'lokasi', id);
    notifyListeners();
    return null;
  }

  String? deleteLokasi(String id) {
    if (_currentUser == null) return 'Harap login terlebih dahulu.';

    final index = _lokasis.indexWhere((lokasi) => lokasi.id == id);
    if (index == -1) return 'Lokasi tidak ditemukan.';

    final target = _lokasis[index];
    if (target.userId != _currentUser!.id && !isAdmin) {
      return 'BR-02: Anda tidak berwenang menghapus lokasi milik pengguna lain.';
    }

    _lokasis.removeAt(index);
    _addLog('DELETE', 'lokasi', id);
    notifyListeners();
    return null;
  }

  String? deleteAllMyLokasi() {
    if (_currentUser == null) return 'Harap login terlebih dahulu.';
    _lokasis.removeWhere((lokasi) => lokasi.userId == _currentUser!.id);
    _addLog('DELETE_ALL', 'lokasi', _currentUser!.id);
    notifyListeners();
    return null;
  }

  String? enableShareLokasi(String id) {
    if (_currentUser == null) return 'Harap login terlebih dahulu.';
    final index = _lokasis.indexWhere((lokasi) => lokasi.id == id);
    if (index == -1) return 'Lokasi tidak ditemukan.';

    final item = _lokasis[index];
    if (item.userId != _currentUser!.id && !isAdmin) {
      return 'BR-14: Hanya pemilik lokasi yang dapat membuat tautan publik.';
    }
    if (item.shareToken != null) return null;

    final random = math.Random.secure();
    final token = List.generate(
      16,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    _lokasis[index] = item.copyWith(shareToken: token);
    _addLog('SHARE_ENABLE', 'lokasi', id);
    notifyListeners();
    return null;
  }

  String? revokeShareLokasi(String id) {
    if (_currentUser == null) return 'Harap login terlebih dahulu.';
    final index = _lokasis.indexWhere((lokasi) => lokasi.id == id);
    if (index == -1) return 'Lokasi tidak ditemukan.';

    final item = _lokasis[index];
    if (item.userId != _currentUser!.id && !isAdmin) {
      return 'BR-14: Hanya pemilik lokasi yang dapat mencabut tautan publik.';
    }
    if (item.shareToken == null) return null;

    _lokasis[index] = item.copyWith(clearShareToken: true);
    _addLog('SHARE_REVOKE', 'lokasi', id);
    notifyListeners();
    return null;
  }

  String? deleteUserByAdmin(String targetUserId) {
    if (!isAdmin) return 'Akses ditolak: Hanya administrator yang diizinkan.';
    if (_currentUser?.id == targetUserId) {
      return 'BR-13: Administrator tidak dapat menghapus akunnya sendiri.';
    }

    final index = _users.indexWhere((user) => user.id == targetUserId);
    if (index == -1) return 'Pengguna tidak ditemukan.';

    final target = _users[index];
    if (target.role == 'admin' && target.isActive) {
      final activeAdmins = _users
          .where(
            (user) =>
                user.id != targetUserId &&
                user.role == 'admin' &&
                user.isActive,
          )
          .length;
      if (activeAdmins < 1) {
        return 'BR-13: Sistem menolak perubahan yang membuat jumlah admin aktif kurang dari satu.';
      }
    }

    final deletedUserName = target.name;
    _lokasis.removeWhere((lokasi) => lokasi.userId == targetUserId);
    _users.removeAt(index);
    _passwords.remove(_normalizeEmail(target.email));

    for (var i = 0; i < _logs.length; i++) {
      if (_logs[i].userId == targetUserId) {
        _logs[i] = ActivityLogModel(
          id: _logs[i].id,
          userId: null,
          userName: '$deletedUserName (akun dihapus)',
          action: _logs[i].action,
          entity: _logs[i].entity,
          entityId: _logs[i].entityId,
          ipAddress: _logs[i].ipAddress,
          createdAt: _logs[i].createdAt,
        );
      }
    }

    _addLog('ADMIN_DELETE_USER', 'user', targetUserId);
    notifyListeners();
    return null;
  }

  String? toggleUserStatusByAdmin(String targetUserId) {
    if (!isAdmin) return 'Hanya admin yang dapat mengubah status pengguna.';
    if (_currentUser?.id == targetUserId) {
      return 'BR-13: Administrator tidak dapat menonaktifkan akunnya sendiri.';
    }

    final index = _users.indexWhere((user) => user.id == targetUserId);
    if (index == -1) return 'Pengguna tidak ditemukan.';

    final user = _users[index];
    if (user.role == 'admin' && user.isActive) {
      final activeAdmins = _users
          .where(
            (item) =>
                item.id != targetUserId &&
                item.role == 'admin' &&
                item.isActive,
          )
          .length;
      if (activeAdmins < 1) {
        return 'BR-13: Sistem menolak perubahan yang membuat jumlah admin aktif kurang dari satu.';
      }
    }

    _users[index] = user.copyWith(isActive: !user.isActive);
    _addLog('ADMIN_TOGGLE_STATUS', 'user', targetUserId);
    notifyListeners();
    return null;
  }

  String? updateUserByAdmin({
    required String id,
    required String name,
    required String email,
    required String role,
  }) {
    if (!isAdmin) return 'Akses ditolak: Hanya administrator yang diizinkan.';
    final cleanName = name.trim();
    final normalized = _normalizeEmail(email);

    if (cleanName.isEmpty) return 'Nama wajib diisi.';
    if (cleanName.length > 255) return 'Nama maksimal 255 karakter.';
    if (!_isValidEmail(normalized)) return 'Format email tidak valid.';
    if (role != 'admin' && role != 'user') return 'Role tidak valid.';
    if (_users.any(
      (user) => user.id != id && _normalizeEmail(user.email) == normalized,
    )) {
      return 'Email sudah digunakan akun lain.';
    }

    final index = _users.indexWhere((user) => user.id == id);
    if (index == -1) return 'Pengguna tidak ditemukan.';

    final target = _users[index];
    final isSelf = _currentUser?.id == id;
    if (isSelf && role != 'admin') {
      return 'BR-13: Administrator tidak dapat menurunkan role akunnya sendiri.';
    }
    if (target.role == 'admin' && target.isActive && role != 'admin') {
      final remainingAdmins = _users
          .where(
            (user) => user.id != id && user.role == 'admin' && user.isActive,
          )
          .length;
      if (remainingAdmins < 1) {
        return 'BR-13: Sistem menolak perubahan yang membuat jumlah admin aktif kurang dari satu.';
      }
    }

    final oldEmail = _normalizeEmail(target.email);
    final updated = target.copyWith(
      name: cleanName,
      email: normalized,
      role: role,
    );
    _users[index] = updated;
    if (oldEmail != normalized) {
      final password = _passwords.remove(oldEmail);
      if (password != null) _passwords[normalized] = password;
    }
    if (isSelf) _currentUser = updated;
    _addLog('ADMIN_UPDATE_USER', 'user', id);
    notifyListeners();
    return null;
  }

  void resetDemoData() {
    _seedDemoData();
    notifyListeners();
  }

  void _addLog(
    String action,
    String entity,
    String? entityId, {
    UserModel? actor,
  }) {
    final effectiveActor = actor ?? _currentUser;
    _logs.insert(
      0,
      ActivityLogModel(
        id: 'log-${DateTime.now().microsecondsSinceEpoch}',
        userId: effectiveActor?.id,
        userName: effectiveActor?.name ?? 'Pengunjung (Guest)',
        action: action,
        entity: entity,
        entityId: entityId,
      ),
    );
  }

  void _clearOtp() {
    _otpEmail = null;
    _otpCode = null;
    _otpExpiresAt = null;
    _otpAttempts = 0;
  }

  String? _validateLokasiFields({
    required String nama,
    required String kategori,
    required String deskripsi,
    required double lat,
    required double lng,
  }) {
    if (nama.trim().isEmpty) return 'Nama lokasi wajib diisi.';
    if (nama.trim().length > 255) return 'Nama lokasi maksimal 255 karakter.';
    if (!kPilihanKategoriInput.contains(kategori)) {
      return 'Kategori tidak valid.';
    }
    if (deskripsi.length > 2000) {
      return 'Deskripsi maksimal 2000 karakter.';
    }
    if (lat < -90 || lat > 90) return 'Latitude tidak valid.';
    if (lng < -180 || lng > 180) return 'Longitude tidak valid.';
    return null;
  }

  UserModel? _firstUserByRole(String role) {
    for (final user in _users) {
      if (user.role == role && user.isActive) return user;
    }
    return null;
  }

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  static bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  static double _roundCoordinate(double value) =>
      (value * 10000).round() / 10000;
}
