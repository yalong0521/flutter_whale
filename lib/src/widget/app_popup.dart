import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

class AppPopup extends StatefulWidget {
  final ButtonViewBuilder buttonViewBuilder;
  final PopupViewBuilder popupViewBuilder;
  final PopupAnimator popupAnimator;
  final PopupBgShape? popupBgShape;
  final PopupAlignment popupAlignment;
  final double? offset;
  final bool popupVisible;
  final bool outsideDismissible;
  final List<PortalLabel<dynamic>> portalCandidateLabels;

  const AppPopup({
    required this.buttonViewBuilder,
    required this.popupViewBuilder,
    required this.popupAnimator,
    this.popupBgShape,
    this.popupAlignment = PopupAlignment.bottomCenter,
    this.offset,
    this.popupVisible = false,
    this.outsideDismissible = true,
    this.portalCandidateLabels = const [PortalLabel.main],
    super.key,
  });

  @override
  State<AppPopup> createState() => _AppPopupState();
}

class _AppPopupState extends State<AppPopup> {
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey _popupKey = GlobalKey();
  late bool _visible = widget.popupVisible;
  late PopupAlignment _popupAlignment = widget.popupAlignment;
  bool _firstVisible = false;
  Size? _popupSize;
  Rect? _buttonRect;

  double get _offset => widget.offset ?? 2.r;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // 获取弹窗尺寸
      _popupSize = _getWidgetRect(_popupKey)?.size;
      // 获取到之后就隐藏
      setState(() => _firstVisible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonAlignment = _getButtonAlignment();
    final popupView = widget.popupViewBuilder(_dismissPopup);
    final animPopupView = TweenAnimationBuilder<double>(
      curve: Curves.fastOutSlowIn,
      duration: kThemeAnimationDuration,
      tween: Tween(begin: 0, end: _visible ? 1 : 0),
      builder: (context, progress, child) {
        return widget.popupAnimator
            .build(_popupSize ?? Size.zero, _popupAlignment, buttonAlignment,
                progress, child!)
            .padding(_getOffset());
      },
      child: Builder(
        key: _popupKey,
        builder: (context) {
          final popupBgShape = widget.popupBgShape;
          final buttonRect = _buttonRect ?? Rect.zero;
          return popupBgShape != null
              ? popupBgShape.build(_popupAlignment, buttonRect, popupView)
              : popupView;
        },
      ),
    );
    final buttonView = Builder(
      key: _buttonKey,
      builder: (context) {
        return widget.buttonViewBuilder(_visible, () {
          final visible = !_visible;
          final popupSize = _popupSize;
          if (visible && popupSize != null) {
            final buttonRect = _getWidgetRect(_buttonKey);
            if (buttonRect != null) {
              _buttonRect = buttonRect;
              _popupAlignment = _reverseIfNotEnough(popupSize, buttonRect);
            }
          }
          setState(() => _visible = visible);
        });
      },
    );
    return PortalTarget(
      visible: _visible || !_firstVisible,
      portalCandidateLabels: widget.portalCandidateLabels,
      anchor: Aligned(
        follower: buttonAlignment,
        target: _getPopupAlignment(),
      ),
      closeDuration: kThemeAnimationDuration,
      portalFollower: widget.outsideDismissible
          ? TapRegion(
              groupId: this,
              onTapOutside: (event) => setState(() => _visible = false),
              child: animPopupView,
            )
          : animPopupView,
      child: widget.outsideDismissible
          ? TapRegion(groupId: this, child: buttonView)
          : buttonView,
    );
  }

  void _dismissPopup() => setState(() => _visible = false);

  Alignment _getButtonAlignment() {
    switch (_popupAlignment) {
      case PopupAlignment.bottomCenter:
        return Alignment.topCenter;
      case PopupAlignment.topCenter:
        return Alignment.bottomCenter;
      case PopupAlignment.leftCenter:
        return Alignment.centerRight;
      case PopupAlignment.rightCenter:
        return Alignment.centerLeft;
      case PopupAlignment.bottomStart:
      case PopupAlignment.rightTop:
        return Alignment.topLeft;
      case PopupAlignment.bottomEnd:
      case PopupAlignment.leftTop:
        return Alignment.topRight;
      case PopupAlignment.topStart:
      case PopupAlignment.rightBottom:
        return Alignment.bottomLeft;
      case PopupAlignment.topEnd:
      case PopupAlignment.leftBottom:
        return Alignment.bottomRight;
    }
  }

