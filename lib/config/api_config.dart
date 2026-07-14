class ApiConfig {
  // Android Emulator: 10.0.2.2 | Device Fisik: IP PC di LAN
  static const String baseUrl = 'https://aristocratically-introspectable-nidia.ngrok-free.dev/api';

  static const String login    = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String logout   = '$baseUrl/logout';
  static const String me       = '$baseUrl/me';
  static const String predict  = '$baseUrl/predict';
  static const String history  = '$baseUrl/history';
  static const String profile  = '$baseUrl/profile';   
}
