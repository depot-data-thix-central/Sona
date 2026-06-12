// lib/presentation/chat/location/live_location_sharer.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/location_provider.dart';
import 'location_duration_picker.dart';
import 'location_map_widget.dart';

class LiveLocationSharer extends StatefulWidget {
  final String conversationId;

  const LiveLocationSharer({
    super.key,
    required this.conversationId,
  });

  @override
  State<LiveLocationSharer> createState() => _LiveLocationSharerState();
}

class _LiveLocationSharerState extends State<LiveLocationSharer> {
  Position? _currentPosition;
  bool _isLoading = true;
  bool _hasPermission = false;
  String? _address;
  int _selectedDuration = 30; // minutes

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    // Vérifier les permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _hasPermission = false;
        _isLoading = false;
      });
      return;
    }

    _hasPermission = true;
    
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      
      // Obtenir l'adresse
      _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'obtenir votre position')),
      );
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      final places = await Geolocator.placemarkFromCoordinates(lat, lng);
      if (places.isNotEmpty) {
        final place = places.first;
        setState(() {
          _address = '${place.street}, ${place.locality}, ${place.country}';
        });
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
  }

  Future<void> _shareLocation() async {
    if (_currentPosition == null) return;

    final provider = Provider.of<LocationProvider>(context, listen: false);
    final success = await provider.shareLiveLocation(
      conversationId: widget.conversationId,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      durationMinutes: _selectedDuration,
      address: _address,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Position partagée pour ${_selectedDuration} minutes'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Partager ma position',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Carte
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _currentPosition != null
                  ? LocationMapWidget(
                      latitude: _currentPosition!.latitude,
                      longitude: _currentPosition!.longitude,
                      zoom: 15,
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Adresse
          if (_address != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Color(0xFFD4AF37)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _address!,
                      style: const TextStyle(fontSize: 11),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Durée
          LocationDurationPicker(
            selectedDuration: _selectedDuration,
            onDurationChanged: (duration) => setState(() => _selectedDuration = duration),
          ),
          
          const SizedBox(height: 20),
          
          // Bouton partager
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _shareLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF0B1B3D),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Partager', style: TextStyle(fontSize: 13)),
            ),
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
