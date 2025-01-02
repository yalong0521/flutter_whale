import 'dart:io';

import 'flutter_whale.dart';

export 'package:dio/dio.dart';
export 'package:path/path.dart' hide context;
export 'package:path_provider/path_provider.dart';
export 'package:provider/provider.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:synchronized/synchronized.dart';

export 'src/base/base_app.dart';
export 'src/base/base_model.dart';
export 'src/base/base_page.dart';
export 'src/ext/color_ext.dart';
export 'src/ext/controller_ext.dart';
export 'src/ext/date_time_ext.dart';
export 'src/ext/formatter_ext.dart';
export 'src/ext/func_ext.dart';
export 'src/ext/future_ext.dart';
export 'src/ext/iterable_ext.dart';
export 'src/ext/map_ext.dart';
export 'src/ext/num_ext.dart';
export 'src/ext/string_ext.dart';
export 'src/ext/ui_ext.dart';
export 'src/ext/widget_ext.dart';
export 'src/net/base_client.dart';
export 'src/net/interceptor/log_interceptor.dart';
export 'src/net/interceptor/print_interceptor.dart';
export 'src/util/common_util.dart';
export 'src/util/date_format.dart';
export 'src/util/date_util.dart';
export 'src/util/dialog_util.dart';
export 'src/util/keyboard_util.dart';
export 'src/util/log_util.dart';
export 'src/util/route_util.dart';
export 'src/util/store_util.dart';
export 'src/util/toast_util.dart';
export 'src/util/transition_util.dart';
export 'src/widget/app_expansion_panel.dart';
export 'src/widget/app_text.dart';
export 'src/widget/dash.dart';
export 'src/widget/divider.dart';
export 'src/widget/dotted_border.dart';
export 'src/widget/fitted_text.dart';
export 'src/widget/keep_alive_wrapper.dart';
export 'src/widget/nil.dart';
export 'src/widget/no_padding_list_view.dart';
export 'src/widget/spacer.dart';
export 'src/widget/tap_wrapper.dart';

Future<Directory> getAppDir([String? dirName]) async {
  Directory? dir;
  if (Platform.isAndroid) {
    var externalStorageDir = await getExternalStorageDirectory();
    if (externalStorageDir != null) dir = externalStorageDir;
  } else if (Platform.isWindows) {
    dir = await getApplicationSupportDirectory();
  }
  dir = dir ?? await getApplicationDocumentsDirectory();
  if (!dir.existsSync()) dir.createSync(recursive: true);
  if (dirName == null) return dir;
  var subDir = Directory(join(dir.path, dirName));
  if (!subDir.existsSync()) subDir.createSync(recursive: true);
  return subDir;
}
