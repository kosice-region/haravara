import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedBoyWidget extends StatefulWidget {
  AnimatedBoyWidget({required this.path, super.key});

  List<String> path;
  @override
  _AnimatedBoyWidgetState createState() => _AnimatedBoyWidgetState();
}

class _AnimatedBoyWidgetState extends State<AnimatedBoyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  Timer? _timer;

  late String path;
  @override
  void initState() {
    path = widget.path[0];
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation after a 5-second delay
    Future.delayed(const Duration(microseconds: 500), () {
      _controller.forward();
    });

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer t) {
      setState(() {
        path = widget.path[1];
      });

      // Wait for 1 second and then revert back to the original path
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            path = widget.path[0];
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Image.asset(
          path,
          height: MediaQuery.of(context).size.height * 0.60,
          width: MediaQuery.of(context).size.width * 0.8,
        ), // Replace with your actual image path
      ),
    );
  }
}
