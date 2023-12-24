import 'package:flutter/material.dart';

abstract class BaseModel<T extends StatefulWidget> extends ChangeNotifier {
  BuildContext context;
  bool disposed = false;

  BaseModel(this.context);

  void init() {}

  @override
  void notifyListeners() {
    if (disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
