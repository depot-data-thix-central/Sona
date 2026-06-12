// lib/models/theme_models.dart
class ThemeSettings {
  final String theme; // 'light', 'dark', 'thix'
  final String bubbleStyle; // 'rounded', 'square', 'message'
  final int myBubbleColor;
  final int otherBubbleColor;
  final double borderRadius;
  final bool showAvatar;
  final bool showTime;
  final bool showReadReceipt;
  final String notificationSound;
  final double notificationVolume;
  final bool notificationVibrate;
  final String chatWallpaper;
  final double wallpaperOpacity;
  final double fontSize;

  ThemeSettings({
    this.theme = 'light',
    this.bubbleStyle = 'rounded',
    this.myBubbleColor = 0xFFD4AF37,
    this.otherBubbleColor = 0xFFFFFFFF,
    this.borderRadius = 16,
    this.showAvatar = true,
    this.showTime = true,
    this.showReadReceipt = true,
    this.notificationSound = 'default',
    this.notificationVolume = 0.8,
    this.notificationVibrate = true,
    this.chatWallpaper = 'default',
    this.wallpaperOpacity = 0.3,
    this.fontSize = 14,
  });
}
