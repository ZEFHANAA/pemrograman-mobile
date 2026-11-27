import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../pert8/data/health_service.dart';
import '../models/aktivitas_cloud.dart';
import 'api_response_exception.dart';

/// Lapisan layanan REST API `/kegiatan` untuk TabungKu Cloud (Pertemuan 9).
class AktivitasCloudApi {
  AktivitasCloudApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _overrideBaseUrl = baseUrl;

  final http.Client _client;
  final String? _overrideBaseUrl;
  final HealthService _healthService = HealthService();

  static const _jsonHeaders = {'Content-Type': 'application/json'};
  static const _timeout = Duration(seconds: 10);

  Future<Uri> _buildUri(String path, [Map<String, String>? query]) async {
    final base = (_overrideBaseUrl ?? await _healthService.getApiUrl())
        .replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse('$base$path');
    return (query == null || query.isEmpty)
        ? uri
        : uri.replace(queryParameters: query);
  }

  http.Response _ensureSuccess(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiResponseException.fromResponse(res);
    }
    return res;
  }

  Future<List<AktivitasCloud>> daftar({
    String? tanggal,
    bool? selesai,
    String? urut,
  }) async {
    final query = <String, String>{};
    if (tanggal != null && tanggal.isNotEmpty) query['tanggal'] = tanggal;
    if (selesai != null) query['selesai'] = selesai.toString();
    if (urut != null && urut.isNotEmpty) query['urut'] = urut;

    final uri = await _buildUri('/kegiatan', query);
    final res = _ensureSuccess(await _client.get(uri).timeout(_timeout));
    final data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((e) => AktivitasCloud.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AktivitasCloud> tambah(AktivitasCloud item) async {
    final uri = await _buildUri('/kegiatan');
    final res = _ensureSuccess(
      await _client
          .post(uri, headers: _jsonHeaders, body: jsonEncode(item.toJson()))
          .timeout(_timeout),
    );
    return AktivitasCloud.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  Future<AktivitasCloud> ubah(AktivitasCloud item) async {
    final uri = await _buildUri('/kegiatan/${item.id}');
    final res = _ensureSuccess(
      await _client
          .put(uri, headers: _jsonHeaders, body: jsonEncode(item.toJson()))
          .timeout(_timeout),
    );
    return AktivitasCloud.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  Future<AktivitasCloud> setSelesai(int id, bool selesai) async {
    final uri = await _buildUri('/kegiatan/$id');
    final res = _ensureSuccess(
      await _client
          .patch(
            uri,
            headers: _jsonHeaders,
            body: jsonEncode({'selesai': selesai}),
          )
          .timeout(_timeout),
    );
    return AktivitasCloud.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  Future<void> hapus(int id) async {
    final uri = await _buildUri('/kegiatan/$id');
    _ensureSuccess(await _client.delete(uri).timeout(_timeout));
  }
}
