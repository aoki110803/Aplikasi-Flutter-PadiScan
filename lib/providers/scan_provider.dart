import 'dart:io';
import 'package:flutter/material.dart';
import '../models/prediction_model.dart';
import '../services/scan_service.dart';

class ScanProvider with ChangeNotifier {
  final _svc = ScanService();

  // ==========================
  // STATE
  // ==========================
  List<PredictionResult> _history = [];
  PredictionResult? _lastResult;
  File? _selectedImage;

  bool _isLoading = false;
  String? _errorMessage;

  // Search & Filter
  String _searchKeyword = '';
  String _severityFilter = 'Semua';

  // ==========================
  // GETTER
  // ==========================
  List<PredictionResult> get history => _history;
  PredictionResult? get lastResult => _lastResult;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get searchKeyword => _searchKeyword;
  String get severityFilter => _severityFilter;

  /// Riwayat yang sudah difilter berdasarkan tingkat keparahan
  List<PredictionResult> get filteredHistory {
    if (_severityFilter == 'Semua') return _history;

    return _history.where((item) {
      return _severityLabelOf(item.namaPenyakit) == _severityFilter;
    }).toList();
  }

  // ==========================
  // HELPER
  // ==========================
  
  String _severityLabelOf(String disease) {
  if (disease.contains('Blas')) {
    return 'Blas';
  }

  if (disease.contains('Blight') ||
      disease.contains('Hawar Daun')) {
    return 'Blight';
  }

  if (disease.contains('Tungro')) {
    return 'Tungro';
  }

  return '';
}

  void setSeverityFilter(String value) {
    _severityFilter = value;
    notifyListeners();
  }

  // ==========================
  // IMAGE
  // ==========================
  void setImage(File? file) {
    _selectedImage = file;
    _lastResult = null;
    notifyListeners();
  }

  // ==========================
  // PREDICT
  // ==========================
  Future<PredictionResult?> predict(String token) async {
    if (_selectedImage == null) return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastResult = await _svc.predict(
        token: token,
        imageFile: _selectedImage!,
      );

      _isLoading = false;
      notifyListeners();

      return _lastResult;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();

    return null;
  }

  // ==========================
  // HISTORY
  // ==========================
  Future<void> loadHistory(
    String token, {
    String? search,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _searchKeyword = search ?? '';

    notifyListeners();

    try {
      _history = await _svc.getHistory(
        token,
        search: search,
      );
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}