import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
import 'result_view.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});
  @override State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final xFile = await _picker.pickImage(
      source: source, imageQuality: 85, maxWidth: 800,
    );
    if (xFile == null) return;
    context.read<ScanProvider>().setImage(File(xFile.path));
  }

  Future<void> _predict() async {
    final token = context.read<AuthProvider>().token!;
    final prov  = context.read<ScanProvider>();
    final result = await prov.predict(token);
    if (!mounted) return;
    if (result != null) {
      Navigator.push(context,
        MaterialPageRoute(builder: (_) => const ResultView()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(prov.errorMessage ?? 'Prediksi gagal'),
        backgroundColor: AppColors.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(builder: (context, prov, _) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan Penyakit Padi')),
        body: SingleChildScrollView(padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Preview gambar
            GestureDetector(
              onTap: () => _showSourceDialog(),
              child: Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
                ),
                child: prov.selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(prov.selectedImage!, fit: BoxFit.cover),
                    )
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.add_photo_alternate_outlined,
                        size: 64, color: AppColors.primary.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      const Text('Ketuk untuk pilih gambar daun padi',
                        style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      const Text('Gunakan kamera atau galeri',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ]),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol pilih gambar
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Kamera'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Galeri'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )),
            ]),
            const SizedBox(height: 24),
            // Tips scan
            PadiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tips untuk hasil terbaik:',
                  style: TextStyle(fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
                const SizedBox(height: 8),
                _tipRow(Icons.wb_sunny_outlined, 'Foto di cahaya yang cukup'),
                _tipRow(Icons.center_focus_strong, 'Fokus pada bagian daun yang sakit'),
                _tipRow(Icons.crop_free, 'Pastikan daun mengisi sebagian besar frame'),
              ],
            )),
            const SizedBox(height: 32),
            // Tombol prediksi
            if (prov.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: prov.selectedImage != null ? _predict : null,
                icon: const Icon(Icons.biotech_outlined),
                label: const Text('Analisis Penyakit'),
              ),
          ]),
        ),
      );
    });
  }

  Widget _tipRow(IconData icon, String text) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 4),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        icon,
        size: 16,
        color: AppColors.primaryLight,
      ),
      const SizedBox(width: 8),

      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    ],
  ),
);

  void _showSourceDialog() {
    showModalBottomSheet(context: context, builder: (_) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Pilih Sumber Gambar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.camera_alt, color: AppColors.primary),
          title: const Text('Kamera'),
          onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library, color: AppColors.primary),
          title: const Text('Galeri'),
          onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
        ),
      ]),
    ));
  }
}
