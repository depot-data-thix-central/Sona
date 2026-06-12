// lib/services/data_saver_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class DataSaverService {
  static const String _lowDataModeKey = 'low_data_mode';
  static const String _blockImagesKey = 'block_images';
  static const String _blockVideosKey = 'block_videos';
  static const String _blockStickersKey = 'block_stickers';
  static const String _reduceQualityKey = 'reduce_quality';
  static const String _downloadOnMobileKey = 'download_on_mobile';
  static const String _videoQualityKey = 'video_quality';
  static const String _imageQualityKey = 'image_quality';
  static const String _autoPlayVideosKey = 'auto_play_videos';
  static const String _autoPlayGifsKey = 'auto_play_gifs';
  static const String _photosOnMobileKey = 'auto_download_photos_mobile';
  static const String _videosOnMobileKey = 'auto_download_videos_mobile';
  static const String _documentsOnMobileKey = 'auto_download_documents_mobile';
  static const String _maxFileSizeKey = 'max_auto_download_size';

  Future<bool> isLowDataMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_lowDataModeKey) ?? false;
  }

  Future<void> setLowDataMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_lowDataModeKey, enabled);
    if (enabled) {
      await setBlockImages(true);
      await setBlockVideos(true);
      await setReduceQuality(true);
    }
  }

  Future<bool> shouldBlockImages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_blockImagesKey) ?? false;
  }

  Future<void> setBlockImages(bool block) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_blockImagesKey, block);
  }

  Future<bool> shouldBlockVideos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_blockVideosKey) ?? false;
  }

  Future<void> setBlockVideos(bool block) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_blockVideosKey, block);
  }

  Future<bool> shouldBlockStickers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_blockStickersKey) ?? false;
  }

  Future<void> setBlockStickers(bool block) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_blockStickersKey, block);
  }

  Future<bool> shouldReduceQuality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reduceQualityKey) ?? true;
  }

  Future<void> setReduceQuality(bool reduce) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reduceQualityKey, reduce);
  }

  Future<String> getDownloadOnMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_downloadOnMobileKey) ?? 'wifi_only';
  }

  Future<void> setDownloadOnMobile(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_downloadOnMobileKey, value);
  }

  Future<String> getVideoQuality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_videoQualityKey) ?? 'auto';
  }

  Future<void> setVideoQuality(String quality) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_videoQualityKey, quality);
  }

  Future<String> getImageQuality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imageQualityKey) ?? 'high';
  }

  Future<void> setImageQuality(String quality) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageQualityKey, quality);
  }

  Future<bool> shouldAutoPlayVideos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoPlayVideosKey) ?? true;
  }

  Future<void> setAutoPlayVideos(bool autoPlay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoPlayVideosKey, autoPlay);
  }

  Future<bool> shouldAutoPlayGifs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoPlayGifsKey) ?? true;
  }

  Future<void> setAutoPlayGifs(bool autoPlay) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoPlayGifsKey, autoPlay);
  }

  Future<String> getPhotosOnMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photosOnMobileKey) ?? 'wifi';
  }

  Future<void> setPhotosOnMobile(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_photosOnMobileKey, value);
  }

  Future<String> getVideosOnMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_videosOnMobileKey) ?? 'never';
  }

  Future<void> setVideosOnMobile(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_videosOnMobileKey, value);
  }

  Future<String> getDocumentsOnMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_documentsOnMobileKey) ?? 'wifi';
  }

  Future<void> setDocumentsOnMobile(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_documentsOnMobileKey, value);
  }

  Future<int> getMaxFileSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_maxFileSizeKey) ?? 50;
  }

  Future<void> setMaxFileSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxFileSizeKey, size);
  }
}
