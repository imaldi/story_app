import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/static/story_list_result_state.dart';

class StoriesListScreen extends StatefulWidget {
  final Function(String, String) onTapped;
  final Function() onFabTapped;
  final Function() onLogout;

  const StoriesListScreen({
    Key? key,
    required this.onTapped,
    required this.onFabTapped,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<StoriesListScreen> createState() => _StoriesListScreenState();
}

class _StoriesListScreenState extends State<StoriesListScreen> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<StoryListProvider>().fetchStoryList();
    });


    scrollController.addListener(() async {
      if (scrollController.offset >= scrollController.position.maxScrollExtent) {
        log("Kepanggil");
        final listState = context.read<StoryListProvider>().resultListState;

        switch(listState){
          case StoryListNoneState(): break;
          case StoryListLoadingState(): break;
          case StoryListErrorState(): break;
          case StoryListLoadedState(data: var list):
            context.read<StoryListProvider>().fetchStoryList(
              page: (list.length ~/ 10) + 1,
              size: 10,
            );
        }
      }

      /// Ini sebenernya bisa untuk refresh
      // if (scrollController.offset <= scrollController.position.minScrollExtent) {
      //   widget.onRefresh?.call();
      // }
    });
    super.initState();
  }
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, state, child) {
        return Consumer<StoryListProvider>(
          builder: (context, value, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Story App"),
                actions: [
                  InkWell(
                    onTap: () async {
                      EasyLoading.show(
                          status: 'Logging Out', dismissOnTap: true);

                      final authRead = context.read<AuthProvider>();

                      final result = await authRead.logout();

                      if (result) {
                        EasyLoading.dismiss();
                        widget.onLogout();
                        Fluttertoast.showToast(
                            msg: "Success Log Out",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.greenAccent,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(Icons.logout),
                    ),
                  )
                ],
              ),
              body: switch (value.resultListState) {
                StoryListLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                StoryListLoadedState(data: var storyList) => RefreshIndicator(
                    onRefresh: () async {
                      await context.read<StoryListProvider>().fetchStoryList();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      //   ..addListener(() async {
                      //   if (scrollController.offset >= scrollController.position.maxScrollExtent) {
                      //
                      //     context.read<StoryListProvider>().fetchStoryList(
                      //       page: (storyList.length ~/ 10) + 1,
                      //       size: 10,
                      //     );
                      //     log("Kepanggil");
                      //     // final listState = context.read<StoryListProvider>().resultListState;
                      //     //
                      //     // switch(listState){
                      //     //   case StoryListNoneState(): break;
                      //     //   case StoryListLoadingState(): break;
                      //     //   case StoryListErrorState(): break;
                      //     //   case StoryListLoadedState(data: var list):
                      //     // }
                      //   }
                      //
                      //   /// Ini sebenernya bisa untuk refresh
                      //   // if (scrollController.offset <= scrollController.position.minScrollExtent) {
                      //   //   widget.onRefresh?.call();
                      //   // }
                      // }),
                      itemCount: storyList.length,
                      itemBuilder: (context, index){
                        final story = storyList[index];
                        return
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: Image.network(
                                  story.photoUrl ?? "",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, object, stacTrace) {
                                    return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image),
                                          Text("The image is not found"),
                                        ]);
                                  },
                                ),
                              ),
                            ),
                            title: Text(story.name ?? ""),
                            subtitle: Text(story.description ?? ""),
                            isThreeLine: true,
                            onTap: () => widget.onTapped(
                                story.id ?? "", story.photoUrl ?? ''),
                          );
                      },
                    ),
                  ),
                StoryListErrorState(error: var message) => Center(
                    child: Text(message),
                  ),
                _ => const SizedBox(),
              },
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add), onPressed: widget.onFabTapped),
            );
          },
        );
      },
    );
  }
}
