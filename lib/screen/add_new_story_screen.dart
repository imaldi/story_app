import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/utils/file_compressor.dart';

class AddNewStoryScreen extends StatefulWidget {
  const AddNewStoryScreen(
      {required this.onPop, required this.onSuccessAdd, super.key});

  final Function() onPop;
  final Function() onSuccessAdd;

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

  List<XFile>? _mediaFileList;

  dynamic _pickImageError;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.onPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Story'),
        ),
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
                      decoration: const InputDecoration(
                        hintText: "Description",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    _previewImages(),
                    const SizedBox(height: 8),
                    ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Confirm",
                                  ),
                                ],
                              ),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Silahkan pilih sumber gambar",
                                    softWrap: true,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                              actions: [
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          height: 45,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await _onImageButtonPressed(
                                                  ImageSource.gallery,
                                                  context: context);
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              side: const BorderSide(
                                                  color: Colors.greenAccent),
                                            ),
                                            child: const Text(
                                              "Gallery",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Flexible(
                                        child: Container(
                                          height: 45,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              side: const BorderSide(
                                                  color: Colors.greenAccent),
                                            ),
                                            onPressed: () async {
                                              await _onImageButtonPressed(
                                                  ImageSource.camera,
                                                  context: context);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "Camera",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                          // _onImageButtonPressed(ImageSource.gallery,
                          //     context: context);
                        },
                        child: const Text("Pilih Gambar")),
                    const SizedBox(height: 8),
                    context.watch<AddStoryProvider>().isLoadingAddStory
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final Story story = Story(
                                    // name: titleController.text,
                                    description: descriptionController.text,
                                    photoUrl: _mediaFileList?.last.path);
                                final authRead =
                                    context.read<AddStoryProvider>();

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
                                      fontSize: 16.0);
                                }
                              }
                            },
                            child: const Text("Add Story"),
                          ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
      );

      // File file = File(pickedFile?.path ?? '');

      if (pickedFile != null) {
        var compressedImage = await fileCompressor(pickedFile, maxInMB: 1);
        setState(() {
          _setImageFileListFromFile(compressedImage);
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
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
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Center(
                          child: Text('This image type is not supported'));
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
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);
