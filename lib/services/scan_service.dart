import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/prediction_model.dart';

class ScanService {
  Map<String, String> _headers(String token) => {
    'Accept':        'application/json',
    'Authorization': 'Bearer $token',
  };

  // POST scan gambar ke API Laravel
  Future<PredictionResult> predict({
    required String token,
    required File   imageFile,
  }) async {
    final req = http.MultipartRequest(
      'POST', Uri.parse(ApiConfig.predict),
    );
    req.headers.addAll(_headers(token));
    req.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamed = await req.send();
    final res      = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(res.body)['data']);
    }
    throw Exception('Prediksi gagal: ${res.body}');
  }
  
  // GET histori prediksi user, dengan opsi pencarian
Future<List<PredictionResult>> getHistory(String token, {String? search}) async {
  final uri = Uri.parse(ApiConfig.history).replace(
    queryParameters: (search != null && search.isNotEmpty)
        ? {'search': search}
        : null,
  );
  final res = await http.get(uri, headers: _headers(token));
  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body)['data'];
    return data.map((e) => PredictionResult.fromJson(e)).toList();
  }
  throw Exception('Gagal memuat histori');
}

}