  Alignment _getPopupAlignment() {
    switch (_popupAlignment) {
      case PopupAlignment.bottomCenter:
        return Alignment.bottomCenter;
      case PopupAlignment.topCenter:
        return Alignment.topCenter;
      case PopupAlignment.leftCenter:
        return Alignment.centerLeft;
      case PopupAlignment.rightCenter:
        return Alignment.centerRight;
      case PopupAlignment.bottomStart:
      case PopupAlignment.leftBottom:
        return Alignment.bottomLeft;
      case PopupAlignment.bottomEnd:
      case PopupAlignment.rightBottom:
        return Alignment.bottomRight;
      case PopupAlignment.topStart:
      case PopupAlignment.leftTop:
        return Alignment.topLeft;
      case PopupAlignment.topEnd:
      case PopupAlignment.rightTop:
        return Alignment.topRight;
    }
  }

  /// 是否需要反转方向
  PopupAlignment _reverseIfNotEnough(Size popupSize, Rect buttonRect) {
    final bottomNeedReverse =
        screenHeight - buttonRect.bottom - _offset < popupSize.height;
    final topNeedReverse = buttonRect.top - _offset < popupSize.height;
    final startNeedReverse = buttonRect.left - _offset < popupSize.width;
    final endNeedReverse =
        screenWidth - buttonRect.right - _offset < popupSize.width;
    switch (widget.popupAlignment) {
      case PopupAlignment.bottomCenter:
        return bottomNeedReverse
            ? PopupAlignment.topCenter
            : PopupAlignment.bottomCenter;
      case PopupAlignment.bottomStart:
        if (screenWidth - buttonRect.left < popupSize.width) {
          return bottomNeedReverse
              ? PopupAlignment.topEnd
              : PopupAlignment.bottomEnd;
        } else {
          return bottomNeedReverse
              ? PopupAlignment.topStart
              : PopupAlignment.bottomStart;
        }
      case PopupAlignment.bottomEnd:
        if (buttonRect.right < popupSize.width) {
          return bottomNeedReverse
              ? PopupAlignment.topStart
              : PopupAlignment.bottomStart;
        } else {
          return bottomNeedReverse
              ? PopupAlignment.topEnd
              : PopupAlignment.bottomEnd;
        }
      case PopupAlignment.topCenter:
        return topNeedReverse
            ? PopupAlignment.bottomCenter
            : PopupAlignment.topCenter;
      case PopupAlignment.topStart:
        if (screenWidth - buttonRect.left < popupSize.width) {
          return topNeedReverse
              ? PopupAlignment.bottomEnd
              : PopupAlignment.topEnd;
        } else {
          return topNeedReverse
              ? PopupAlignment.bottomStart
              : PopupAlignment.topStart;
        }
      case PopupAlignment.topEnd:
        if (buttonRect.right < popupSize.width) {
          return topNeedReverse
              ? PopupAlignment.bottomStart
              : PopupAlignment.topStart;
        } else {
          return topNeedReverse
              ? PopupAlignment.bottomEnd
              : PopupAlignment.topEnd;
        }
      case PopupAlignment.leftCenter:
        return startNeedReverse
            ? PopupAlignment.rightCenter
            : PopupAlignment.leftCenter;
      case PopupAlignment.leftTop:
        if (screenHeight - buttonRect.top < popupSize.height) {
          return startNeedReverse
              ? PopupAlignment.rightBottom
              : PopupAlignment.leftBottom;
        } else {
          return startNeedReverse
              ? PopupAlignment.rightTop
              : PopupAlignment.leftTop;
        }
      case PopupAlignment.leftBottom:
        if (buttonRect.bottom < popupSize.height) {
          return startNeedReverse
              ? PopupAlignment.rightTop
              : PopupAlignment.leftTop;
        } else {
          return startNeedReverse
              ? PopupAlignment.rightBottom
              : PopupAlignment.leftBottom;
        }
      case PopupAlignment.rightCenter:
        return endNeedReverse
            ? PopupAlignment.leftCenter
            : PopupAlignment.rightCenter;
      case PopupAlignment.rightTop:
        if (screenHeight - buttonRect.top < popupSize.height) {
          return endNeedReverse
              ? PopupAlignment.leftBottom
              : PopupAlignment.rightBottom;
        } else {
          return endNeedReverse
              ? PopupAlignment.leftTop
              : PopupAlignment.rightTop;
        }
      case PopupAlignment.rightBottom:
        if (buttonRect.bottom < popupSize.height) {
          return endNeedReverse
              ? PopupAlignment.leftTop
              : PopupAlignment.rightTop;
        } else {
          return endNeedReverse
              ? PopupAlignment.leftBottom
              : PopupAlignment.rightBottom;
        }
    }
  }

