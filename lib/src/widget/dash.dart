import 'package:flutter/widgets.dart';

class HDash extends _Dash {
  const HDash({
    required Color color,
    required double dashSize,
    required double spaceSize,
    required double height,
    double? length,
    super.key,
  }) : super(color, dashSize, spaceSize, length: length, height: height);
}

class VDash extends _Dash {
  const VDash({
    required Color color,
    required double dashSize,
    required double spaceSize,
    required double width,
    double? length,
    super.key,
  }) : super(color, dashSize, spaceSize, length: length, width: width);
}

class _Dash extends StatelessWidget {
  final Color color;
  final double dashSize;
  final double spaceSize;
  final double? length;
  final double? height;
  final double? width;

  const _Dash(
    this.color,
    this.dashSize,
    this.spaceSize, {
    this.length,
    this.height,
    this.width,
    Key? key,
  })  : assert(height != null || width != null,
            'Height or width must be not null'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Axis direction = height == null ? Axis.vertical : Axis.horizontal;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final checkedLength = length ??
            (direction == Axis.horizontal
                ? constraints.constrainWidth()
                : constraints.constrainHeight());
        final dashCount = (checkedLength / (dashSize + spaceSize)).floor();
        return Flex(
          direction: direction,
          children: List.generate(dashCount, (_) {
            return Container(
              width: width ?? dashSize,
              height: height ?? dashSize,
              margin: EdgeInsets.only(
                bottom: height == null ? spaceSize : 0,
                right: width == null ? spaceSize : 0,
              ),
              color: color,
            );
          }),
        );
      },
    );
  }
}
