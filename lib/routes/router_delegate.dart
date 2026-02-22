import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/entity/color_code.dart';
import 'package:story_app/model/shape_border_type.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/pages/dialog_wrapper_page.dart';
import 'package:story_app/screen/add_new_story_screen.dart';
import 'package:story_app/screen/login_screen.dart';
import 'package:story_app/screen/register_screen.dart';
import 'package:story_app/screen/splash_screen.dart';
import 'package:story_app/screen/stories_list_screen.dart';
import 'package:story_app/screen/story_detail_screen.dart';

import '../model/page_configuration.dart';
import '../screen/unknown_screen.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool? isUnknown;
  bool isRegister = false;
  bool isAddingNewStory = false;
  // Value Notifier to track value across app
  // final ValueNotifier<ColorCode?> _colorCodeNotifier = ValueNotifier(null);
  // final ValueNotifier<ShapeBorderType?> _shapeBorderTypeNotifier =
  //     ValueNotifier(null);
  final ValueNotifier<bool?> _unknownStateNotifier = ValueNotifier(null);
  final ValueNotifier<bool?> _chooseImageStateNotifier = ValueNotifier(null);
  final ValueNotifier<Future<void> Function(ImageSource source, {required BuildContext context})?> _callbackImageChosenNotifier = ValueNotifier(null);
  final AuthRepository authRepository;
  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedStory;
  String? selectedStoryPath;

  List<Page> get _unknownStack => const [
        MaterialPage(
          key: ValueKey("UnknownPage"),
          child: UnknownScreen(),
        ),
      ];

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
              onPop: () {
                isRegister = false;
                notifyListeners();
              },
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
  List<Page> _loggedInStack(BuildContext context) =>
      [
        MaterialPage(
          key: const ValueKey("QuotesListPage"),
          child: StoriesListScreen(
            onTapped: (String storyId, String storyImagePath) {
              selectedStory = storyId;
              selectedStoryPath = storyImagePath;
              notifyListeners();
            },
            onFabTapped: () {
              isAddingNewStory = true;
              notifyListeners();
            },
            onLogout: () {
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
                context.read<StoryListProvider>().fetchStoryList();

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
              isChoosingImageSourceNotifier: _chooseImageStateNotifier,
              callbackImageChosenNotifier: _callbackImageChosenNotifier,
            ),
          ),
        if (_chooseImageStateNotifier.value != null && _chooseImageStateNotifier.value == true && _callbackImageChosenNotifier.value != null)
          DialogWrapperPage(callbackImageChosenNotifier: _callbackImageChosenNotifier, chooseImageStateNotifier: _chooseImageStateNotifier)
      ];

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    Listenable.merge([
      // _shapeBorderTypeNotifier,
      _unknownStateNotifier,
      _chooseImageStateNotifier
      // _colorCodeNotifier,
    ]).addListener(() {
      print("notifying the router widget");
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isUnknown == true) {
      historyStack = _unknownStack;
    } else if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack(context);
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: _unknownStateNotifier.value == true
          ? [
              const MaterialPage(
                key: ValueKey<String>("Unknown"),
                child: UnknownScreen(),
              )
            ]
          : historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        selectedStory = null;
        _chooseImageStateNotifier.value = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (isLoggedIn == null) {
      return PageConfiguration.splash();
    } else if (isRegister == true) {
      return PageConfiguration.register();
    } else if (isLoggedIn == false) {
      return PageConfiguration.login();
    } else if (isUnknown == true) {
      return PageConfiguration.unknown();
    } else if (selectedStory == null) {
      return PageConfiguration.home();
    } else if (isAddingNewStory) {
      return PageConfiguration.addNewStory();
    } else if (_chooseImageStateNotifier.value != null) {
      return PageConfiguration.chooseImageDialog(
      );
    } else if (selectedStory != null) {
      return PageConfiguration.detailStory(selectedStory!);
    } else {
      return null;
    }
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    if (configuration.isUnknownPage) {
      isUnknown = true;
      isRegister = false;
    } else if (configuration.isRegisterPage) {
      isRegister = true;
    } else if (configuration.isHomePage ||
        configuration.isLoginPage ||
        configuration.isSplashPage) {
      isUnknown = false;
      selectedStory = null;
      isRegister = false;
    } else if (configuration.isDetailPage) {
      isUnknown = false;
      isRegister = false;
      selectedStory = configuration.storyId.toString();
    } else if (configuration.isChoosingImageSourcePage) {
      _unknownStateNotifier.value = false;
      _chooseImageStateNotifier.value = true;
    } else {
      print(' Could not set new route');
    }

    notifyListeners();
  }
}
