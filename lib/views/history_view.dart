import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/auth_provider.dart';
import '../providers/scan_provider.dart';
import '../theme/app_theme.dart';
 
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});
  @override State<HistoryView> createState() => _HistoryViewState();
}
 
class _HistoryViewState extends State<HistoryView> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  static const _filters = ['Semua', 'Blas', 'Blight', 'Tungro'];
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHistory());
  }
 
  void _loadHistory({String? search}) {
    final token = context.read<AuthProvider>().token!;
    context.read<ScanProvider>().loadHistory(token, search: search);
  }
 
  // Debounce supaya tidak request ke server setiap kali huruf diketik
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _loadHistory(search: value.trim());
    });
  }
 
  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }
 
  Color _diseaseColor(String name) {
    const severe   = ['Blas', 'Hawar Daun', 'Tungro'];
    const moderate = ['Bercak Coklat', 'Kresek'];
    if (severe.any((d) => name.contains(d)))   return AppColors.error;
    if (moderate.any((d) => name.contains(d))) return AppColors.warning;
    return AppColors.success;
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Prediksi'),
        actions: [IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _loadHistory(search: _searchCtrl.text.trim()),
        )],
      ),
      body: Column(children: [
        // ── Kotak pencarian ─────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            controller: _searchCtrl,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari nama penyakit...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchCtrl.clear();
                        _loadHistory();
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
        ),
        // ── Chip filter tingkat keparahan ──────────────
        SizedBox(
          height: 44,
          child: Consumer<ScanProvider>(builder: (context, prov, _) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final label = _filters[i];
                final selected = prov.severityFilter == label;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  selectedColor: AppColors.primaryPale,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) => prov.setSeverityFilter(label),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 4),
        // ── Daftar riwayat ─────────────────────
        Expanded(child: Consumer<ScanProvider>(builder: (context, prov, _) {
          if (prov.isLoading) return _buildShimmer();
          final list = prov.filteredHistory;
          if (list.isEmpty) return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64,
                  color: AppColors.primary.withOpacity(0.3)),
              const SizedBox(height: 16),
              const Text('Tidak ada riwayat yang cocok',
                  style: TextStyle(color: AppColors.textSecondary)),
            ],
          ));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final item  = list[i];
              final color = _diseaseColor(item.namaPenyakit);
              return PadiCard(
                padding: const EdgeInsets.all(0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.4)),
                    ),
                    child: Icon(Icons.grass, color: color),
                  ),
                  title: Text(item.namaPenyakit,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${(item.confidence*100).toStringAsFixed(1)}% akurasi  •  '
                      '${item.createdAt.length >= 10 ? item.createdAt.substring(0,10) : item.createdAt}',
                      style: const TextStyle(fontSize: 12)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.5)),
                    ),
                    child: Text(item.namaPenyakit.split(' ').first,
                        style: TextStyle(color: color, fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          );
        })),
      ]),
    );
  }
 
  Widget _buildShimmer() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 72, decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}
