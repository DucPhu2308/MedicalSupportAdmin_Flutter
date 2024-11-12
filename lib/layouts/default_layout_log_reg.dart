import 'package:flutter/material.dart';
import 'dart:async';

class DefaultLayoutLogReg extends StatefulWidget {
  final Widget child;

  const DefaultLayoutLogReg({Key? key, required this.child}) : super(key: key);

  @override
  _DefaultLayoutLogRegState createState() => _DefaultLayoutLogRegState();
}

class _DefaultLayoutLogRegState extends State<DefaultLayoutLogReg> {
  Timer? _timer;
  final List<String> images = [
    '/pictureDoctor.jpg',
    '/pictureDoctor2.jpg',
  ];

  int currentImageIndex = 0;
  bool fadeIn = true;

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        fadeIn = false;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentImageIndex = (currentImageIndex + 1) % images.length;
          fadeIn = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: fadeIn ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Image.asset(
              images[currentImageIndex],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
