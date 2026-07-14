class PredictionResult {
  final int?    id;
  final String  namaGambar;
  final String  namaPenyakit;
  final String  deskripsi;
  final String  penanganan;
  final double  confidence;
  final String  imageUrl;
  final String  createdAt;

  PredictionResult({
    this.id,
    required this.namaGambar,
    required this.namaPenyakit,
    required this.deskripsi,
    required this.penanganan,
    required this.confidence,
    required this.imageUrl,
    required this.createdAt,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      id:           json['id'],
      namaGambar:   json['nama_gambar'] ?? '',
      namaPenyakit: json['nama_penyakit'] ?? '',
      deskripsi:    json['deskripsi'] ?? '',
      penanganan:   json['penanganan'] ?? '',
      confidence: double.tryParse(
        json['confidence'].toString(),
      ) ?? 0.0,
      imageUrl:     json['image_url'] ?? '',
      createdAt:    json['created_at'] ?? '',
    );
  }
}

