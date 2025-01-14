import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/api/auth_api_service.dart';
import 'package:story_app/api/story_api_service.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
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

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository(AuthApiServices());

    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Router(
        routerDelegate: myRouterDelegate,

        /// todo 5: add backButtonnDispatcher to handle System Back Button
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
