import 'package:flutter/material.dart';

int calculateLevel(int xp) {
  int level = 0;
  int requiredXp = 1;

  while (xp >= requiredXp) {
    xp -= requiredXp;
    level++;
    requiredXp++;
  }

  return level;
}

double calculateProgress(int xp) {
  int level = calculateLevel(xp);
  int totalXpForCurrentLevel = 0;

  for (int i = 0; i < level; i++) {
    totalXpForCurrentLevel += i + 1;
  }

  int currentLevelXp = xp - totalXpForCurrentLevel;
  int requiredXpForNextLevel = level + 1;

  return currentLevelXp / requiredXpForNextLevel;
}

class LevelView extends StatelessWidget {
  const LevelView({super.key, required this.xp});

  final int xp;

  @override
  build(BuildContext context) {
    int level = calculateLevel(xp);
    double progress = calculateProgress(xp);
    return Column(
      children: [
        Text('Lv. $level',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16, right: 64, left: 64),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 2,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4, bottom: 16),
          child: Text('Xp: $xp',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        )
      ],
    );
  }
}