import 'dart:math' as math;

class LokasiModel {
  final String id;
  final String userId;
  final String namaLokasi;
  final double latitude;
  final double longitude;
  final String deskripsi;
  final String kategori;
  final String? shareToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  LokasiModel({
    required this.id,
    required this.userId,
    required this.namaLokasi,
    required this.latitude,
    required this.longitude,
    required this.deskripsi,
    this.kategori = 'Lainnya',
    this.shareToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  LokasiModel copyWith({
    String? id,
    String? userId,
    String? namaLokasi,
    double? latitude,
    double? longitude,
    String? deskripsi,
    String? kategori,
    String? shareToken,
    bool clearShareToken = false,
    DateTime? updatedAt,
  }) {
    return LokasiModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      namaLokasi: namaLokasi ?? this.namaLokasi,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      deskripsi: deskripsi ?? this.deskripsi,
      kategori: kategori ?? this.kategori,
      shareToken: clearShareToken ? null : (shareToken ?? this.shareToken),
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Menghitung jarak garis lurus (haversine) dalam kilometer
  double hitungJarakKm(double userLat, double userLng) {
    const double r = 6371; // Jari-jari bumi (km)
    final double dLat = _deg2rad(latitude - userLat);
    final double dLng = _deg2rad(longitude - userLng);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(userLat)) *
            math.cos(_deg2rad(latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  static double _deg2rad(double deg) => deg * (math.pi / 180.0);
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'user' | 'admin'
  final bool isActive;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
    required this.createdAt,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    bool? isActive,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}

class ActivityLogModel {
  final String id;
  final String? userId;
  final String userName;
  final String action;
  final String entity;
  final String? entityId;
  final String ipAddress;
  final DateTime createdAt;

  ActivityLogModel({
    required this.id,
    this.userId,
    required this.userName,
    required this.action,
    required this.entity,
    this.entityId,
    this.ipAddress = '127.0.0.1',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// Kategori resmi sesuai aturan bisnis BR-03
const List<String> kDaftarKategori = [
  'Semua',
  'Pantai',
  'Gunung',
  'Kota',
  'Budaya',
  'Kuliner',
  'Alam',
  'Lainnya',
];

/// Kategori pilihan saat menambah/mengedit lokasi (tanpa 'Semua')
const List<String> kPilihanKategoriInput = [
  'Pantai',
  'Gunung',
  'Kota',
  'Budaya',
  'Kuliner',
  'Alam',
  'Lainnya',
];
