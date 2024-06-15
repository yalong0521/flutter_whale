import 'package:example/pages/main_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

class MainPage extends BasePage<MainModel> {
  const MainPage({super.key});

  @override
  MainModel createModel(BuildContext context) => MainModel(context);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends BaseState<MainPage, MainModel> {

  @required
  void initState() {
    context.watch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('蓝鲸'),
      ),
    );
  }
}
