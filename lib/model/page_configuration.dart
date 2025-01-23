import 'package:story_app/model/shape_border_type.dart';

class PageConfiguration {
  final bool unknown;
  final bool register;
  final bool? loggedIn;
  final bool isAddNewStory;
  final bool isChoosingImageSource;
  final String? storyId;

  PageConfiguration.splash()
      : unknown = false,
        register = false,
        isAddNewStory = false,
        isChoosingImageSource = false,
        loggedIn = null,
        storyId = null;

  PageConfiguration.login()
      : unknown = false,
        register = false,
        isAddNewStory = false,
        isChoosingImageSource = false,
        loggedIn = false,
        storyId = null;

  PageConfiguration.register()
      : unknown = false,
        register = true,
        isAddNewStory = false,
        isChoosingImageSource = false,
        loggedIn = false,
        storyId = null;

  PageConfiguration.home()
      : unknown = false,
        register = false,
        isAddNewStory = false,
        isChoosingImageSource = false,
        loggedIn = true,
        storyId = null;

  PageConfiguration.addNewStory()
      : unknown = false,
        register = false,
        isAddNewStory = true,
        isChoosingImageSource = false,
        loggedIn = true,
        storyId = null;

  PageConfiguration.detailStory(String id)
      : unknown = false,
        register = false,
        isAddNewStory = false,
        isChoosingImageSource = false,
        loggedIn = true,
        storyId = id;

  PageConfiguration.chooseImageDialog()
      : unknown = false,
        register = false,
        isAddNewStory = true,
        isChoosingImageSource = true,
        loggedIn = true,
        storyId = null;


  PageConfiguration.unknown()
      : unknown = true,
        register = false,
        isAddNewStory = false,
        isChoosingImageSource = false,
        loggedIn = null,
        storyId = null;

  bool get isSplashPage =>
      unknown == false && loggedIn == null;
  bool get isLoginPage =>
      unknown == false && loggedIn == false;
  bool get isHomePage =>
      unknown == false && loggedIn == true && storyId == null;
  bool get isDetailPage =>
      unknown == false && loggedIn == true && storyId != null;
  bool get isAddNewStoryPage =>
      unknown == false && loggedIn == true && isAddNewStory == true && isChoosingImageSource == false;
  bool get isChoosingImageSourcePage =>
      unknown == false && loggedIn == true && isAddNewStory == true && isChoosingImageSource == true;
  bool get isRegisterPage => register == true;
  bool get isUnknownPage => unknown == true;
}