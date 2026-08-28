## 2.0.7

- DateTimeExt&AutoRefreshState&NoPaddingListView&NoPaddingSingleChildScrollView

## 2.0.8

- remove BasePage constructor param refreshWhenDimensionsChange

## 2.0.9

- dialog didPop check loading dialog state

## 2.1.0

- new widget: AppPopup、AppTapper、AppVisibilityDetector、AutoSizeText、FreeWidthDialog、ResizeSwitch

## 2.1.1

- Complete exception log

## 2.1.2

- AppPopup Optimize

## 2.1.3

- BaseClient support more param

## 2.1.5

- app_popup add mounted status check

## 2.1.5

- app_tapper add param: enableThrottle

## 2.1.6

- AppVisibilityDetector add callback: onInvisible

## 2.1.7

- app_popup optimize

## 2.1.8

- performance optimization

## 2.1.9

- Optimized the BaseUrl passing mechanism.

## 2.2.0

- ErrorResponse add data filed.

## 2.2.1

- AppTapper add disableColor filed.

## 2.2.2

- Optimize button touch feedback effect.
- Add focus state handling to the loading popup.

## 2.2.3

- ResizeSwitch supports passing in an enabled state.

## 2.2.4

- Add network request duration output to the log.

## 2.2.5

- app_popup component adds onPopupVisibleChanged callback.

## 2.2.6

- Add new transition type: ScaleFade.
- Fix incorrect name parameter passing issue in BasePage.toOff method.

## 2.2.7

- Bugfix.

## 2.2.8

- Optimize.

## 2.2.9

- Optimize.

## 2.3.0

- Renamed `showDialog` method to `to` for clarity
- Added new `off` method for dialog replacement functionality

## 2.3.1

- Optimize.

## 2.3.2

- Optimize.

## 2.3.3

- Optimize.

## 2.3.4

- Optimize.

## 2.3.5

- Optimize.

## 2.3.6

- 移除common_util.dart中的屏幕尺寸相关方法
- 新增screen_util.dart文件实现ScreenUtil工具类
- 使用FlutterView直接获取物理屏幕尺寸和安全区域
- 更新flutter_whale.dart导出ScreenUtil并添加初始化方法

## 2.3.7

- 更新dio依赖从5.3.3到5.10.0版本
- 添加DioExceptionType.transformTimeout类型的错误处理

## 2.3.8

- 在 pop 和 popUntil 方法中设置忽略加载状态标志
- 修改 didPop 方法逻辑，检查忽略标志后再判断加载状态
- 重置忽略加载状态标志以确保正常流程

## 2.3.9

- 新增 `RouteUtil.maybePop`，支持遵守 `PopScope` 的用户主动退出场景
- 修复 Loading 关闭后在已销毁 Context 上恢复焦点的问题
