import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pemmob/pert7/models/aktivitas_tabungan.dart';
import 'package:pemmob/pert9/models/aktivitas_cloud.dart';
import 'package:pemmob/pert9/services/aktivitas_cloud_api.dart';
import 'package:pemmob/pert9/services/api_response_exception.dart';
import 'package:pemmob/pert9/services/laporan_cloud_api.dart';

Map<String, dynamic> _sampleJson({int id = 1, bool selesai = false}) => {
      'id': id,
      'judul': 'Makan siang',
      'tanggal': '2026-10-06',
      'selesai': selesai,
      'tipe': 'pengeluaran',
      'nominal': 15000,
      'kategori': 'Makan',
      'created_at': '2026-10-06T08:00:00',
      'updated_at': '2026-10-06T08:00:00',
    };

void main() {
  group('AktivitasCloudApi', () {
    test('fromJson dan toJson memetakan field dengan benar', () {
      final item = AktivitasCloud.fromJson(_sampleJson());
      expect(item.id, 1);
      expect(item.tipe, JenisKeuangan.pengeluaran);
      expect(item.toJson()['selesai'], isFalse);
      expect(item.toJson().containsKey('id'), isFalse);
    });

    test('daftar mengirim filter tanggal ke query parameter', () async {
      final api = AktivitasCloudApi(
        baseUrl: 'http://uji',
        client: MockClient((req) async {
          expect(req.method, 'GET');
          expect(req.url.toString(), 'http://uji/kegiatan?tanggal=2026-10-06');
          return http.Response(
            jsonEncode([_sampleJson(), _sampleJson(id: 2)]),
            200,
          );
        }),
      );
      final list = await api.daftar(tanggal: '2026-10-06');
      expect(list.map((e) => e.id), [1, 2]);
    });

    test('tambah mengirim JSON dan membaca respons 201', () async {
      final api = AktivitasCloudApi(
        baseUrl: 'http://uji',
        client: MockClient((req) async {
          expect(req.method, 'POST');
          expect(req.headers['Content-Type'], startsWith('application/json'));
          final body = jsonDecode(req.body) as Map<String, dynamic>;
          expect(body['nominal'], 15000);
          return http.Response(jsonEncode(_sampleJson(id: 7)), 201);
        }),
      );
      final created = await api.tambah(AktivitasCloud.fromJson(_sampleJson()));
      expect(created.id, 7);
    });

    test('setSelesai mengirim PATCH hanya field selesai', () async {
      final api = AktivitasCloudApi(
        baseUrl: 'http://uji',
        client: MockClient((req) async {
          expect(req.method, 'PATCH');
          expect(req.url.path, '/kegiatan/3');
          expect(jsonDecode(req.body), {'selesai': true});
          return http.Response(
            jsonEncode(_sampleJson(id: 3, selesai: true)),
            200,
          );
        }),
      );
      final updated = await api.setSelesai(3, true);
      expect(updated.selesai, isTrue);
    });

    test('pesan validasi 422 dibaca dari detail', () async {
      final api = AktivitasCloudApi(
        baseUrl: 'http://uji',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'detail': [
                {
                  'loc': ['body'],
                  'msg': 'Value error, nominal wajib lebih dari 0',
                },
              ],
            }),
            422,
          ),
        ),
      );
      expect(
        () => api.tambah(AktivitasCloud.fromJson(_sampleJson())),
        throwsA(
          isA<ApiResponseException>()
              .having((e) => e.kode, 'kode', 422)
              .having((e) => e.pesan, 'pesan', 'nominal wajib lebih dari 0'),
        ),
      );
    });

    test('404 menghasilkan ApiResponseException dengan kode 404', () async {
      final api = AktivitasCloudApi(
        baseUrl: 'http://uji',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'detail': 'Kegiatan tidak ditemukan'}),
            404,
          ),
        ),
      );
      expect(
        () => api.hapus(99),
        throwsA(isA<ApiResponseException>().having((e) => e.kode, 'kode', 404)),
      );
    });
  });

  group('LaporanCloudApi', () {
    test('harian membaca ringkasan dan pengeluaran per kategori', () async {
      final api = LaporanCloudApi(
        baseUrl: 'http://uji',
        client: MockClient((req) async {
          expect(
            req.url.toString(),
            'http://uji/laporan/harian?tanggal=2026-10-05',
          );
          return http.Response(
            jsonEncode({
              'tanggal': '2026-10-05',
              'jumlah_kegiatan': 4,
              'selesai': 2,
              'pemasukan': 50000,
              'pengeluaran': 25000,
              'tabungan': 25000,
              'per_kategori': [
                {'kategori': 'Makan', 'total': 15000},
                {'kategori': 'Transport', 'total': 10000},
              ],
            }),
            200,
          );
        }),
      );
      final report = await api.harian('2026-10-05');
      expect(report.ringkasan.jumlahKegiatan, 4);
      expect(report.ringkasan.selesai, 2);
      expect(report.ringkasan.tabungan, 25000);
      expect(report.perKategori, {'Makan': 15000, 'Transport': 10000});
    });

    test('rentang memetakan tanggal menjadi DateTime', () async {
      final api = LaporanCloudApi(
        baseUrl: 'http://uji',
        client: MockClient((req) async {
          expect(req.url.queryParameters, {
            'mulai': '2026-10-04',
            'sampai': '2026-10-05',
          });
          Map<String, Object> day(String t, int masuk) => {
                'tanggal': t,
                'jumlah_kegiatan': masuk == 0 ? 0 : 1,
                'selesai': 0,
                'pemasukan': masuk,
                'pengeluaran': 0,
                'tabungan': masuk,
              };
          return http.Response(
            jsonEncode([day('2026-10-04', 0), day('2026-10-05', 50000)]),
            200,
          );
        }),
      );
      final items = await api.rentang(
        DateTime(2026, 10, 4),
        DateTime(2026, 10, 5),
      );
      expect(items.length, 2);
      expect(items.last.key, DateTime(2026, 10, 5));
      expect(items.last.value.pemasukan, 50000);
    });

    test('rentang terlalu panjang ditolak server dengan kode 400', () async {
      final api = LaporanCloudApi(
        baseUrl: 'http://uji',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'detail': 'Rentang maksimal 31 hari'}),
            400,
          ),
        ),
      );
      expect(
        () => api.rentang(DateTime(2026, 1, 1), DateTime(2026, 3, 1)),
        throwsA(isA<ApiResponseException>().having((e) => e.kode, 'kode', 400)),
      );
    });
  });
}
