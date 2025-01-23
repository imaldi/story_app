import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/screen/choose_image_source_dialog.dart';

class DialogWrapperPage extends Page {
  const DialogWrapperPage(
      {required this.chooseImageStateNotifier, required this.callbackImageChosenNotifier}) : super(key: const ValueKey("ChooseImage"));
  final ValueNotifier<Future<void> Function(ImageSource source, {required BuildContext context})?> callbackImageChosenNotifier;
  final ValueNotifier<bool?> chooseImageStateNotifier;


  @override
  Route createRoute(BuildContext context) {
    return CupertinoDialogRoute(
      settings: this,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      // fullscreenDialog: false,
      builder: (BuildContext context) {
        return ChooseImageSourceDialog(callbackImageChosenNotifier: callbackImageChosenNotifier, chooseImageStateNotifier: chooseImageStateNotifier,);
      },
      context: context,
    );
  }
}