  Rect? _getWidgetRect(GlobalKey key) {
    final renderObj = key.currentContext?.findRenderObject();
    if (renderObj is! RenderBox) return null;
    Offset position = renderObj.localToGlobal(Offset.zero);
    return position & renderObj.size;
  }

  EdgeInsetsGeometry _getOffset() {
    switch (_popupAlignment) {
      case PopupAlignment.bottomCenter:
      case PopupAlignment.bottomStart:
      case PopupAlignment.bottomEnd:
        return EdgeInsets.only(top: _offset);
      case PopupAlignment.topCenter:
      case PopupAlignment.topStart:
      case PopupAlignment.topEnd:
        return EdgeInsets.only(bottom: _offset);
      case PopupAlignment.leftCenter:
      case PopupAlignment.leftTop:
      case PopupAlignment.leftBottom:
        return EdgeInsets.only(right: _offset);
      case PopupAlignment.rightCenter:
      case PopupAlignment.rightTop:
      case PopupAlignment.rightBottom:
        return EdgeInsets.only(left: _offset);
    }
  }

  @override
  void didUpdateWidget(covariant AppPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.popupVisible != widget.popupVisible) {
      setState(() => _visible = widget.popupVisible);
    }
  }
}

typedef ButtonViewBuilder = Widget Function(
    bool popupVisible, VoidCallback onButtonTap);
typedef PopupViewBuilder = Widget Function(VoidCallback dismissPopup);

abstract class PopupBgShape {
  Widget build(PopupAlignment alignment, Rect buttonRect, Widget child);
}

class TwinkleBgShape extends PopupBgShape {
  final double triangleSize;
  final Color bgColor;
  final double radius;

  TwinkleBgShape(
      {double? triangleSize, this.bgColor = Colors.white, double? radius})
      : triangleSize = triangleSize ?? 8.r,
        radius = radius ?? 4.r;

  @override
  Widget build(PopupAlignment alignment, Rect buttonRect, Widget child) {
    return CustomPaint(
      painter: _TwinkleBgPainter(
          bgColor, triangleSize, alignment, buttonRect, radius),
      child: Padding(padding: _getPadding(alignment), child: child),
    );
  }

  EdgeInsetsGeometry _getPadding(PopupAlignment alignment) {
    switch (alignment) {
      case PopupAlignment.bottomCenter:
      case PopupAlignment.bottomStart:
      case PopupAlignment.bottomEnd:
        return EdgeInsets.only(top: triangleSize);
      case PopupAlignment.topCenter:
      case PopupAlignment.topStart:
      case PopupAlignment.topEnd:
        return EdgeInsets.only(bottom: triangleSize);
      case PopupAlignment.leftCenter:
      case PopupAlignment.leftTop:
      case PopupAlignment.leftBottom:
        return EdgeInsetsDirectional.only(end: triangleSize);
      case PopupAlignment.rightCenter:
      case PopupAlignment.rightTop:
      case PopupAlignment.rightBottom:
        return EdgeInsetsDirectional.only(start: triangleSize);
    }
  }
}

abstract class PopupAnimator {
  Widget build(Size popupSize, PopupAlignment popupAlignment,
      AlignmentGeometry buttonAlignment, double animProgress, Widget child);
}

class OpacityScaleAnimator extends PopupAnimator {
  @override
  Widget build(Size popupSize, PopupAlignment popupAlignment,
      AlignmentGeometry buttonAlignment, double animProgress, Widget child) {
    final opacity = Opacity(opacity: animProgress, child: child);
    return _scale(animProgress, popupAlignment, buttonAlignment, opacity);
  }

  Widget _scale(double progress, PopupAlignment popupAlignment,
      AlignmentGeometry followerAlignment, Widget child) {
    switch (popupAlignment) {
      case PopupAlignment.bottomCenter:
      case PopupAlignment.bottomStart:
      case PopupAlignment.bottomEnd:
      case PopupAlignment.topCenter:
      case PopupAlignment.topStart:
      case PopupAlignment.topEnd:
        return Transform.scale(
            scaleY: progress, alignment: followerAlignment, child: child);
      case PopupAlignment.leftCenter:
      case PopupAlignment.leftTop:
      case PopupAlignment.leftBottom:
      case PopupAlignment.rightCenter:
      case PopupAlignment.rightTop:
      case PopupAlignment.rightBottom:
        return Transform.scale(
            scaleX: progress, alignment: followerAlignment, child: child);
    }
  }
}

class OpacityTranslateAnimator extends PopupAnimator {
  @override
  Widget build(Size popupSize, PopupAlignment popupAlignment,
      AlignmentGeometry buttonAlignment, double animProgress, Widget child) {
    final opacity = Opacity(opacity: animProgress, child: child);
    final translate =
        _translate(popupSize, animProgress, popupAlignment, opacity);
    return ClipRect(child: translate);
  }

