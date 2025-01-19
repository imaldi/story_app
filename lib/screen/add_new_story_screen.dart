import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/provider/add_story_provider.dart';

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
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TextFormField(
                  //   controller: titleController,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter your email.';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: const InputDecoration(
                  //     hintText: "Email",
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    obscureText: true,
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
                  context.watch<AddStoryProvider>().isLoadingAddStory
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final Story story = Story(
                                name: titleController.text,
                                description: descriptionController.text,
                              );
                              final authRead = context.read<AddStoryProvider>();

                              final result = await authRead.addStory(story);
                              if (result) widget.onSuccessAdd();
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
    );
  }
}
