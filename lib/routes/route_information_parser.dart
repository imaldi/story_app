import 'package:flutter/material.dart';

import '../model/page_configuration.dart';
import '../model/shape_border_type.dart';

class MyRouteInformationParser
    extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location.toString());

    if (uri.pathSegments.isEmpty) {
      // without path parameter => "/"
      return PageConfiguration.home();
    } else if (uri.pathSegments.length == 1) {
      // path parameter => "/aaa"
      final first = uri.pathSegments[0].toLowerCase();
      if (first == 'home') {
        return PageConfiguration.home();
      } else if (first == 'login') {
        return PageConfiguration.login();
      } else if (first == 'register') {
        return PageConfiguration.register();
      } else if (first == 'splash') {
        return PageConfiguration.splash();
      } else {
        return PageConfiguration.unknown();
      }
    } else if (uri.pathSegments.length == 2) {
      // path parameter => "/aaa/bbb"
      final first = uri.pathSegments[0].toLowerCase();
      final second = uri.pathSegments[1].toLowerCase();
      final storyId = int.tryParse(second) ?? 0;
      if (first == 'story' && storyId >= 1) {
        return PageConfiguration.detailStory(second);
      } else {
        return PageConfiguration.unknown();
      }
    } else if (uri.pathSegments.length == 3) {
      final first = uri.pathSegments[0].toLowerCase();
      final second = uri.pathSegments[1].toLowerCase();
      final three = uri.pathSegments[2].toLowerCase();
      if (first == 'story' && second == 'create' && three != 'choose_image_source') {
        return PageConfiguration.chooseImageDialog();
      } else {
        return PageConfiguration.unknown();
      }
    } else {
      return PageConfiguration.unknown();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(PageConfiguration configuration) {
    // TODO: refactor location => uri param
    if (configuration.isUnknownPage) {
      return const RouteInformation(location: '/unknown');
    } else if (configuration.isSplashPage) {
      return const RouteInformation(location: '/splash');
    } else if (configuration.isRegisterPage) {
      return const RouteInformation(location: '/register');
    } else if (configuration.isLoginPage) {
      return const RouteInformation(location: '/login');
    } else if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    } else if (configuration.isAddNewStoryPage) {
      return const RouteInformation(location: '/create');
    } else if (configuration.isDetailPage) {
      return RouteInformation(location: '/story/${configuration.storyId}');
    } else if (configuration.isChoosingImageSourcePage) {
      final location = '/story/create/choose_image_source';
      return RouteInformation(location: location);
    } else {
      return null;
    }
  }
}

ShapeBorderType? extractShapeBorderType(String shapeBorderTypeValue) {
  final value = shapeBorderTypeValue.toLowerCase();
  switch (value) {
    case CONTINUOUS_SHAPE:
      return ShapeBorderType.CONTINUOUS;
    case BEVELED_SHAPE:
      return ShapeBorderType.BEVELED;
    case ROUNDED_SHAPE:
      return ShapeBorderType.ROUNDED;
    case STADIUM_SHAPE:
      return ShapeBorderType.STADIUM;
    case CIRCLE_SHAPE:
      return ShapeBorderType.CIRCLE;
    default:
      return null;
  }
}