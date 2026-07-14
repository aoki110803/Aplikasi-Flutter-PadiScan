import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
 
class RatingView extends StatefulWidget {
  const RatingView({super.key});
  @override State<RatingView> createState() => _RatingViewState();
}
 
class _RatingViewState extends State<RatingView> {
  int    _rating  = 0;            // 0 = belum dipilih
  final  _commentCtrl = TextEditingController();
  bool   _submitted = false;
 
  // Ganti dengan package name aplikasi di Play Store
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.penyakit_padi_app';
 
  Future<void> _openPlayStore() async {
    final uri = Uri.parse(_playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Tidak dapat membuka Play Store'),
        backgroundColor: AppColors.error,
      ));
    }
  }
 
  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih bintang terlebih dahulu'),
        backgroundColor: AppColors.warning,
      ));
      return;
    }
    setState(() => _submitted = true);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beri Rating')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _submitted ? _buildThanks() : _buildForm(),
        ),
      ),
    );
  }
 
  // ── Tampilan setelah submit ─────────────────────────────
  Widget _buildThanks() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 48),
      const Icon(Icons.check_circle_outline, size: 80, color: AppColors.primary),
      const SizedBox(height: 16),
      const Text('Terima kasih atas penilaianmu!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
      const SizedBox(height: 8),
      const Text('Masukan kamu sangat berarti untuk pengembangan PadiScan.',
          style: TextStyle(color: AppColors.textSecondary),
          textAlign: TextAlign.center),
      const SizedBox(height: 32),
      OutlinedButton.icon(
        onPressed: _openPlayStore,
        icon: const Icon(Icons.star_outline, color: AppColors.primary),
        label: const Text('Beri Rating di Play Store',
            style: TextStyle(color: AppColors.primary)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    ],
  );
 
  // ── Form rating ─────────────────────────────────────────
  Widget _buildForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text('Bagaimana pengalamanmu?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
      const SizedBox(height: 8),
      const Text('Ketuk bintang untuk memberi nilai',
          style: TextStyle(color: AppColors.textSecondary),
          textAlign: TextAlign.center),
      const SizedBox(height: 28),
      // ── Bintang rating ─────────────────────────────────
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) => GestureDetector(
          onTap: () => setState(() => _rating = i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 48,
              color: i < _rating ? Colors.amber : AppColors.borderLight,
            ),
          ),
        )),
      ),
      if (_rating > 0) ...[
        const SizedBox(height: 8),
        Text(_ratingLabel(_rating),
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ],
      const SizedBox(height: 28),
      // ── Kolom komentar ──────────────────────────────────
      TextField(
        controller: _commentCtrl,
        maxLines: 4,
        maxLength: 300,
        decoration: const InputDecoration(
          hintText: 'Tulis komentar (opsional)...',
          alignLabelWithHint: true,
        ),
      ),
      const SizedBox(height: 24),
      ElevatedButton.icon(
        onPressed: _submit,
        icon: const Icon(Icons.send_outlined),
        label: const Text('Kirim Penilaian'),
      ),
      const SizedBox(height: 16),
      OutlinedButton.icon(
        onPressed: _openPlayStore,
        icon: const Icon(Icons.open_in_new, color: AppColors.primary, size: 18),
        label: const Text('Beri Rating di Play Store',
            style: TextStyle(color: AppColors.primary)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    ],
  );
 
  String _ratingLabel(int r) {
    const labels = ['', 'Kurang', 'Cukup', 'Baik', 'Sangat Baik', 'Luar Biasa!'];
    return labels[r];
  }
}
