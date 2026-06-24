import 'package:flutter/foundation.dart';

class RoleProvider extends ChangeNotifier {
  String _role = 'user';
  String get role => _role;
  void setRole(String role) {
    _role = role;
    notifyListeners();
  }
}
