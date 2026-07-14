import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  Future<void> _register() async {
    final auth = context.read<AuthProvider>();
    final ok   = await auth.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const HomeView()), (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth.errorMessage ?? 'Registrasi gagal'),
        backgroundColor: AppColors.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Akun Baru')),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(children: [
          const SizedBox(height: 16),
          TextField(controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              prefixIcon: Icon(Icons.person_outline),
          )),
          const SizedBox(height: 16),
          TextField(controller: _emailCtrl,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
          )),
          const SizedBox(height: 16),
          TextField(controller: _passwordCtrl, obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password (min. 6 karakter)',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
          )),
          const SizedBox(height: 32),
          if (isLoading) const CircularProgressIndicator()
          else ElevatedButton(onPressed: _register,
            child: const Text('Daftar Sekarang')),
        ]),
      )),
    );
  }
}
