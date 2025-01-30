import 'package:flutter/foundation.dart';
import '../core/storage.dart';

class ThemeProvider with ChangeNotifier {  // extends yerine with kullanıyoruz
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await AppStorage.isDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await AppStorage.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}