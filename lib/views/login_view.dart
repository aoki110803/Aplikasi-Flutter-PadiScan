import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final ok   = await auth.login(
      _emailCtrl.text.trim(), _passwordCtrl.text,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const HomeView()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth.errorMessage ?? 'Login gagal'),
        backgroundColor: AppColors.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Logo & Title
            Center(child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryPale,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.grass,
                size: 56, color: AppColors.primary),
            ).animate().scale(duration: 500.ms)),
            const SizedBox(height: 24),
            Center(child: Text('Selamat Datang',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                color: AppColors.textPrimary))
              .animate().fadeIn(delay: 200.ms)),
            Center(child: Text('Masuk untuk mendeteksi penyakit padi',
              style: TextStyle(color: AppColors.textSecondary))
              .animate().fadeIn(delay: 300.ms)),
            const SizedBox(height: 40),
            // Email field
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
            const SizedBox(height: 16),
            // Password field
            TextField(
              controller: _passwordCtrl,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
            const SizedBox(height: 32),
            // Login button
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _login,
                child: const Text('Masuk'),
              ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 16),
            Center(child: TextButton(
              onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RegisterView())),
              child: const Text('Belum punya akun? Daftar Sekarang'),
            )),
          ],
        ),
      )),
    );
  }
}
