import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/model/story_response.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  const BodyOfDetailScreenWidget({super.key, required this.story});

  final Story story;

  @override
  State<BodyOfDetailScreenWidget> createState() => _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  String? _selectedAddress;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getAddressFromCoordinates();
  }

  Future<void> _getAddressFromCoordinates() async {
    final lat = widget.story.lat;
    final lon = widget.story.lon;

    if (lat == null || lon == null) return;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _selectedAddress = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
        });
      }
    } catch (e) {
      log("Error reverse geocoding: $e");
      setState(() {
        _selectedAddress = "Alamat tidak dapat ditampilkan";
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    final lat = widget.story.lat;
    final lon = widget.story.lon;
    if (lat != null && lon != null) {
      final position = LatLng(lat, lon);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(position, 15),
      );
    }
  }

  Set<Marker> _buildMarkers() {
    final lat = widget.story.lat;
    final lon = widget.story.lon;

    if (lat == null || lon == null) return {};

    return {
      Marker(
        markerId: const MarkerId('story_location'),
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(
          title: 'Lokasi Cerita',
          snippet: _selectedAddress ?? 'Sedang memuat alamat...',
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation = widget.story.lat != null && widget.story.lon != null;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.network(
                    widget.story.photoUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, object, stackTrace) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 60),
                          SizedBox(height: 8),
                          Text("Gambar tidak ditemukan"),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.story.name ?? "Tanpa Judul",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Dibuat pada: ${widget.story.createdAt ?? '-'}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Text(
              widget.story.description ?? "",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            if (hasLocation) ...[
              const Text(
                "Lokasi Cerita",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.story.lat!, widget.story.lon!),
                    zoom: 15,
                  ),
                  markers: _buildMarkers(),
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Koordinat: ${widget.story.lat?.toStringAsFixed(6)}, ${widget.story.lon?.toStringAsFixed(6)}",
                style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
              if (_selectedAddress != null) ...[
                const SizedBox(height: 8),
                Text(
                  "Alamat: $_selectedAddress",
                  style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                ),
              ],
            ] else ...[
              const Text(
                "Lokasi tidak tersedia untuk cerita ini",
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}