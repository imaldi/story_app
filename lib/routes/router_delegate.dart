import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/screen/add_new_story_screen.dart';
import 'package:story_app/screen/login_screen.dart';
import 'package:story_app/screen/register_screen.dart';
import 'package:story_app/screen/splash_screen.dart';
import 'package:story_app/screen/stories_list_screen.dart';
import 'package:story_app/screen/story_detail_screen.dart';

import '../model/story.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAddingNewStory = false;
  final AuthRepository authRepository;
  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedStory;
  String? selectedStoryPath;

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];
  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("QuotesListPage"),
          child: StoriesListScreen(
            stories: stories,
            onTapped: (String storyId, String storyImagePath) {
              selectedStory = storyId;
              selectedStoryPath = storyImagePath;
              notifyListeners();
            },
            onFabTapped: () {
              isAddingNewStory = true;
              notifyListeners();
            },
            onLogout: (){
              isLoggedIn = false;
              notifyListeners();
            },
          ),
        ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey(selectedStory),
            child: StoryDetailsScreen(
              storyId: selectedStory!,
              storyImageUrl: selectedStoryPath,
            ),
          ),
        if (isAddingNewStory)
          MaterialPage(
            key: ValueKey("AddNewStoryPage"),
            child: AddNewStoryScreen(
              onPop: () {
                isAddingNewStory = false;
                notifyListeners();
              },
              onSuccessAdd: () {
                isAddingNewStory = false;
                notifyListeners();
                Fluttertoast.showToast(
                    msg: "Success Add Story",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.greenAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
          ),
      ];

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        selectedStory = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}
