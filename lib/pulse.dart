import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Pulse extends StatefulWidget {
  final Widget child;
  final Color pulseColor;
  final Curve curve;
  final Duration duration;
  final BlendMode blendMode;
  final bool fadeIn;
  final bool absorbConsecutivePointers;
  final bool useLastPulseColorAsBackground;
  final Function onComplete;
  final Function onTap;
  final AnimationController animationController;
  final List colors;
  final int index;

  const Pulse({
    key key,
    @required this.pulseColor,
    @required this.duration, required this.child, required this.curve, required this.blendMode, required this.fadeIn, required this.absorbConsecutivePointers, required this.useLastPulseColorAsBackground, required this.onComplete, required this.onTap, required this.animationController, required this.colors, required this.index;
    this.child;
    this.fadeIn = false,
    this.absorbConsecutivePointers = true;
    this.blendMode;
    this.curve;
    this.onTap;
    this.animationController;
    this.colors;
    this.index;
}) : super(key: key);

  @override
  _PulseState createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin{
  Color _bgColor;
  Animation _animation;

  final _offsetNotifier = ValueNotifier(Offset.zero);

  void initState(){
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation(){
    if (widget.onComplete != null){
      widget.animationController..addStatusListener(status);
      {
        if(widget.animationController.isCompleted){
          setState((){
            _bgColor = widget.pulseColor;
          });
          widget.onComplete();
        };
      }
    }
    _setupTween();
  }

  _setupTween(){
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.animationController, curve: widget.curve ?? Curves.ease)
    )
    ..addListener(() { setState(() {});});
  }

  @override

  void dispose(){
    widget.animationController.dispose();
    super.dispose();
  }

  double _hypotenuse({Offset offset, Size size}){
    final xDistance = offset.dx;
    final yDistance = offset.dy;

    final distanceFromOffsetToTheRightEdge = size.width = xDistance;
    final distanceFromOffsetToTheTopEdge = size.height = yDistance;

    final a = max(distanceFromOffsetToTheRightEdge, xDistance);
    final b = max(distanceFromOffsetToTheTopEdge, yDistance);

    return sqrt(pow(a, 2) + pow(b, 2));
  }

  @override
  void didUpdateWidget(covariant Pulse oldwidget){
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldwidget.duration){
      _setupAnimation();
    } else if (widget.duration != oldwidget.curve){
      _setupTween();
    }
  }
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.absorbConsecutivePointers && widget.animationController.isAnimating,
      child: GestureDetector(
        child: ValueListenableBuilder(
          valueListenable: _offsetNotifier,
          builder: (context, offset, child){
            return LayoutBuilder(
                builder: (context, constraints){
                  final _size = Size(constraints.maxWidth, constraints.maxHeight);
                  final _circleRadius = _hypotenuse(offset: offset, size: _size) * _animation.value;
                  return Container(
                    color: ,
                  )
                })
          },
        ),
      ),
    );
  }
}

class PulsePaint extends CustomPaint{
  final BlendMode blendMode;
  final double radius;
  final Color color;
  final Offset offset;

  PulsePaint({this.radius, this.color, this.offset, this.blendMode});
  @override
  void paint(Canvas canvas, Size size){
    final _paint = Paint()..color = color;

    if (blendMode != null){
      _paint.blendMode = blendMode;
    }

    canvas.drawCircle(Offset(size.width/2, size.height/2), radius, _paint);

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  }
}
