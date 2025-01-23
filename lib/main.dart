import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:story_app/api/auth_api_service.dart';
import 'package:story_app/api/story_api_service.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/route_information_parser.dart';
import 'package:story_app/routes/router_delegate.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context)=>AuthProvider(AuthRepository(AuthApiServices()))),
      ChangeNotifierProvider(create: (context)=>StoryListProvider(StoryApiServices())),
      ChangeNotifierProvider(create: (context)=>StoryDetailProvider(StoryApiServices())),
      ChangeNotifierProvider(create: (context)=>AddStoryProvider(StoryApiServices())),
    ],
    child: const StoryApp()));
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late MyRouterDelegate myRouterDelegate;
  late MyRouteInformationParser myRouteInformationParser;
  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository(AuthApiServices());

    myRouterDelegate = MyRouterDelegate(authRepository);

    myRouteInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Router(
        routerDelegate: myRouterDelegate,
        routeInformationParser: myRouteInformationParser,
        /// todo 5: add backButtonnDispatcher to handle System Back Button
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
      builder: EasyLoading.init(),
    );
  }
}
