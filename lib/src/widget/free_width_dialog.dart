import 'package:flutter/material.dart';

const EdgeInsets _defaultInsetPadding =
    EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);

class FreeWidthDialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const FreeWidthDialog({
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.insetPadding = _defaultInsetPadding,
    this.clipBehavior = Clip.none,
    this.shape,
    this.alignment,
    this.child,
  })  : assert(elevation == null || elevation >= 0.0),
        _fullscreen = false;

  /// Creates a fullscreen dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const FreeWidthDialog.fullscreen({
    super.key,
    this.backgroundColor,
    this.insetAnimationDuration = Duration.zero,
    this.insetAnimationCurve = Curves.decelerate,
    this.child,
  })  : elevation = 0,
        shadowColor = null,
        surfaceTintColor = null,
        insetPadding = EdgeInsets.zero,
        clipBehavior = Clip.none,
        shape = null,
        alignment = null,
        _fullscreen = true;

  /// {@template flutter.material.dialog.backgroundColor}
  /// The background color of the surface of this [Dialog].
  ///
  /// This sets the [Material.color] on this [Dialog]'s [Material].
  ///
  /// If `null`, [ThemeData.dialogBackgroundColor] is used.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template flutter.material.dialog.elevation}
  /// The z-coordinate of this [Dialog].
  ///
  /// Controls how far above the parent the dialog will appear. Elevation is
  /// represented by a drop shadow if [shadowColor] is non null,
  /// and a surface tint overlay on the background color if [surfaceTintColor] is
  /// non null.
  ///
  /// If null then [DialogTheme.elevation] is used, and if that is null then
  /// the elevation will match the Material Design specification for Dialogs.
  ///
  /// See also:
  ///   * [Material.elevation], which describes how [elevation] effects the
  ///     drop shadow or surface tint overlay.
  ///   * [shadowColor], color of the drop shadow used to indicate the elevation.
  ///   * [surfaceTintColor], color of an overlay on top of the background
  ///     color used to indicate the elevation.
  ///   * <https://m3.material.io/components/dialogs/overview>, the Material
  ///     Design specification for dialogs.
  /// {@endtemplate}
  final double? elevation;

  /// {@template flutter.material.dialog.shadowColor}
  /// The color used to paint a drop shadow under the dialog's [Material],
  /// which reflects the dialog's [elevation].
  ///
  /// If null and [ThemeData.useMaterial3] is true then no drop shadow will
  /// be rendered.
  ///
  /// If null and [ThemeData.useMaterial3] is false then it will default to
  /// [ThemeData.shadowColor].
  ///
  /// See also:
  ///   * [Material.shadowColor], which describes how the drop shadow is painted.
  ///   * [elevation], which affects how the drop shadow is painted.
  ///   * [surfaceTintColor], which can be used to indicate elevation through
  ///     tinting the background color.
  /// {@endtemplate}
  final Color? shadowColor;

  /// {@template flutter.material.dialog.surfaceTintColor}
  /// The color used as a surface tint overlay on the dialog's background color,
  /// which reflects the dialog's [elevation].
  ///
  /// If [ThemeData.useMaterial3] is false property has no effect.
  ///
  /// If null and [ThemeData.useMaterial3] is true then [ThemeData]'s
  /// [ColorScheme.surfaceTint] will be used.
  ///
  /// To disable this feature, set [surfaceTintColor] to [Colors.transparent].
  ///
  /// See also:
  ///   * [Material.surfaceTintColor], which describes how the surface tint will
  ///     be applied to the background color of the dialog.
  ///   * [elevation], which affects the opacity of the surface tint.
  ///   * [shadowColor], which can be used to indicate elevation through
  ///     a drop shadow.
  /// {@endtemplate}
  final Color? surfaceTintColor;

  /// {@template flutter.material.dialog.insetAnimationDuration}
  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to 100 milliseconds when [Dialog] is used, and [Duration.zero]
  /// when [Dialog.fullscreen] is used.
  /// {@endtemplate}
  final Duration insetAnimationDuration;

  /// {@template flutter.material.dialog.insetAnimationCurve}
  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Defaults to [Curves.decelerate].
  /// {@endtemplate}
  final Curve insetAnimationCurve;

  /// {@template flutter.material.dialog.insetPadding}
  /// The amount of padding added to [MediaQueryData.viewInsets] on the outside
  /// of the dialog. This defines the minimum space between the screen's edges
  /// and the dialog.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0)`.
  /// {@endtemplate}
  final EdgeInsets? insetPadding;

  /// {@template flutter.material.dialog.clipBehavior}
  /// Controls how the contents of the dialog are clipped (or not) to the given
  /// [shape].
  ///
  /// See the enum [Clip] for details of all possible options and their common
  /// use cases.
  ///
  /// Defaults to [Clip.none].
  /// {@endtemplate}
  final Clip clipBehavior;

  /// {@template flutter.material.dialog.shape}
  /// The shape of this dialog's border.
  ///
  /// Defines the dialog's [Material.shape].
  ///
  /// The default shape is a [RoundedRectangleBorder] with a radius of 4.0
  /// {@endtemplate}
  final ShapeBorder? shape;

  /// {@template flutter.material.dialog.alignment}
  /// How to align the [Dialog].
  ///
  /// If null, then [DialogTheme.alignment] is used. If that is also null, the
  /// default is [Alignment.center].
  /// {@endtemplate}
  final AlignmentGeometry? alignment;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// This value is used to determine if this is a fullscreen dialog.
  final bool _fullscreen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dialogTheme = DialogTheme.of(context);
    final EdgeInsets effectivePadding =
        MediaQuery.viewInsetsOf(context) + (insetPadding ?? EdgeInsets.zero);
    final DialogTheme defaults = theme.useMaterial3
        ? (_fullscreen
            ? _DialogFullscreenDefaultsM3(context)
            : _DialogDefaultsM3(context))
        : _DialogDefaultsM2(context);

    Widget dialogChild;

    if (_fullscreen) {
      dialogChild = Material(
        color: backgroundColor ??
            dialogTheme.backgroundColor ??
            defaults.backgroundColor,
        child: child,
      );
    } else {
      dialogChild = Align(
        alignment: alignment ?? dialogTheme.alignment ?? defaults.alignment!,
        child: Material(
          color: backgroundColor ??
              dialogTheme.backgroundColor ??
              Theme.of(context).dialogBackgroundColor,
          elevation: elevation ?? dialogTheme.elevation ?? defaults.elevation!,
          shadowColor:
              shadowColor ?? dialogTheme.shadowColor ?? defaults.shadowColor,
          surfaceTintColor: surfaceTintColor ??
              dialogTheme.surfaceTintColor ??
              defaults.surfaceTintColor,
          shape: shape ?? dialogTheme.shape ?? defaults.shape!,
          type: MaterialType.card,
          clipBehavior: clipBehavior,
          child: child,
        ),
      );
    }

    return AnimatedPadding(
      padding: effectivePadding,
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: dialogChild,
      ),
    );
  }
}

