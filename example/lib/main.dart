import 'package:app_bar_auto_hide/app_bar_auto_hide.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final ValueNotifier<ScrollNotification?> _notifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAutoHide(
        notifier: _notifier,
        toolbarHeight: 200,
        backgroundColor: Colors.deepPurple,
        title: Text('Auto Hide AppBar',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        autoHideThreshold: 800.0,
        animationDuration: Duration(milliseconds: 200),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _notifier.value = notification;
          return true;
        },
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Card(
                  color: Colors.primaries[index % Colors.primaries.length],
                  child: ListTile(
                    title: Text('Item $index'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }
}
