import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/utils/file_compressor.dart';

class AddNewStoryScreen extends StatefulWidget {
  const AddNewStoryScreen({
    required this.onPop,
    required this.onSuccessAdd,
    required this.isChoosingImageSourceNotifier,
    required this.callbackImageChosenNotifier,
    super.key,
  });

  final Function() onPop;
  final Function() onSuccessAdd;
  final ValueNotifier<bool?> isChoosingImageSourceNotifier;
  final ValueNotifier<Future<void> Function(ImageSource source, {required BuildContext context})?>
  callbackImageChosenNotifier;

  @override
  State<AddNewStoryScreen> createState() => _AddNewStoryScreenState();
}

class _AddNewStoryScreenState extends State<AddNewStoryScreen> {
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();


  List<File>? _mediaFileList;
  // dynamic _pickImageError;

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-6.2088, 106.8456), // Jakarta
    zoom: 14.0,
  );

  LatLng? _selectedLocation;
  String? _selectedAddress;
  bool _isGettingLocation = false;

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          draggable: true,
          infoWindow: const InfoWindow(title: 'Lokasi Cerita'),
          onDragEnd: (newPosition) {
            setState(() {
              _selectedLocation = newPosition;
            });
          },
        ),
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String? address;
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
      }

      setState(() {
        _selectedLocation = latLng;
        _selectedAddress = address ?? "Alamat tidak ditemukan";
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('current'),
            position: latLng,
            draggable: true,
            infoWindow: InfoWindow(title: "Lokasi Saat Ini", snippet: address),
            onDragEnd: (newPos) {
              setState(() {
                _selectedLocation = newPos;
                _selectedAddress = null;
              });
            },
          ),
        );
      });

      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    } catch (e) {
      log("Error geolocation: $e");
      Fluttertoast.showToast(msg: "Gagal mendapatkan lokasi: $e");
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source, {required BuildContext context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      var compressed = await imageCompressor(file, maxSize: 1);

      setState(() {
        _mediaFileList = [compressed];
      });
    } catch (e) {
      // setState(() => _pickImageError = e);
      // log("Pick image error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result){
        if(didPop){
          widget.onPop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Buat Cerita Baru')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Deskripsi cerita",
                        border: OutlineInputBorder(),
                      ),
                      minLines: 3,
                      maxLines: 5,
                      validator: (v) => (v?.trim().isEmpty ?? true) ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
      
                    if (_mediaFileList?.isNotEmpty ?? false)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _mediaFileList!.first,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Text('Belum ada gambar')),
                      ),
      
                    const SizedBox(height: 12),
      
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Pilih Gambar"),
                      onPressed: () {
                        widget.isChoosingImageSourceNotifier.value = true;
                        widget.callbackImageChosenNotifier.value = _onImageButtonPressed;
                      },
                    ),
      
                    const SizedBox(height: 24),
      
                    const Text("Pilih Lokasi Cerita", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
      
                    SizedBox(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: _initialPosition,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: _markers,
                        onMapCreated: _onMapCreated,
                        onTap: _onMapTapped,
                      ),
                    ),
      
                    const SizedBox(height: 12),
      
                    if (_selectedLocation != null)
                      Text(
                        "Lokasi terpilih: ${_selectedLocation!.latitude.toStringAsFixed(6)}, "
                            "${_selectedLocation!.longitude.toStringAsFixed(6)}",
                        style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                        textAlign: TextAlign.center,
                      )
                    else
                      const Text(
                        "Tap di peta untuk memilih lokasi",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: _isGettingLocation
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.my_location),
                      label: const Text("Gunakan Lokasi Saya"),
                      onPressed: _isGettingLocation ? null : _getCurrentLocation,
                    ),
                    SizedBox(height: 8),
      
                    if (_selectedAddress != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Alamat: $_selectedAddress",
                          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 24),
      
                    context.watch<AddStoryProvider>().isLoadingAddStory
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        if (_mediaFileList == null || _mediaFileList!.isEmpty) {
                          Fluttertoast.showToast(msg: "Pilih gambar terlebih dahulu");
                          return;
                        }
                        if (_selectedLocation == null) {
                          Fluttertoast.showToast(msg: "Pilih lokasi di peta");
                          return;
                        }
      
                        final story = Story(
                          description: descriptionController.text.trim(),
                          photoUrl: _mediaFileList!.first.path,
                          lat: _selectedLocation!.latitude,
                          lon: _selectedLocation!.longitude,
                        );
      
                        final provider = context.read<AddStoryProvider>();
                        final success = await provider.addStory(story);
      
                        if (success) {
                          widget.onSuccessAdd();
                        } else {
                          Fluttertoast.showToast(
                            msg: "Gagal mengunggah cerita",
                            backgroundColor: Colors.redAccent,
                          );
                        }
                      },
                      child: const Text("Unggah Cerita", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}