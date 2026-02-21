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


    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent - 200) {
        final state = context.read<StoryListProvider>().state;
        if (state is StoryListLoaded && !state.isLoadingMore && !state.hasReachedEnd) {
          final currentLength = state.data.length;
          context.read<StoryListProvider>().fetchStoryList(
            page: (currentLength ~/ 10) + 1,
            size: 10,
          );
        }
      }
    });
    super.initState();
  }
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, state, child) {
        return Consumer<StoryListProvider>(
          builder: (context, provider, child) {
            final state = provider.state;

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
              body: switch (state) {
                StoryListInitialLoading() => const Center(child: CircularProgressIndicator()),
                StoryListError(:final message) => Center(child: Text(message)),
                StoryListLoaded(
                data: final stories,
                isLoadingMore: final loadingMore,
                hasReachedEnd: final endReached,
                ) => RefreshIndicator(
                  onRefresh: provider.refresh,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: stories.length + (loadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < stories.length) {
                        final story = stories[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: Image.network(
                                story.photoUrl ?? "",
                                fit: BoxFit.cover,
                                errorBuilder: (context, object, stacTrace) {
                                  return const Column(
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
                          onTap: () => widget.onTapped(story.id ?? "", story.photoUrl ?? ''),
                        );
                      }
                      // else if(endReached) {
                      //   return Text("No more");
                      // }
                      else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
                _ => const SizedBox(),
              },
              floatingActionButton: FloatingActionButton(
                  onPressed: widget.onFabTapped,
                  child: const Icon(Icons.add)),
            );
          },
        );
      },
    );
  }
}
