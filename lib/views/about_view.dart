import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
 
class AboutView extends StatelessWidget {
  const AboutView({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang PadiScan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Logo & nama app ───────────────────────────────────
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const Icon(Icons.grass, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const Text(
                'PadiScan',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Versi 1.0.0',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              // ── Card deskripsi ───────────────────────────────────
              _InfoCard(
                title: 'Tentang Aplikasi',
                content:
                    'PadiScan adalah aplikasi deteksi dini penyakit tanaman padi '
                    'berbasis kecerdasan buatan. Dengan memfoto daun padi menggunakan '
                    'kamera HP, sistem akan menganalisis gambar dan memberikan prediksi '
                    'penyakit beserta rekomendasi penanganannya.',
              ),
              const SizedBox(height: 16),
              // ── Card developer ───────────────────────────────────
              _InfoCard(
                title: 'Pengembang',
                content: 'Tim PadiScan\nProgram Studi Teknik Informatika\nUniversitas [Nama Universitas]',
              ),
              const SizedBox(height: 16),
              // ── Card kontak ──────────────────────────────────────
              _InfoCard(
                title: 'Kontak',
                content: 'Email : padiscan@email.com\nInstagram : @padiscan',
              ),
              const SizedBox(height: 32),
              const Text(
                '\u00a9 2024 PadiScan. All rights reserved.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
// ── Widget card info ─────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  const _InfoCard({required this.title, required this.content});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8, offset: const Offset(0, 2),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 14, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(content,
              style: const TextStyle(fontSize: 14, height: 1.6,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
