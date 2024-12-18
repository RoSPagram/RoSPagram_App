import 'package:flutter/material.dart';

class CounterBadge extends StatelessWidget {
  const CounterBadge({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      padding: EdgeInsets.all(1), // 텍스트 주위에 여백을 추가
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: Text(
          value > 99 ? '99+' : '$value',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}