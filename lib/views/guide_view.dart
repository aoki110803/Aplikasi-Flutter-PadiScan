import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
 
// Model satu topik panduan
class _GuideTopic {
  final String title;
  final IconData icon;
  final List<String> steps;
  const _GuideTopic({required this.title, required this.icon, required this.steps});
}
 
class GuideView extends StatelessWidget {
  const GuideView({super.key});
 
  static const _topics = [
    _GuideTopic(
      title : 'Daftar Akun',
      icon  : Icons.person_add_outlined,
      steps : [
        'Buka aplikasi, lalu ketuk tautan Belum punya akun? Daftar Sekarang.',
        'Isi Nama Lengkap, Email, dan Password (minimal 6 karakter).',
        'Ketuk tombol Daftar Sekarang.',
        'Jika berhasil, aplikasi langsung masuk ke halaman utama.',
      ],
    ),
    _GuideTopic(
      title : 'Login',
      icon  : Icons.login_outlined,
      steps : [
        'Buka aplikasi, isi Email dan Password.',
        'Ketuk tombol Masuk.',
        'Jika muncul notifikasi merah, periksa kembali email/password.',
        'Setelah berhasil, aplikasi membuka halaman Scan.',
      ],
    ),
    _GuideTopic(
      title : 'Scan Penyakit Padi',
      icon  : Icons.document_scanner_outlined,
      steps : [
        'Buka tab Scan di bagian bawah layar.',
        'Ketuk area gambar atau tombol Kamera / Galeri.',
        'Pilih atau ambil foto daun padi yang menunjukkan gejala.',
        'Pastikan daun mengisi sebagian besar frame dan pencahayaan cukup.',
        'Ketuk tombol Analisis Penyakit.',
        'Hasil prediksi dan rekomendasi penanganan akan tampil otomatis.',
      ],
    ),
    _GuideTopic(
      title : 'Riwayat Prediksi',
      icon  : Icons.history_outlined,
      steps : [
        'Buka tab Riwayat di bagian bawah layar.',
        'Ketuk kotak pencarian untuk mencari berdasarkan nama penyakit.',
        'Gunakan chip filter (Semua, Sehat, Ringan, Sedang, Parah) untuk menyaring.',
        'Ketuk ikon refresh di pojok kanan atas untuk memuat ulang data.',
      ],
    ),
    _GuideTopic(
      title : 'Kelola Profil',
      icon  : Icons.manage_accounts_outlined,
      steps : [
        'Buka tab Profil di bagian bawah layar.',
        'Ketuk tombol Edit Profil.',
        'Ubah nama pada kolom Nama / Username jika perlu.',
        'Aktifkan toggle Ganti Password untuk mengubah password.',
        'Isi Password Saat Ini dan Password Baru (min. 6 karakter).',
        'Ketuk Simpan Perubahan.',
        'Untuk keluar akun, ketuk tombol Keluar dan konfirmasi.',
      ],
    ),
  ];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panduan Penggunaan')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _topics.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _TopicCard(topic: _topics[i]),
        ),
      ),
    );
  }
}
 
// ── Card satu topik panduan ──────────────────────────────────
class _TopicCard extends StatefulWidget {
  final _GuideTopic topic;
  const _TopicCard({required this.topic});
  @override State<_TopicCard> createState() => _TopicCardState();
}
 
class _TopicCardState extends State<_TopicCard> {
  bool _expanded = false;
 
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _expanded ? AppColors.primary : AppColors.borderLight,
          width: _expanded ? 1.5 : 1,
        ),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6, offset: const Offset(0, 2),
        )],
      ),
      child: Column(
        children: [
          // ── Header card ──────────────────────────────────
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.topic.icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(widget.topic.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                ),
              ]),
            ),
          ),
          // ── Isi langkah-langkah (tampil saat di-tap) ─────
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  ...widget.topic.steps.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nomor urut langkah
                        Container(
                          width: 24, height: 24,
                          margin: const EdgeInsets.only(right: 10, top: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text('${e.key + 1}',
                              style: const TextStyle(color: Colors.white,
                                  fontSize: 11, fontWeight: FontWeight.bold))),
                        ),
                        Expanded(child: Text(e.value,
                            style: const TextStyle(fontSize: 14, height: 1.5,
                                color: AppColors.textPrimary))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
