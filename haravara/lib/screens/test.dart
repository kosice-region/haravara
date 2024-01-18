import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor:
                0.5, // Устанавливаем ширину в 50% от доступного пространства
            child: AspectRatio(
              aspectRatio: 387.0.w / 186.0.h,
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Text('123'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
