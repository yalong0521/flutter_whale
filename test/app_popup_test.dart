import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_whale/flutter_whale.dart';

const _triggerKey = ValueKey('popup-trigger');
const _contentKey = ValueKey('popup-content');
const _nestedPortalKey = ValueKey('nested-portal');
const _nestedPortalLabel = PortalLabel('bounded-test-portal');
const _windowSize = Size(800, 600);

void main() {
  testWidgets('显式关闭边界平移时保持锚点位置和原有向上翻转行为', (tester) async {
    await _pumpPopup(tester, keepAnchor: true);
    await _openPopup(tester);

    final trigger = tester.getRect(find.byKey(_triggerKey));
    final content = tester.getRect(find.byKey(_contentKey));
    expect(content.size, const Size(300, 400));
    expect(content.bottom, closeTo(trigger.top - 2, 0.01));
    expect(content.center.dx, closeTo(trigger.center.dx, 0.01));
    expect(content.top, lessThan(0));
    expect(content.right, greaterThan(_windowSize.width));
  });

  testWidgets('默认将越过上边和右边的内容移回Portal且保留自然尺寸', (tester) async {
    await _pumpPopup(tester);
    await _openPopup(tester);

    final trigger = tester.getRect(find.byKey(_triggerKey));
    final content = tester.getRect(find.byKey(_contentKey));
    expect(content.size, const Size(300, 400));
    expect(content.top, closeTo(0, 0.01));
    expect(content.right, closeTo(_windowSize.width, 0.01));
    expect(content.left, greaterThanOrEqualTo(0));
    expect(content.bottom, lessThanOrEqualTo(_windowSize.height));
    // 边界平移允许覆盖触发器，而不是把内容压缩到按钮的单侧空间。
    expect(content.overlaps(trigger), isTrue);
  });

  testWidgets('有界嵌套Portal使用自己的边界而不是整屏边界', (tester) async {
    await _pumpPopup(tester, nested: true);
    await _openPopup(tester);

    final bounds = tester.getRect(find.byKey(_nestedPortalKey));
    final content = tester.getRect(find.byKey(_contentKey));
    expect(bounds, const Rect.fromLTWH(100, 80, 300, 220));
    expect(content.size, const Size(200, 180));
    expect(content.right, closeTo(bounds.right, 0.01));
    expect(content.bottom, closeTo(bounds.bottom, 0.01));
    expect(content.left, greaterThanOrEqualTo(bounds.left));
    expect(content.top, greaterThanOrEqualTo(bounds.top));
  });

  testWidgets('无maxHeight的长列表由Portal限高且可滚动选择末项', (tester) async {
    int? selected;
    await _pumpPopup(
      tester,
      popupContent: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40, child: Text('请选择')),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemExtent: 40,
                itemCount: 40,
                itemBuilder: (_, index) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => selected = index,
                  child: Center(child: Text('选项${index + 1}')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    await _openPopup(tester);

    final content = tester.getRect(find.byKey(_contentKey));
    expect(content.width, 300);
    expect(content.height, closeTo(_windowSize.height - 2, 0.01));
    expect(content.top, greaterThanOrEqualTo(0));
    expect(content.right, lessThanOrEqualTo(_windowSize.width));
    expect(content.bottom, lessThanOrEqualTo(_windowSize.height));
    expect(find.text('选项40').hitTestable(), findsNothing);

    await tester.scrollUntilVisible(
      find.text('选项40'),
      300,
      scrollable: find.descendant(
        of: find.byKey(_contentKey),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('选项40'));
    expect(selected, 39);
    expect(tester.takeException(), isNull);
  });

  for (final alignment in [
    PopupAlignment.bottomCenter,
    PopupAlignment.topCenter,
    PopupAlignment.rightCenter,
    PopupAlignment.leftCenter,
  ]) {
    testWidgets('$alignment边界平移后绘制的箭头仍指向触发器', (tester) async {
      final vertical = alignment == PopupAlignment.bottomCenter ||
          alignment == PopupAlignment.topCenter;
      await _pumpPopup(
        tester,
        alignment: alignment,
        shape: TwinkleBgShape(triangleSize: 8, radius: 4),
        contentSize: vertical ? const Size(300, 120) : const Size(120, 300),
        position: switch (alignment) {
          PopupAlignment.bottomCenter => const Offset(740, 100),
          PopupAlignment.topCenter => const Offset(740, 500),
          PopupAlignment.rightCenter => const Offset(100, 550),
          _ => const Offset(660, 550),
        },
      );
      await _openPopup(tester);

      final (bounds, path) = _paintedShape(tester);
      final trigger = tester.getRect(find.byKey(_triggerKey));
      expect(vertical ? bounds.right : bounds.bottom,
          vertical ? _windowSize.width : _windowSize.height);
      _expectArrowAtTrigger(path, bounds, trigger, alignment);
    });
  }

  testWidgets('嵌套Portal内平移后按实际位置绘制箭头', (tester) async {
    await _pumpPopup(
      tester,
      nested: true,
      position: const Offset(240, 20),
      contentSize: const Size(200, 100),
      shape: TwinkleBgShape(triangleSize: 8, radius: 4),
    );
    await _openPopup(tester);

    final (bounds, path) = _paintedShape(tester);
    expect(bounds.right, 400);
    _expectArrowAtTrigger(path, bounds, tester.getRect(find.byKey(_triggerKey)),
        PopupAlignment.bottomCenter);
  });

  testWidgets('双轴平移覆盖触发器时保留尺寸并绘制完整背景', (tester) async {
    await _pumpPopup(
      tester,
      shape: TwinkleBgShape(triangleSize: 8, radius: 4),
    );
    await _openPopup(tester);

    final (bounds, path) = _paintedShape(tester);
    expect(bounds.size, const Size(300, 408));
    expect(bounds.top, 0);
    expect(bounds.right, _windowSize.width);
    expect(bounds.overlaps(tester.getRect(find.byKey(_triggerKey))), isTrue);
    // 箭头原本朝下；目标被覆盖后，应完整填充这一侧而不是留下三角尖端。
    expect(path.contains(Offset(20, bounds.height - 0.5)), isTrue);
    expect(
        path.contains(Offset(bounds.width - 20, bounds.height - 0.5)), isTrue);
  });

  testWidgets('展开时切换双轴与单轴边界配置保留内部State和滚动位置', (tester) async {
    final flags = ValueNotifier(const AxisFlag(x: true, y: true));
    addTearDown(flags.dispose);
    await _pumpPopup(
      tester,
      popup: ValueListenableBuilder<AxisFlag>(
        valueListenable: flags,
        builder: (_, value, child) => AppPopup(
          shiftToWithinBound: value,
          buttonViewBuilder: (_, toggle) => GestureDetector(
            key: _triggerKey,
            behavior: HitTestBehavior.opaque,
            onTap: toggle,
            child: const SizedBox(width: 40, height: 40),
          ),
          popupViewBuilder: (_) => const _PersistentPopupContent(),
          popupAnimator: OpacityTranslateAnimator(),
        ),
      ),
    );
    await _openPopup(tester);
    await tester.tap(find.text('计数：0'));
    await tester.pump();
    final scrollable = find.descendant(
        of: find.byKey(_contentKey), matching: find.byType(Scrollable));
    await tester.drag(scrollable, const Offset(0, -180));
    await tester.pumpAndSettle();
    final state = tester.state(find.byType(_PersistentPopupContent));
    final scrollOffset =
        tester.state<ScrollableState>(scrollable).position.pixels;
    expect(scrollOffset, greaterThan(0));

    for (final value in [
      const AxisFlag(),
      const AxisFlag(x: true),
      const AxisFlag(y: true),
      const AxisFlag(x: true, y: true),
    ]) {
      flags.value = value;
      await tester.pumpAndSettle();
      final bounds = tester.getRect(find.byKey(_contentKey));
      expect(bounds.left, value.x ? 500 : 600);
      expect(bounds.top, value.y ? 0 : -182);
      expect(tester.state(find.byType(_PersistentPopupContent)), same(state));
      expect(find.text('计数：1'), findsOneWidget);
      expect(tester.state<ScrollableState>(scrollable).position.pixels,
          closeTo(scrollOffset, 0.01));
    }
  });
}

Future<void> _openPopup(WidgetTester tester) async {
  await tester.tap(find.byKey(_triggerKey));
  await tester.pumpAndSettle();
}

Future<void> _pumpPopup(
  WidgetTester tester, {
  bool keepAnchor = false,
  bool nested = false,
  Widget? popupContent,
  Widget? popup,
  PopupAlignment alignment = PopupAlignment.bottomCenter,
  PopupBgShape? shape,
  Size? contentSize,
  Offset? position,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = _windowSize;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  ScreenUtil.refresh();

  final popupWidget = popup ??
      _popup(
        keepAnchor: keepAnchor,
        contentSize: contentSize ??
            (nested ? const Size(200, 180) : const Size(300, 400)),
        popupContent: popupContent,
        alignment: alignment,
        shape: shape,
        portalLabels:
            nested ? const [_nestedPortalLabel] : const [PortalLabel.main],
      );
  await tester.pumpWidget(
    BaseApp(
      designSize: _windowSize,
      builder: (_, navigatorKey) => MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          body: Stack(
            children: [
              if (nested)
                Positioned(
                  left: 100,
                  top: 80,
                  width: 300,
                  height: 220,
                  child: Portal(
                    labels: const [_nestedPortalLabel],
                    child: SizedBox.expand(
                      key: _nestedPortalKey,
                      child: Stack(
                        children: [
                          Positioned(
                              left: position?.dx ?? 240,
                              top: position?.dy ?? 170,
                              child: popupWidget),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                    left: position?.dx ?? 730,
                    top: position?.dy ?? 220,
                    child: popupWidget),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

AppPopup _popup({
  required bool keepAnchor,
  required Size contentSize,
  required List<PortalLabel<dynamic>> portalLabels,
  Widget? popupContent,
  PopupAlignment alignment = PopupAlignment.bottomCenter,
  PopupBgShape? shape,
}) {
  Widget buttonBuilder(bool visible, VoidCallback onTap) => GestureDetector(
        key: _triggerKey,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: const SizedBox(width: 40, height: 40),
      );
  Widget popupBuilder(VoidCallback dismiss) => KeyedSubtree(
        key: _contentKey,
        child: popupContent ??
            SizedBox.fromSize(
              size: contentSize,
              child: const ColoredBox(color: Colors.white),
            ),
      );

  if (keepAnchor) {
    return AppPopup(
      popupAlignment: alignment,
      popupBgShape: shape,
      popupAnimator: OpacityTranslateAnimator(),
      buttonViewBuilder: buttonBuilder,
      popupViewBuilder: popupBuilder,
      portalCandidateLabels: portalLabels,
      shiftToWithinBound: const AxisFlag(),
    );
  }
  // 不传参数，验证调用方默认使用 Portal 边界平移。
  return AppPopup(
    popupAlignment: alignment,
    popupBgShape: shape,
    popupAnimator: OpacityTranslateAnimator(),
    buttonViewBuilder: buttonBuilder,
    popupViewBuilder: popupBuilder,
    portalCandidateLabels: portalLabels,
  );
}

(Rect, Path) _paintedShape(WidgetTester tester) {
  final finder = find.ancestor(
    of: find.byKey(_contentKey),
    matching: find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter != null),
  );
  expect(finder, findsOneWidget);
  final bounds = tester.getRect(finder);
  final canvas = TestRecordingCanvas();
  tester.widget<CustomPaint>(finder).painter!.paint(canvas, bounds.size);
  final draws = canvas.invocations
      .where((entry) => entry.invocation.memberName == #drawPath);
  expect(draws, hasLength(1));
  return (bounds, draws.single.invocation.positionalArguments.first as Path);
}

void _expectArrowAtTrigger(
    Path path, Rect bounds, Rect trigger, PopupAlignment alignment) {
  final tip = switch (alignment) {
    PopupAlignment.bottomCenter => Offset(trigger.center.dx - bounds.left, 0.5),
    PopupAlignment.topCenter =>
      Offset(trigger.center.dx - bounds.left, bounds.height - 0.5),
    PopupAlignment.rightCenter => Offset(0.5, trigger.center.dy - bounds.top),
    _ => Offset(bounds.width - 0.5, trigger.center.dy - bounds.top),
  };
  final tangent = alignment == PopupAlignment.bottomCenter ||
          alignment == PopupAlignment.topCenter
      ? const Offset(3, 0)
      : const Offset(0, 3);
  // 尖端切片只应有三角形，矩形背景不能误通过箭头位置断言。
  expect(path.contains(tip), isTrue, reason: '箭头尖端应指向触发器中心');
  expect(path.contains(tip + tangent), isFalse);
  expect(path.contains(tip - tangent), isFalse);
}

class _PersistentPopupContent extends StatefulWidget {
  const _PersistentPopupContent();

  @override
  State<_PersistentPopupContent> createState() =>
      _PersistentPopupContentState();
}

class _PersistentPopupContentState extends State<_PersistentPopupContent> {
  int count = 0;

  @override
  Widget build(BuildContext context) => SizedBox(
        key: _contentKey,
        width: 300,
        height: 400,
        child: Column(children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => count++),
            child: SizedBox(height: 40, child: Text('计数：$count')),
          ),
          Expanded(
              child: ListView.builder(
            itemExtent: 40,
            itemCount: 40,
            itemBuilder: (_, index) => Text('条目$index'),
          )),
        ]),
      );
}
