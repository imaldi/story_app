import 'package:flutter/material.dart';

class AddNewStoryScreen extends StatefulWidget {
  const AddNewStoryScreen({required this.onPop, super.key});

  final Function() onPop;

  @override
  State<AddNewStoryScreen> createState() => _AddNewStoryScreenState();
}

class _AddNewStoryScreenState extends State<AddNewStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        widget.onPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Story'),
        ),
      ),
    );
  }
}
