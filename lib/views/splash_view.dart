import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_view.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() { super.initState(); _init(); }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    await auth.checkSession();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => auth.isAuth ? const HomeView() : const LoginView(),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.primary,
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.grass, size: 80, color: Colors.white)
          .animate().scale(duration: 600.ms).then().shimmer(duration: 1200.ms),
        const SizedBox(height: 24),
        const Text('PadiScan',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold,
            color: Colors.white, letterSpacing: 2))
          .animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.3),
        const SizedBox(height: 8),
        const Text('Deteksi Penyakit Padi Cerdas',
          style: TextStyle(fontSize: 14, color: Colors.white70))
          .animate().fadeIn(delay: 600.ms, duration: 600.ms),
      ],
    )),
  );
}
