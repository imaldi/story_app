import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:story_app/extensions/color_extensions.dart';
// import 'package:story_app/model/shape_border_type.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/provider/add_story_provider.dart';
// import 'package:story_app/screen/choose_image_source_dialog.dart';
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
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  String? _retrieveDataError;

  List<File>? _mediaFileList;

  dynamic _pickImageError;

  void _setImageFileListFromFile(File? value) {
    _mediaFileList = value == null ? null : <File>[value];
  }

  Future<void> _onImageButtonPressed(ImageSource source, {required BuildContext context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
      );

      // File file = File(pickedFile?.path ?? '');

      final length = await pickedFile?.length() ?? -1;

      if (pickedFile != null && (length != -1)) {
        final file = File(pickedFile.path);

        var compressedImage = await imageCompressor(file, maxSize: 1);
        log("Masuk Pak Eko");
        print("Masuk Pak Eko");
        setState(() {
          _setImageFileListFromFile(compressedImage);
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
        log("Ini error: $_pickImageError");
        print("Ini error: $_pickImageError");
      });
    }
  }

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Story')),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(hintText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your story.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  _previewImages(),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      widget.isChoosingImageSourceNotifier.value = true;
                      widget.callbackImageChosenNotifier.value = _onImageButtonPressed;
                    },
                    child: const Text("Pilih Gambar"),
                  ),
                  const SizedBox(height: 8),
                  context.watch<AddStoryProvider>().isLoadingAddStory
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final Story story = Story(
                                // name: titleController.text,
                                description: descriptionController.text,
                                photoUrl: _mediaFileList?.last.path,
                              );
                              final authRead = context.read<AddStoryProvider>();

                              final result = await authRead.addStory(story);
                              if (result) {
                                widget.onSuccessAdd();
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Failed Add Story",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            }
                          },
                          child: const Text("Add Story"),
                        ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 300,
                  width: 100,
                  child: Image.file(
                    File(_mediaFileList![index].path),
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return const Center(child: Text('This image type is not supported'));
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: _mediaFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text('Pick image error: $_pickImageError', textAlign: TextAlign.center);
    } else {
      return const Text('You have not yet picked an image.', textAlign: TextAlign.center);
    }
  }
}

typedef OnPickImageCallback = void Function(double? maxWidth, double? maxHeight, int? quality, int? limit);
