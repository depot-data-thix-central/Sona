// lib/presentation/chat/location/live_location_viewer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/location_provider.dart';
import '../../../models/location_models.dart';
import 'location_map_widget.dart';

class LiveLocationViewer extends StatefulWidget {
  final String locationId;

  const LiveLocationViewer({
    super.key,
    required this.locationId,
  });

  @override
  State<LiveLocationViewer> createState() => _LiveLocationViewerState();
}

class _LiveLocationViewerState extends State<LiveLocationViewer> {
  late LiveLocation _location;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    final location = await provider.getLiveLocation(widget.locationId);
    if (location != null && mounted) {
      setState(() {
        _location = location;
        _isLoading = false;
      });
    }
  }

  void _openMaps() {
    // Ouvrir Google Maps ou Apple Maps
    final url = 'https://www.google.com/maps/search/?api=1&query=${_location.latitude},${_location.longitude}';
    // Implémenter l'ouverture
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final isExpired = _location.expiresAt.isBefore(DateTime.now());
    final timeLeft = _location.expiresAt.difference(DateTime.now());

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on, size: 16, color: Color(0xFFD4AF37)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Position en direct',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _location.userName,
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (!isExpired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'En direct • ${_formatTimeLeft(timeLeft)}',
                        style: const TextStyle(fontSize: 8, color: Colors.green),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Expiré',
                    style: TextStyle(fontSize: 8, color: Colors.grey),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Carte
          GestureDetector(
            onTap: _openMaps,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LocationMapWidget(
                latitude: _location.latitude,
                longitude: _location.longitude,
                height: 150,
                showMarker: true,
                markerTitle: _location.userName,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Adresse
          if (_location.address != null)
            Text(
              _location.address!,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
              maxLines: 2,
            ),
          
          // Bouton directions
          if (!isExpired)
            const SizedBox(height: 8),
          if (!isExpired)
            GestureDetector(
              onTap: _openMaps,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Obtenir l\'itinéraire',
                    style: TextStyle(fontSize: 10, color: Color(0xFFD4AF37)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimeLeft(Duration duration) {
    if (duration.inMinutes < 1) return '${duration.inSeconds}s';
    if (duration.inHours < 1) return '${duration.inMinutes}min';
    return '${duration.inHours}h';
  }
}
