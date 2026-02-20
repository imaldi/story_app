import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:story_app/model/story_response.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  const BodyOfDetailScreenWidget({super.key, required this.story});

  final Story story;

  @override
  State<BodyOfDetailScreenWidget> createState() => _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  String? _selectedAddress;

  @override
  void initState() {
    print("Image Url: ${widget.story.photoUrl}");
    _getCurrentLocation();
    super.initState();
  }


  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: "Lokasi tidak aktif. Aktifkan dulu ya!");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(msg: "Izin lokasi ditolak");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "Izin lokasi ditolak permanen, buka pengaturan");
        await Geolocator.openAppSettings();
        return;
      }

      final lat = widget.story.lat;
      final lon = widget.story.lon;
      if (lat != null && lon != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

        String? address;
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
        }

        setState(() {
          _selectedAddress = address ?? "Alamat tidak ditemukan";
        });
      }
    } catch (e) {
      log("Error geolocation: $e");
      Fluttertoast.showToast(msg: "Gagal mendapatkan lokasi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    errorBuilder: (context, object, stacTrace) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Icon(Icons.broken_image), Text("The image is not found")],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox.square(dimension: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.story.name ?? "", style: Theme.of(context).textTheme.headlineLarge),
                      Text(
                        ("Created at: ${widget.story.createdAt ?? '-'}").toString(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox.square(dimension: 16),
            if(widget.story.lat != null && widget.story.lon != null)
            Text(
              "Lokasi terpilih: ${widget.story.lat?.toStringAsFixed(6)}, "
              "${widget.story.lon?.toStringAsFixed(6)}",
              style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox.square(dimension: 16),
            if(widget.story.lat != null && widget.story.lon != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Alamat: $_selectedAddress",
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox.square(dimension: 16),
            Text(widget.story.description ?? "", style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
