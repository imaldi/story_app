import 'package:flutter/material.dart';
import 'package:story_app/db/auth_repository.dart';
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
  final AuthRepository authRepository;
  MyRouterDelegate(this.authRepository) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedStory;

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
        onTapped: (String storyId) {
          selectedStory = storyId;
          notifyListeners();
        },
      ),
    ),
    if (selectedStory != null)
      MaterialPage(
        key: ValueKey(selectedStory),
        child: StoryDetailsScreen(
          storyId: selectedStory!,
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