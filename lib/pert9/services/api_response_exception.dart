import 'dart:convert';

import 'package:http/http.dart' as http;

/// Menerjemahkan respons galat FastAPI (HTTPException & 422 Pydantic) ke pesan UI.
class ApiResponseException implements Exception {
  const ApiResponseException(this.pesan, {this.kode});

  final int? kode;
  final String pesan;

  factory ApiResponseException.fromResponse(http.Response res) {
    String pesan = 'Server membalas kode ${res.statusCode}';
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail'];
        if (detail is String) {
          pesan = detail;
        } else if (detail is List) {
          pesan = detail
              .map(
                (e) => ((e as Map<String, dynamic>)['msg'] as String)
                    .replaceFirst('Value error, ', ''),
              )
              .join('\n');
        }
      }
    } catch (_) {
      // Abaikan jika body bukan JSON (misal 502 dari proxy).
    }
    return ApiResponseException(pesan, kode: res.statusCode);
  }

  @override
  String toString() => pesan;
}
