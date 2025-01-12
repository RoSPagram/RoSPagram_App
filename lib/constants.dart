import 'package:flutter/material.dart';

String rgbToHex(int r, int g, int b) {
  assert(0 <= r && r <= 255);
  assert(0 <= g && g <= 255);
  assert(0 <= b && b <= 255);
  return '#${r.toRadixString(16).padLeft(2, '0')}'
      '${g.toRadixString(16).padLeft(2, '0')}'
      '${b.toRadixString(16).padLeft(2, '0')}';
}

// Gradient colors by rank
List<Color> rankColorGradient(int userRank) {
  switch(userRank) {
    case 1: //Bronze
      return const [Color(0xFFCD7F32), Color(0xFFE6BF98)];
    case 2: //Silver
      return const [Color(0xFFC0C0C0), Color(0xFFDFDFDF)];
    case 3: //Gold
      return const [Color(0xFFFFD700), Color(0xFFFFEB7F)];
    case 4: //Platinum
      return const [Color(0xFFA0B2C6), Color(0xFFCFD8E2)];
    case 5: //Diamond
      return const [Color(0xFFB9F2FF), Color(0xFFDCF8FF)];
    case 6: //Master
      return const [Color(0xFFE0B0FF), Color(0xFFEFD7FF)];
    default: //Unranked
      return const [Color(0xFF70A1B6), Color(0xFFD4E2E9)];
  }
}

String getRankNameFromCode(int rankCode) {
  switch(rankCode) {
    case 1: return 'Bronze';
    case 2: return 'Silver';
    case 3: return 'Gold';
    case 4: return 'Platinum';
    case 5: return 'Diamond';
    case 6: return 'Master';
    default: return 'Unranked';
  }
}

double getTopPercentage(int rankedUsersCount, int index) {
  if (index == 0 || rankedUsersCount == 0) return 0;
  return (index.toDouble() / rankedUsersCount.toDouble()) * 100;
}

int getUserRank(double top) {
  switch (top) {
    case > 0 && <= 2:
      return 6;
    case > 2 && <= 6:
      return 5;
    case > 6 && <= 14:
      return 4;
    case > 14 && <= 30:
      return 3;
    case > 30 && <= 62:
      return 2;
    case > 62:
      return 1;
    default:
      return 0;
  }
}

String getAvatarFaceSVG({
  String backgroundColor = "#ffffff",
  String cheekColor = "#ffbbbb",
  num faceRotate = 0,
  num eyesOpacity = 1.0,
  num cheekOpacity = 1.0,
  num mouthOpacity = 1.0
}) {
  return '''
<svg 
  width="150" 
  height="150" 
  viewBox="0 0 150 150" 
  xmlns="http://www.w3.org/2000/svg"
>
  <!-- 배경 -->
  <rect 
    x="0" 
    y="0" 
    width="150" 
    height="150" 
    rx="75"
    fill="$backgroundColor"
  />
    <!-- 얼굴 그룹 -->
    <g  
      transform="
      translate(-150, -150) 
      rotate($faceRotate, 225, 225)
      scale(3)
      ">
      <!-- 눈 (왼쪽, 오른쪽) -->
      <circle 
        cx="65" 
        cy="65" 
        r="3" 
        fill="#000000"
        fill-opacity="$eyesOpacity"
      />
      <circle 
        cx="85" 
        cy="65" 
        r="3" 
        fill="#000000"
        fill-opacity="$eyesOpacity"
      />
      <!-- 볼터치 (왼쪽, 오른쪽) -->
      <circle 
        cx="55" 
        cy="75" 
        r="3" 
        fill="$cheekColor"
        fill-opacity="$cheekOpacity"
      />
      <circle 
        cx="95" 
        cy="75" 
        r="3" 
        fill="$cheekColor"
        fill-opacity="$cheekOpacity"
      />
      <!-- 입: 간단한 곡선 -->
      <path 
        d="M 63,85 Q 75,95 87,85" 
        stroke="#000000" 
        stroke-width="2" 
        fill="none"
        opacity="$mouthOpacity"
      />
    </g>
</svg> 
  ''';
}

String getAvatarBodySVG({
  String backgroundColor = "#ffffff",
  num bodyRotate = 0,
}) {
  return '''
<svg 
  width="150" 
  height="150" 
  viewBox="0 0 150 150" 
  xmlns="http://www.w3.org/2000/svg"
>
  <!-- clipPath 정의 -->
  <defs>
    <clipPath id="background-clip" clipPathUnits="userSpaceOnUse">
      <rect 
        x="0" 
        y="0" 
        width="150" 
        height="150" 
        rx="75"
      />
    </clipPath>
  </defs>

  <!-- 아바타 전체 그룹 -->
  <g clip-path="url(#background-clip)"
    transform="
    translate(0, 0) 
    rotate($bodyRotate, 75, 75)
  ">
    <!-- 몸통 그룹 -->
    <g transform="
      translate(0, 0) 
      rotate(0, 75, 75)
    ">
      <!-- 몸통 -->
      <path 
        d="
          M 75,20 
          C 95,20 115,40 115,80 
          L 115,200 
          L 35,200 
          L 35,80 
          C 35,40 55,20 75,20 Z
        "
        fill="$backgroundColor"
        stroke="#000000"
        stroke-width="3"
      />
    </g>
  </g>
</svg>
  ''';
}

String getAvatarBackgroundSVG({String color = '#ddf'}) {
  return '<svg width="150" height="150" viewBox="0 0 150 150" xmlns="http://www.w3.org/2000/svg"><circle cx="75" cy="75" r="75" fill="$color"/></svg>';
}