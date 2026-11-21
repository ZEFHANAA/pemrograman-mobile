import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const defaultApiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:8000',
);

class ServerHealth {
  const ServerHealth({
    required this.apiAvailable,
    required this.databaseAvailable,
    required this.serverTime,
    required this.latency,
    this.mysqlVersion,
    this.detail,
  });

  final bool apiAvailable;
  final bool databaseAvailable;
  final String serverTime;
  final Duration latency;
  final String? mysqlVersion;
  final String? detail;
}

class HealthService {
  static final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<String> getApiUrl() async =>
      await _preferences.getString('tabungku_api_url') ?? defaultApiUrl;

  Future<void> saveApiUrl(String value) =>
      _preferences.setString('tabungku_api_url', value.replaceAll(RegExp(r'/+$'), ''));

  Future<ServerHealth> check({http.Client? client}) async {
    final activeClient = client ?? http.Client();
    final stopwatch = Stopwatch()..start();
    try {
      final baseUrl = await getApiUrl();
      final response = await activeClient
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 10));
      stopwatch.stop();
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Respons status server bukan JSON object.');
      }
      if (response.statusCode == 503) {
        final detail = decoded['detail'];
        final data = detail is Map<String, dynamic> ? detail : decoded;
        return ServerHealth(
          apiAvailable: true,
          databaseAvailable: false,
          serverTime: data['waktu_server']?.toString() ?? '-',
          latency: stopwatch.elapsed,
          detail: data['detail']?.toString() ?? 'Database tidak tersedia.',
        );
      }
      if (response.statusCode != 200) {
        throw Exception('Server membalas HTTP ${response.statusCode}.');
      }
      return ServerHealth(
        apiAvailable: true,
        databaseAvailable: decoded['database'] == 'ok',
        serverTime: decoded['waktu_server']?.toString() ?? '-',
        latency: stopwatch.elapsed,
        mysqlVersion: decoded['mysql_version']?.toString(),
        detail: decoded['database'] == 'ok' ? null : 'Database belum terkonfirmasi.',
      );
    } finally {
      if (client == null) activeClient.close();
    }
  }
}
