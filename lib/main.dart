import 'package:flutter/material.dart';
import 'package:flutter_hive_tdo/data/hive_data_store.dart';
import 'package:flutter_hive_tdo/models/task.dart';
import 'package:flutter_hive_tdo/views/home/home_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  /// Init Hive DB before runApp
  await Hive.initFlutter();

  /// Register Hive Adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  /// Open a Box
  Box box = await Hive.openBox<Task>(HiveDataStore.boxName);

  /// This is step is not necessary
  /// Delete data from previous day
  for (var task in box.values) {
      if (task.createdAtTime.day != DateTime.now().day) {
        task.delete();
      } else {
        /// Do nothing
      }
    }

  runApp(BaseWidget(child: MyApp()));
}

/// The inherited widget provides us with a convenient way
/// to pass data between widgets. While developing an app
/// you will need some data from your parent's widgets or
/// grant parent widgets or maybe beyond that.
class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child})
      : super(child: child);

  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo App',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
          displaySmall: TextStyle(
            color: Color.fromARGB(255, 234, 234, 234),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          headlineSmall: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      // home: const HomeView(),
      home: const HomeView(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
