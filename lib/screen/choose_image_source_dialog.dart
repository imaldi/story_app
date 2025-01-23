import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/extensions/color_extensions.dart';
import 'package:story_app/model/shape_border_type.dart';
import 'package:story_app/widgets/app_bar_back_button.dart';
import 'package:story_app/widgets/app_bar_text.dart';

import '../utils/file_compressor.dart';

class ChooseImageSourceDialog extends StatefulWidget {
  final ValueNotifier<bool?> chooseImageStateNotifier;
  final ValueNotifier<Future<void> Function(ImageSource source, {required BuildContext context})?> callbackImageChosenNotifier;

  const ChooseImageSourceDialog({
    required this.callbackImageChosenNotifier,
    required this.chooseImageStateNotifier,
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseImageSourceDialog> createState() => _ChooseImageSourceDialogState();
}

class _ChooseImageSourceDialogState extends State<ChooseImageSourceDialog> {
  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
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
                        await widget.callbackImageChosenNotifier.value!.call(
                            ImageSource.gallery,
                            context: context);
                        widget.chooseImageStateNotifier.value = false;
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
                        await widget.callbackImageChosenNotifier.value!.call(
                            ImageSource.camera,
                            context: context);
                        widget.chooseImageStateNotifier.value = false;
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
      );
  }
}