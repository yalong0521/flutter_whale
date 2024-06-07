import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_whale/flutter_whale.dart';

double get screenWidth => appConfig.screenValueGetter.screenWidth;

double get screenHeight => appConfig.screenValueGetter.screenHeight;

double get paddingTop => appConfig.screenValueGetter.statusBarHeight;

double get paddingBottom => appConfig.screenValueGetter.bottomBarHeight;

bool get isDesktop =>
    !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