  Widget _translate(Size popupSize, double progress,
      PopupAlignment popupAlignment, Widget child) {
    switch (popupAlignment) {
      case PopupAlignment.bottomCenter:
      case PopupAlignment.bottomStart:
      case PopupAlignment.bottomEnd:
        return Transform.translate(
          offset: Offset(0, -popupSize.height * (1 - progress)),
          child: Opacity(opacity: progress, child: child),
        );
      case PopupAlignment.topCenter:
      case PopupAlignment.topStart:
      case PopupAlignment.topEnd:
        return Transform.translate(
          offset: Offset(0, popupSize.height * (1 - progress)),
          child: Opacity(opacity: progress, child: child),
        );
      case PopupAlignment.leftCenter:
      case PopupAlignment.leftTop:
      case PopupAlignment.leftBottom:
        return Transform.translate(
          offset: Offset(popupSize.width * (1 - progress), 0),
          child: Opacity(opacity: progress, child: child),
        );
      case PopupAlignment.rightCenter:
      case PopupAlignment.rightTop:
      case PopupAlignment.rightBottom:
        return Transform.translate(
          offset: Offset(-popupSize.width * (1 - progress), 0),
          child: Opacity(opacity: progress, child: child),
        );
    }
  }
}

class _TwinkleBgPainter extends CustomPainter {
  final Color color;
  final double diameter;
  final double triangle;
  final PopupAlignment alignment;
  final Rect buttonRect;

  late final Paint _paint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  _TwinkleBgPainter(this.color, this.triangle, this.alignment, this.buttonRect,
      double? radius)
      : diameter = (radius ?? 4.r) * 2;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    switch (alignment) {
      case PopupAlignment.topCenter:
      case PopupAlignment.topStart:
      case PopupAlignment.topEnd:
        _drawArrowDown(path, size);
        break;
      case PopupAlignment.bottomCenter:
      case PopupAlignment.bottomStart:
      case PopupAlignment.bottomEnd:
        _drawArrowUp(path, size);
        break;
      case PopupAlignment.leftCenter:
      case PopupAlignment.leftTop:
      case PopupAlignment.leftBottom:
        _drawArrowRight(path, size);
        break;
      case PopupAlignment.rightCenter:
      case PopupAlignment.rightTop:
      case PopupAlignment.rightBottom:
        _drawArrowLeft(path, size);
        break;
    }

