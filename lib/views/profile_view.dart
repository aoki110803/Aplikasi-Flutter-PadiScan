import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'login_view.dart';
import 'edit_profile_view.dart';
import 'about_view.dart';
import 'guide_view.dart';
import 'rating_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Avatar
          Container(
            width: 96, height: 96,
            decoration: BoxDecoration(
              color: AppColors.primaryPale, shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Icon(Icons.person, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(auth.userName ?? '-',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(auth.userEmail ?? '-',
            style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const EditProfileView())),
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            label: const Text('Edit Profil', style: TextStyle(color: AppColors.primary)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),

          const SizedBox(height: 32),
          PadiCard(
            child: Column(
              children: [

                // ── Tentang PadiScan ─────────────────────
                ListTile(
                  leading: const Icon(Icons.grass, color: AppColors.primary),
                  title: const Text('Tentang PadiScan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AboutView(),
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),

                // ── Panduan Penggunaan ───────────────────
                ListTile(
                  leading: const Icon(Icons.help_outline, color: AppColors.primary),
                  title: const Text('Panduan Penggunaan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GuideView(),
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),

                // ── Beri Rating ──────────────────────────
                ListTile(
                  leading: const Icon(Icons.star_outline, color: AppColors.primary),
                  title: const Text('Beri Rating'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RatingView(),
                    ),
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(height: 16),
          // Tombol Logout
          OutlinedButton.icon(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => const LoginView()),
                (_) => false);
            },
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: const Text('Keluar', style: TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label) => ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(label),
    trailing: const Icon(Icons.chevron_right,
      color: AppColors.textSecondary),
    onTap: () {},
  );
}
