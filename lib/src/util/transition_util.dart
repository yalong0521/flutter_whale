import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TransitionUtil {
  TransitionUtil._();

  static Widget pageTransition(
    TransitionType type,
    Curve curve,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    PageRoute pageRoute,
  ) {
    switch (type) {
      case TransitionType.theme:
        var themeBuilder = Theme.of(context)
                .pageTransitionsTheme
                .builders[defaultTargetPlatform] ??
            const CupertinoPageTransitionsBuilder();
        return themeBuilder.buildTransitions(
          pageRoute,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      case TransitionType.fade:
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      case TransitionType.rightToLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      case TransitionType.leftToRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      case TransitionType.topToBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      case TransitionType.bottomToTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      case TransitionType.scale:
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      case TransitionType.scaleVertical:
        return Align(
          child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );
      case TransitionType.scaleHorizontal:
        return Align(
          child: SizeTransition(
            axis: Axis.horizontal,
            sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );
      case TransitionType.rotate:
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
        return RotationTransition(
          turns: curvedAnimation,
          child: ScaleTransition(
            scale: curvedAnimation,
            child: FadeTransition(opacity: curvedAnimation, child: child),
          ),
        );
    }
  }

  static Widget dialogTransition(
    TransitionType type,
    Curve curve,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (type) {
      case TransitionType.theme:
        return _dialogTheme(animation, secondaryAnimation, child);
      case TransitionType.fade:
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      case TransitionType.rightToLeft:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      case TransitionType.leftToRight:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      case TransitionType.topToBottom:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      case TransitionType.bottomToTop:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      case TransitionType.scale:
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      case TransitionType.scaleVertical:
        return Align(
          child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );
      case TransitionType.scaleHorizontal:
        return Align(
          child: SizeTransition(
            axis: Axis.horizontal,
            sizeFactor: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );
      case TransitionType.rotate:
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
        return RotationTransition(
          turns: curvedAnimation,
          child: ScaleTransition(
            scale: curvedAnimation,
            child: FadeTransition(opacity: curvedAnimation, child: child),
          ),
        );
    }
  }

  static Widget _dialogTheme(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (Platform.isIOS) {
      final CurvedAnimation fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.ease,
      );
      if (animation.status == AnimationStatus.reverse) {
        return FadeTransition(opacity: fadeAnimation, child: child);
      }
      return FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: animation.drive(Tween<double>(begin: 1.3, end: 1.0)),
          child: child,
        ),
      );
    } else {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
        child: child,
      );
    }
  }
}

enum TransitionType {
  /// theme
  theme,

  /// Fade Animation
  fade,

  /// Right to left animation
  rightToLeft,

  /// Left to right animation
  leftToRight,

  /// Top to bottom animation
  topToBottom,

  /// Bottom to top animation
  bottomToTop,

  /// Scale animation
  scale,

  /// ScaleVertical animation
  scaleVertical,

  /// ScaleHorizontal animation
  scaleHorizontal,

  /// Rotate animation
  rotate,
}