    canvas.drawShadow(path, Colors.black.withOpacity(0.6), 6.r, true);
    canvas.drawPath(path, _paint);
  }

  void _drawArrowDown(Path path, Size size) {
    final width = size.width;
    final height = size.height;
    final arrowX = switch (alignment) {
      PopupAlignment.topCenter => width / 2,
      PopupAlignment.topStart => buttonRect.width / 2,
      PopupAlignment.topEnd => width - buttonRect.width / 2,
      _ => width / 2,
    };

    final leftTopCircle = Rect.fromLTWH(0, 0, diameter, diameter);
    final rightTopCircle =
        Rect.fromLTWH(width - diameter, 0, diameter, diameter);
    final leftBottomCircle =
        Rect.fromLTWH(0, height - diameter - triangle, diameter, diameter);
    final rightBottomCircle = Rect.fromLTWH(
        width - diameter, height - diameter - triangle, diameter, diameter);

    path
      ..moveTo(diameter / 2, 0)
      ..arcTo(leftTopCircle, -pi / 2, -pi / 2, false)
      ..lineTo(0, height - triangle - diameter / 2)
      ..arcTo(leftBottomCircle, pi, -pi / 2, false)
      ..lineTo(arrowX - triangle * tan(pi / 4), height - triangle)
      ..lineTo(arrowX, height)
      ..lineTo(arrowX + triangle * tan(pi / 4), height - triangle)
      ..lineTo(width - diameter / 2, height - triangle)
      ..arcTo(rightBottomCircle, pi / 2, -pi / 2, false)
      ..lineTo(width, diameter / 2)
      ..arcTo(rightTopCircle, 0, -pi / 2, false)
      ..close();
  }

  void _drawArrowUp(Path path, Size size) {
    final width = size.width;
    final height = size.height;
    final arrowX = switch (alignment) {
      PopupAlignment.bottomCenter => width / 2,
      PopupAlignment.bottomStart => buttonRect.width / 2,
      PopupAlignment.bottomEnd => width - buttonRect.width / 2,
      _ => width / 2,
    };

    final leftTopCircle = Rect.fromLTWH(0, triangle, diameter, diameter);
    final rightTopCircle =
        Rect.fromLTWH(width - diameter, triangle, diameter, diameter);
    final leftBottomCircle =
        Rect.fromLTWH(0, height - diameter, diameter, diameter);
    final rightBottomCircle =
        Rect.fromLTWH(width - diameter, height - diameter, diameter, diameter);

    path
      ..moveTo(arrowX, 0)
      ..lineTo(arrowX - triangle * tan(pi / 4), triangle)
      ..lineTo(diameter / 2, triangle)
      ..arcTo(leftTopCircle, -pi / 2, -pi / 2, false)
      ..lineTo(0, height - diameter / 2)
      ..arcTo(leftBottomCircle, pi, -pi / 2, false)
      ..lineTo(width - diameter / 2, height)
      ..arcTo(rightBottomCircle, pi / 2, -pi / 2, false)
      ..lineTo(width, triangle + diameter / 2)
      ..arcTo(rightTopCircle, 0, -pi / 2, false)
      ..lineTo(arrowX + triangle * tan(pi / 4), triangle)
      ..close();
  }

  void _drawArrowRight(Path path, Size size) {
    final width = size.width;
    final height = size.height;
    final arrowY = switch (alignment) {
      PopupAlignment.leftCenter => height / 2,
      PopupAlignment.leftTop => buttonRect.height / 2,
      PopupAlignment.leftBottom => height - buttonRect.height / 2,
      _ => height / 2,
    };

    final topLeftCircle = Rect.fromLTWH(0, 0, diameter, diameter);
    final bottomLeftCircle =
        Rect.fromLTWH(0, height - diameter, diameter, diameter);
    final topRightCircle =
        Rect.fromLTWH(width - triangle - diameter, 0, diameter, diameter);
    final bottomRightCircle = Rect.fromLTWH(
        width - triangle - diameter, height - diameter, diameter, diameter);

    path
      ..moveTo(width, arrowY)
      ..lineTo(width - triangle, arrowY - triangle * tan(pi / 4))
      ..lineTo(width - triangle, diameter / 2)
      ..arcTo(topRightCircle, 0, -pi / 2, false)
      ..lineTo(diameter / 2, 0)
      ..arcTo(topLeftCircle, -pi / 2, -pi / 2, false)
      ..lineTo(0, height - diameter / 2)
      ..arcTo(bottomLeftCircle, pi, -pi / 2, false)
      ..lineTo(width - triangle - diameter / 2, height)
      ..arcTo(bottomRightCircle, pi / 2, -pi / 2, false)
      ..lineTo(width - triangle, arrowY + triangle * tan(pi / 4))
      ..close();
  }

  void _drawArrowLeft(Path path, Size size) {
    final width = size.width;
    final height = size.height;
    final arrowY = switch (alignment) {
      PopupAlignment.rightCenter => height / 2,
      PopupAlignment.rightTop => buttonRect.height / 2,
      PopupAlignment.rightBottom => height - buttonRect.height / 2,
      _ => height / 2,
    };

    final topLeftCircle = Rect.fromLTWH(triangle, 0, diameter, diameter);
    final bottomLeftCircle =
        Rect.fromLTWH(triangle, height - diameter, diameter, diameter);
    final topRightCircle =
        Rect.fromLTWH(width - diameter, 0, diameter, diameter);
    final bottomRightCircle =
        Rect.fromLTWH(width - diameter, height - diameter, diameter, diameter);

    path
      ..moveTo(0, arrowY)
      ..lineTo(triangle, arrowY - triangle * tan(pi / 4))
      ..lineTo(triangle, diameter / 2)
      ..arcTo(topLeftCircle, pi, pi / 2, false)
      ..lineTo(width - diameter / 2, 0)
      ..arcTo(topRightCircle, -pi / 2, pi / 2, false)
      ..lineTo(width, height - diameter / 2)
      ..arcTo(bottomRightCircle, 0, pi / 2, false)
      ..lineTo(triangle + diameter / 2, height)
      ..arcTo(bottomLeftCircle, pi / 2, pi / 2, false)
      ..lineTo(triangle, arrowY + triangle * tan(pi / 4))
      ..close();
  }

  @override
  bool shouldRepaint(covariant _TwinkleBgPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.diameter != diameter ||
      oldDelegate.triangle != triangle ||
      oldDelegate.alignment != alignment;
}

enum PopupAlignment {
  bottomCenter,
  bottomStart,
  bottomEnd,
  topCenter,
  topStart,
  topEnd,
  leftCenter,
  leftTop,
  leftBottom,
  rightCenter,
  rightTop,
  rightBottom;
}
