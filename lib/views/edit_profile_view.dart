import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
 
class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});
  @override State<EditProfileView> createState() => _EditProfileViewState();
}
 
class _EditProfileViewState extends State<EditProfileView> {
  late final _nameCtrl = TextEditingController(
      text: context.read<AuthProvider>().userName ?? '');
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl     = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew     = true;
  bool _wantsChangePassword = false;
 
  Future<void> _save() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.updateProfile(
      name: _nameCtrl.text.trim(),
      currentPassword: _wantsChangePassword ? _currentPassCtrl.text : null,
      newPassword:     _wantsChangePassword ? _newPassCtrl.text     : null,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profil berhasil diperbarui'),
        backgroundColor: AppColors.success,
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth.errorMessage ?? 'Gagal memperbarui profil'),
        backgroundColor: AppColors.error,
      ));
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Username ─────────────────────
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nama / Username',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 24),
          // ── Toggle ganti password ─────────────
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _wantsChangePassword,
            activeColor: AppColors.primary,
            title: const Text('Ganti Password'),
            subtitle: const Text('Aktifkan jika ingin mengubah password',
                style: TextStyle(fontSize: 12)),
            onChanged: (v) => setState(() => _wantsChangePassword = v),
          ),
          if (_wantsChangePassword) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _currentPassCtrl,
              obscureText: _obscureCurrent,
              decoration: InputDecoration(
                labelText: 'Password Saat Ini',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrent
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPassCtrl,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'Password Baru (min. 6 karakter)',
                prefixIcon: const Icon(Icons.lock_reset_outlined),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan Perubahan'),
            ),
        ]),
      )),
    );
  }
}
