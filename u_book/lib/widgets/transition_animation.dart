import 'package:flutter/material.dart';

enum TransitionAnimationType {
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft
}

class TransitionAnimation extends StatefulWidget {
  const TransitionAnimation(
      {Key? key,
      required this.child,
      this.duration = const Duration(milliseconds: 300),
      this.type = TransitionAnimationType.topToBottom,
      this.curve = Curves.fastOutSlowIn,
      required this.runAnimation})
      : super(key: key);
  final Widget child;
  final Duration duration;
  final Curve curve;
  final TransitionAnimationType type;
  final bool runAnimation;

  @override
  State<TransitionAnimation> createState() => _TransitionAnimationState();
}

class _TransitionAnimationState extends State<TransitionAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _setupAnimation();
    super.initState();
  }

  void _setupAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<Offset>(begin: _getOffset(), end: Offset.zero).animate(
        CurvedAnimation(parent: _animationController, curve: widget.curve));
    if (widget.runAnimation) {
      _animationController.forward();
    }
  }

  Offset _getOffset() {
    switch (widget.type) {
      case TransitionAnimationType.leftToRight:
        return const Offset(-1, 0);
      case TransitionAnimationType.rightToLeft:
        return const Offset(1, 0);
      case TransitionAnimationType.topToBottom:
        return const Offset(0, -1);
      case TransitionAnimationType.bottomToTop:
        return const Offset(0, 1);
      default:
        break;
    }
    return Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => SlideTransition(
              position: _animation,
              child: widget.child,
            ));
  }

  @override
  void didUpdateWidget(covariant TransitionAnimation old) {
    if (widget.child != old.child ||
        widget.duration != old.duration ||
        widget.curve != old.curve ||
        widget.type != old.type ||
        widget.runAnimation != old.runAnimation) {
      if (widget.type != old.type) {
        _setupAnimation();
      }
      if (widget.runAnimation) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    super.didUpdateWidget(old);
  }
}