// END GENERATED TOKEN PROPERTIES - Dialog

// BEGIN GENERATED TOKEN PROPERTIES - DialogFullscreen

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

class _DialogFullscreenDefaultsM3 extends DialogTheme {
  const _DialogFullscreenDefaultsM3(this.context);

  final BuildContext context;

  @override
  Color? get backgroundColor => Theme.of(context).colorScheme.surface;
}

// BEGIN GENERATED TOKEN PROPERTIES - Dialog

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

class _DialogDefaultsM3 extends DialogTheme {
  _DialogDefaultsM3(this.context)
      : super(
          alignment: Alignment.center,
          elevation: 6.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(28.0))),
        );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get iconColor => _colors.secondary;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  @override
  TextStyle? get titleTextStyle => _textTheme.headlineSmall;

  @override
  TextStyle? get contentTextStyle => _textTheme.bodyMedium;

  @override
  EdgeInsetsGeometry? get actionsPadding =>
      const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0);
}

// Hand coded defaults based on Material Design 2.
class _DialogDefaultsM2 extends DialogTheme {
  _DialogDefaultsM2(this.context)
      : _textTheme = Theme.of(context).textTheme,
        _iconTheme = Theme.of(context).iconTheme,
        super(
          alignment: Alignment.center,
          elevation: 24.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
        );

  final BuildContext context;
  final TextTheme _textTheme;
  final IconThemeData _iconTheme;

  @override
  Color? get iconColor => _iconTheme.color;

  @override
  Color? get backgroundColor => Theme.of(context).dialogBackgroundColor;

  @override
  Color? get shadowColor => Theme.of(context).shadowColor;

  @override
  TextStyle? get titleTextStyle => _textTheme.titleLarge;

  @override
  TextStyle? get contentTextStyle => _textTheme.titleMedium;

  @override
  EdgeInsetsGeometry? get actionsPadding => EdgeInsets.zero;
}
