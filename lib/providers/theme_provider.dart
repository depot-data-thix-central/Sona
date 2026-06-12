// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentTheme = 'light';
  String _bubbleStyle = 'rounded';
  Color _myBubbleColor = const Color(0xFFD4AF37);
  Color _otherBubbleColor = Colors.white;
  double _borderRadius = 16;
  bool _showAvatar = true;
  bool _showTime = true;
  bool _showReadReceipt = true;
  String _notificationSound = 'default';
  double _notificationVolume = 0.8;
  bool _notificationVibrate = true;
  String _chatWallpaper = 'default';
  double _wallpaperOpacity = 0.3;
  double _fontSize = 14;
  
  ThemeProvider() {
    _loadSettings();
  }
  
  // ============================================================
  // GETTERS
  // ============================================================
  
  String get currentTheme => _currentTheme;
  String get bubbleStyle => _bubbleStyle;
  Color get myBubbleColor => _myBubbleColor;
  Color get otherBubbleColor => _otherBubbleColor;
  double get borderRadius => _borderRadius;
  bool get showAvatar => _showAvatar;
  bool get showTime => _showTime;
  bool get showReadReceipt => _showReadReceipt;
  String get notificationSound => _notificationSound;
  double get notificationVolume => _notificationVolume;
  bool get notificationVibrate => _notificationVibrate;
  String get chatWallpaper => _chatWallpaper;
  double get wallpaperOpacity => _wallpaperOpacity;
  double get fontSize => _fontSize;
  
  // ============================================================
  // MÉTHODES
  // ============================================================
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentTheme = prefs.getString('chat_theme') ?? 'light';
      _bubbleStyle = prefs.getString('bubble_style') ?? 'rounded';
      _myBubbleColor = Color(prefs.getInt('my_bubble_color') ?? 0xFFD4AF37);
      _otherBubbleColor = Color(prefs.getInt('other_bubble_color') ?? 0xFFFFFFFF);
      _borderRadius = prefs.getDouble('bubble_border_radius') ?? 16;
      _showAvatar = prefs.getBool('show_avatar') ?? true;
      _showTime = prefs.getBool('show_time') ?? true;
      _showReadReceipt = prefs.getBool('show_read_receipt') ?? true;
      _notificationSound = prefs.getString('notification_sound') ?? 'default';
      _notificationVolume = prefs.getDouble('notification_volume') ?? 0.8;
      _notificationVibrate = prefs.getBool('notification_vibrate') ?? true;
      _chatWallpaper = prefs.getString('chat_wallpaper') ?? 'default';
      _wallpaperOpacity = prefs.getDouble('wallpaper_opacity') ?? 0.3;
      _fontSize = prefs.getDouble('chat_font_size') ?? 14;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme settings: $e');
    }
  }
  
  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is Color) {
      await prefs.setInt(key, value.value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else {
      await prefs.setString(key, value);
    }
  }
  
  void setTheme(String theme) {
    _currentTheme = theme;
    _saveSetting('chat_theme', theme);
    notifyListeners();
  }
  
  void setBubbleStyle(String style) {
    _bubbleStyle = style;
    _saveSetting('bubble_style', style);
    notifyListeners();
  }
  
  void setMyBubbleColor(Color color) {
    _myBubbleColor = color;
    _saveSetting('my_bubble_color', color);
    notifyListeners();
  }
  
  void setOtherBubbleColor(Color color) {
    _otherBubbleColor = color;
    _saveSetting('other_bubble_color', color);
    notifyListeners();
  }
  
  void setBorderRadius(double radius) {
    _borderRadius = radius;
    _saveSetting('bubble_border_radius', radius);
    notifyListeners();
  }
  
  void setShowAvatar(bool value) {
    _showAvatar = value;
    _saveSetting('show_avatar', value);
    notifyListeners();
  }
  
  void setShowTime(bool value) {
    _showTime = value;
    _saveSetting('show_time', value);
    notifyListeners();
  }
  
  void setShowReadReceipt(bool value) {
    _showReadReceipt = value;
    _saveSetting('show_read_receipt', value);
    notifyListeners();
  }
  
  void setNotificationSound(String sound) {
    _notificationSound = sound;
    _saveSetting('notification_sound', sound);
    notifyListeners();
  }
  
  void setNotificationVolume(double volume) {
    _notificationVolume = volume;
    _saveSetting('notification_volume', volume);
    notifyListeners();
  }
  
  void setNotificationVibrate(bool value) {
    _notificationVibrate = value;
    _saveSetting('notification_vibrate', value);
    notifyListeners();
  }
  
  void setChatWallpaper(String wallpaper) {
    _chatWallpaper = wallpaper;
    _saveSetting('chat_wallpaper', wallpaper);
    notifyListeners();
  }
  
  void setWallpaperOpacity(double opacity) {
    _wallpaperOpacity = opacity;
    _saveSetting('wallpaper_opacity', opacity);
    notifyListeners();
  }
  
  void setFontSize(double size) {
    _fontSize = size;
    _saveSetting('chat_font_size', size);
    notifyListeners();
  }
}
