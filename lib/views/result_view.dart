import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
import 'dart:io';

class ResultView extends StatelessWidget {
  const ResultView({super.key});

  Color _severityColor(String disease) {
    const severe   = ['Blas', 'Hawar Daun', 'Tungro'];
    const moderate = ['Bercak Coklat', 'Kresek'];
    if (severe.any((d) => disease.contains(d)))   return AppColors.error;
    if (moderate.any((d) => disease.contains(d))) return AppColors.warning;
    return AppColors.success;  // Sehat / ringan
  }

  String _severityLabel(String disease) {
    const severe   = ['Blas', 'Hawar Daun', 'Tungro'];
    const moderate = ['Bercak Coklat', 'Kresek'];
    if (severe.any((d) => disease.contains(d)))   return 'Parah';
    if (moderate.any((d) => disease.contains(d))) return 'Sedang';
    return 'Ringan / Sehat';
  }

  @override
  Widget build(BuildContext context) {
    final prov   = context.read<ScanProvider>();
    final result = prov.lastResult!;
    final color  = _severityColor(result.namaPenyakit);

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Analisis')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Gambar yang discan
          if (prov.selectedImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(prov.selectedImage!,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            ).animate().fadeIn(duration: 500.ms),
          const SizedBox(height: 20),

          // Badge penyakit
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.4), width: 2),
            ),
            child: Column(children: [
              Text('Terdeteksi:',
                style: TextStyle(color: color, fontSize: 13,
                  fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(result.namaPenyakit,
                style: TextStyle(color: color, fontSize: 24,
                  fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_severityLabel(result.namaPenyakit)}  •  ${(result.confidence * 100).toStringAsFixed(1)}% akurasi',
                  style: const TextStyle(color: Colors.white, fontSize: 12,
                    fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ).animate().scale(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 16),

          // Deskripsi
          PadiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(Icons.info_outline, 'Deskripsi Penyakit'),
              const SizedBox(height: 8),
              Text(result.deskripsi,
                style: const TextStyle(height: 1.6,
                  color: AppColors.textSecondary)),
            ],
          )).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 12),

          // Penanganan
          PadiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(Icons.healing_outlined, 'Rekomendasi Penanganan'),
              const SizedBox(height: 8),
              Text(result.penanganan,
                style: const TextStyle(height: 1.6,
                  color: AppColors.textSecondary)),
            ],
          )).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 24),

          // Tombol scan lagi
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Scan Gambar Lain'),
          ),
        ]),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String text) => Row(children: [
    Icon(icon, color: AppColors.primary, size: 20),
    const SizedBox(width: 8),
    Text(text, style: const TextStyle(fontSize: 15,
      fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
  ]);
}
