import 'dart:io';

import 'package:flutter/foundation.dart';

bool get isDesktop =>
    !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
