import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

class AppTapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? color;
  final bool? circleShape;
  final BorderRadiusGeometry borderRadius;
  final BorderSide? borderSide;
  final AlignmentGeometry? alignment;
  final bool enable;
  final Size? size;
  final Size? minimumSize;
  final Size? maximumSize;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? shadowColor;
  final double elevation;

  AppTapper({
    super.key,
    required Widget child,
    required VoidCallback onTap,
    this.color,
    this.size,
    this.minimumSize,
    this.maximumSize,
    this.borderRadius = BorderRadius.zero,
    this.circleShape,
    this.borderSide,
    this.alignment,
    this.enable = true,
    this.padding,
    this.textStyle,
    this.shadowColor,
    this.elevation = 0,
  })  : child = enable ? child : Opacity(opacity: 0.6, child: child),
        onTap = onTap.throttle();

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? Colors.transparent;
    final disableLerp = bgColor.isDark ? Colors.white : Colors.black;
    final disableOpacity = bgColor.isDark ? 0.5 : 0.02;
    final button = ElevatedButton(
      onPressed: enable ? onTap : null,
      style: ElevatedButton.styleFrom(
        fixedSize: size,
        side: borderSide,
        elevation: elevation,
        alignment: alignment,
        textStyle: textStyle,
        padding: EdgeInsets.zero,
        maximumSize: maximumSize,
        minimumSize: minimumSize ?? Size.zero,
        visualDensity: VisualDensity.standard,
        splashFactory: InkSparkle.splashFactory,
        shadowColor: shadowColor ?? Colors.transparent,
        enabledMouseCursor: SystemMouseCursors.click,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        disabledMouseCursor: SystemMouseCursors.forbidden,
        shape: circleShape == true
            ? const CircleBorder()
            : RoundedRectangleBorder(borderRadius: borderRadius),
        backgroundColor: bgColor,
        disabledBackgroundColor: bgColor == Colors.transparent
            ? bgColor
            : Color.lerp(bgColor, disableLerp, disableOpacity),
      ).copyWith(
        overlayColor: _OverlayColorProperty(contrastColor(bgColor)),
      ),
      child: padding != null ? child.padding(padding!) : child,
    );
    return enable || bgColor != Colors.transparent
        ? button
        : Opacity(opacity: 0.5, child: button);
  }

  Color contrastColor(Color color) {
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

class _OverlayColorProperty extends MaterialStateProperty<Color> {
  final Color color;

  _OverlayColorProperty(this.color);

  @override
  Color resolve(Set<MaterialState> states) {
    return color.withOpacity(0.05);
  }
}

class AppMouseTapper extends StatefulWidget {
  final VoidCallback onTap;
  final Color? color;
  final bool? circleShape;
  final BorderRadiusGeometry borderRadius;
  final BorderSide? borderSide;
  final AlignmentGeometry? alignment;
  final bool enable;
  final Size? size;
  final Size? minimumSize;
  final Size? maximumSize;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? shadowColor;
  final Widget child;
  final Widget mouseChild;

  const AppMouseTapper({
    super.key,
    required this.onTap,
    this.color,
    this.circleShape,
    required this.borderRadius,
    this.borderSide,
    this.alignment,
    required this.enable,
    this.size,
    this.minimumSize,
    this.maximumSize,
    this.padding,
    this.textStyle,
    this.shadowColor,
    required this.child,
    required this.mouseChild,
  });

  @override
  State<AppMouseTapper> createState() => _AppMouseTapperState();
}

class _AppMouseTapperState extends State<AppMouseTapper> {
  bool _mouseEnter = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _mouseEnter = true),
      onExit: (event) => setState(() => _mouseEnter = false),
      child: AppTapper(
        onTap: widget.onTap,
        color: widget.color,
        circleShape: widget.circleShape,
        borderRadius: widget.borderRadius,
        borderSide: widget.borderSide,
        alignment: widget.alignment,
        enable: widget.enable,
        size: widget.size,
        minimumSize: widget.minimumSize,
        maximumSize: widget.maximumSize,
        padding: widget.padding,
        textStyle: widget.textStyle,
        shadowColor: widget.shadowColor,
        child: _mouseEnter ? widget.mouseChild : widget.child,
      ),
    );
  }
}
