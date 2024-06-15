import 'package:example/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseApp(
      builder: (context, key) {
        return MaterialApp(
          navigatorKey: key,
          debugShowCheckedModeBanner: false,
          home: const MainPage().page(),
        );
      },
    );
  }
}
