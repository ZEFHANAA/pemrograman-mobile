import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../pert8/data/health_service.dart';
import '../models/aktivitas_cloud.dart';
import 'api_response_exception.dart';

/// Lapisan layanan REST API `/laporan` (harian & rentang) untuk Pertemuan 9.
class LaporanCloudApi {
  LaporanCloudApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _overrideBaseUrl = baseUrl;

  final http.Client _client;
  final String? _overrideBaseUrl;
  final HealthService _healthService = HealthService();

  static const _timeout = Duration(seconds: 10);

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  Future<dynamic> _getJson(String path, Map<String, String> query) async {
    final base = (_overrideBaseUrl ?? await _healthService.getApiUrl())
        .replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse('$base$path').replace(queryParameters: query);
    final res = await _client.get(uri).timeout(_timeout);
    if (res.statusCode != 200) {
      throw ApiResponseException.fromResponse(res);
    }
    return jsonDecode(res.body);
  }

  Future<LaporanHarianCloud> harian(String tanggal) async {
    final json = await _getJson('/laporan/harian', {'tanggal': tanggal});
    return LaporanHarianCloud.fromJson(json as Map<String, dynamic>);
  }

  Future<List<MapEntry<DateTime, RingkasanCloud>>> rentang(
    DateTime mulai,
    DateTime sampai,
  ) async {
    final json = await _getJson('/laporan/rentang', {
      'mulai': _formatDate(mulai),
      'sampai': _formatDate(sampai),
    });
    return [
      for (final item in json as List<dynamic>)
        MapEntry(
          DateTime.parse((item as Map<String, dynamic>)['tanggal'] as String),
          RingkasanCloud.fromJson(item),
        ),
    ];
  }
}
