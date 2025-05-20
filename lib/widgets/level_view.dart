import 'package:flutter/material.dart';
import 'dart:math';

int calculateLevel(int xp) {
  // int level = 0;
  // int requiredXp = 1;
  //
  // while (xp >= requiredXp) {
  //   xp -= requiredXp;
  //   level++;
  //   requiredXp++;
  // }
  //
  // return level;
  return ((sqrt(1 + 8 * xp) - 1) / 2).floor();
}

double calculateProgress(int xp) {
  // int level = calculateLevel(xp);
  // int totalXpForCurrentLevel = 0;
  //
  // for (int i = 0; i < level; i++) {
  //   totalXpForCurrentLevel += i + 1;
  // }
  //
  // int currentLevelXp = xp - totalXpForCurrentLevel;
  // int requiredXpForNextLevel = level + 1;
  //
  // return currentLevelXp / requiredXpForNextLevel;

  // 1) 레벨 계산
  final level = ((sqrt(1 + 8 * xp) - 1) / 2).floor();

  // 2) 현재 레벨까지 누적된 XP
  final usedXp = level * (level + 1) ~/ 2;

  // 3) 현재 레벨에서 쌓인 XP
  final currentXp = xp - usedXp;

  // 4) 다음 레벨까지 필요한 XP
  final nextXp = level + 1;

  return currentXp / nextXp;
}

class LevelView extends StatelessWidget {
  const LevelView({super.key, required this.xp, required this.showProgress});

  final int xp;
  final bool showProgress;

  @override
  build(BuildContext context) {
    int level = calculateLevel(xp);
    double progress = calculateProgress(xp);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text('Lv. $level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        if (showProgress)
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 64, left: 64),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: Colors.grey[200],
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4, bottom: 16),
                child: Text('Xp: ${(progress * 100).toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              )
            ],
          ),
      ],
    );
  }
}