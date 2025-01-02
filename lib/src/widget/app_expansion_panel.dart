import 'package:flutter/material.dart';
import 'package:flutter_whale/flutter_whale.dart';

typedef ExpansionPanelHeaderBuilder = Widget Function(bool isExpanded);

class AppExpansionPanel extends StatefulWidget {
  const AppExpansionPanel({
    super.key,
    required this.headerBuilder,
    this.expansionCallback,
    this.body,
    this.isExpanded = false,
    this.animationDuration = kThemeAnimationDuration,
  });

  final ExpansionPanelHeaderBuilder headerBuilder;

  final ValueChanged<bool>? expansionCallback;

  final Widget? body;

  final bool isExpanded;

  final Duration animationDuration;

  @override
  State<StatefulWidget> createState() => _ExpansionPanelState();
}

class _ExpansionPanelState extends State<AppExpansionPanel> {
  @override
  Widget build(BuildContext context) {
    Widget headerWidget = widget.headerBuilder(widget.isExpanded);
    var body = widget.body;
    if (body == null) return headerWidget;
    var expansionCallback = widget.expansionCallback;
    if (expansionCallback != null) {
      headerWidget = TapWrapper(
        onTap: () => widget.expansionCallback?.call(!widget.isExpanded),
        child: headerWidget,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        headerWidget,
        Flexible(
          child: AnimatedCrossFade(
            firstChild: Container(height: 0),
            secondChild: body,
            firstCurve: const Interval(0, 0),
            secondCurve: const Interval(0, 0),
            sizeCurve: Curves.fastOutSlowIn,
            crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: widget.animationDuration,
          ),
        ),
      ],
    );
  }
}
