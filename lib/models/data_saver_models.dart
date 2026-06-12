// lib/models/data_saver_models.dart
class DataSaverSettings {
  final bool isLowDataMode;
  final bool blockImages;
  final bool blockVideos;
  final bool blockStickers;
  final bool reduceQuality;
  final String downloadOnMobile; // 'always', 'wifi_only', 'never'
  final String videoQuality; // 'auto', 'high', 'medium', 'low'
  final String imageQuality; // 'original', 'high', 'medium', 'low'
  final bool autoPlayVideos;
  final bool autoPlayGifs;
  final String photosOnMobile; // 'always', 'wifi', 'never'
  final String videosOnMobile;
  final String documentsOnMobile;
  final int maxFileSize; // MB

  DataSaverSettings({
    this.isLowDataMode = false,
    this.blockImages = false,
    this.blockVideos = false,
    this.blockStickers = false,
    this.reduceQuality = true,
    this.downloadOnMobile = 'wifi_only',
    this.videoQuality = 'auto',
    this.imageQuality = 'high',
    this.autoPlayVideos = true,
    this.autoPlayGifs = true,
    this.photosOnMobile = 'wifi',
    this.videosOnMobile = 'never',
    this.documentsOnMobile = 'wifi',
    this.maxFileSize = 50,
  });
}
