import 'dart:math';

String rgbToHex(int r, int g, int b) {
  assert(0 <= r && r <= 255);
  assert(0 <= g && g <= 255);
  assert(0 <= b && b <= 255);
  return '#${r.toRadixString(16).padLeft(2, '0')}'
      '${g.toRadixString(16).padLeft(2, '0')}'
      '${b.toRadixString(16).padLeft(2, '0')}';
}

class Avatar {
  String backgroundColor = '#ffffff';
  String bodyColor = '#ffffff';
  String lineColor = '#000000';
  String eyeColor = '#000000';
  String mouthColor = '#000000';
  String cheekColor = '#ffbbbb';

  int avatarTx = 0;
  int avatarTy = 0;
  int avatarRotate = 0;

  int bodyTx = 0;
  int bodyTy = 0;
  int bodyRotate = 0;

  int faceTx = 0;
  int faceTy = 0;
  int faceRotate = 0;

  Avatar({
    this.backgroundColor = '#ffffff',
    this.bodyColor = '#ffffff',
    this.lineColor = '#000000',
    this.eyeColor = '#000000',
    this.mouthColor = '#000000',
    this.cheekColor = '#ffbbbb',
    this.avatarTx = 0,
    this.avatarTy = 0,
    this.avatarRotate = 0,
    this.bodyTx = 0,
    this.bodyTy = 0,
    this.bodyRotate = 0,
    this.faceTx = 0,
    this.faceTy = 0,
    this.faceRotate = 0
  });

  void applyRandom() {
    this.backgroundColor = rgbToHex(128 + Random().nextInt(128), 128 + Random().nextInt(128), 128 + Random().nextInt(128));
    this.bodyColor = rgbToHex(128 + Random().nextInt(128), 128 + Random().nextInt(128), 128 + Random().nextInt(128));
    this.cheekColor = rgbToHex(128 + Random().nextInt(128), 128 + Random().nextInt(128), 128 + Random().nextInt(128));
    // this.avatarTx = -20 + Random().nextInt(41);
    // this.avatarTy = -20 + Random().nextInt(41);
    this.avatarRotate = -30 + Random().nextInt(61);
    this.bodyTx = -5 + Random().nextInt(11);
    this.bodyTy = -10 + Random().nextInt(21);
    // this.bodyRotate = -30 + Random().nextInt(61);
    this.faceTx = -10 + Random().nextInt(21);
    this.faceTy = -10 + Random().nextInt(21);
    this.faceRotate = -20 + Random().nextInt(41);
  }

  String getSVG() {
    return '''
 <svg 
  width="150" 
  height="150" 
  viewBox="0 0 150 150" 
  xmlns="http://www.w3.org/2000/svg">
  <!-- 배경 사각형 -->
  <rect 
    x="0" 
    y="0" 
    width="150" 
    height="150" 
    rx="75"
    fill="${this.backgroundColor}"
  />

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
  <!-- 아바타를 (75,75)를 중심으로 회전하도록 회전 중심점 설정 -->
  <g clip-path="url(#background-clip)"
    transform="
    translate(${this.avatarTx}, ${this.avatarTy}) 
    rotate(${this.avatarRotate}, 75, 75)
  ">
    <!-- 몸통 그룹 -->
    <g transform="
      translate(${this.bodyTx}, ${this.bodyTy}) 
      rotate(${this.bodyRotate}, 75, 75)
    ">
      <!-- 몸통: 윗부분은 곡선, 아래로는 직선으로 늘어나는 형태 -->
      <path 
        d="
          M 75,20 
          C 95,20 115,40 115,80 
          L 115,200 
          L 35,200 
          L 35,80 
          C 35,40 55,20 75,20 Z
        "
        fill="${this.bodyColor}"
        stroke="${this.lineColor}"
        stroke-width="3"
      />
    </g>
    
    <!-- 얼굴 그룹 -->
    <g  
      transform="
      translate(${this.faceTx}, ${this.faceTy}) 
      rotate(${this.faceRotate}, 75, 75)
      ">
      <!-- 눈 (왼쪽, 오른쪽) -->
      <circle 
        cx="65" 
        cy="65" 
        r="3" 
        fill="${this.eyeColor}"
      />
      <circle 
        cx="85" 
        cy="65" 
        r="3" 
        fill="${this.eyeColor}"
      />
      <!-- 볼터치 (왼쪽, 오른쪽) -->
      <circle 
        cx="55" 
        cy="75" 
        r="3" 
        fill="${this.cheekColor}"
      />
      <circle 
        cx="95" 
        cy="75" 
        r="3" 
        fill="${this.cheekColor}"
      />
      
      <!-- 입: 간단한 곡선 -->
      <path 
        d="M 63,85 Q 75,95 87,85" 
        stroke="${this.mouthColor}" 
        stroke-width="2" 
        fill="none"
      />
    </g>
  </g>
</svg>
  ''';
  }

  factory Avatar.fromJSON(Map<String, dynamic> jsonData) {
    return Avatar(
        backgroundColor: jsonData['color']['background'],
        bodyColor: jsonData['color']['body'],
        lineColor: jsonData['color']['line'],
        eyeColor: jsonData['color']['eye'],
        mouthColor: jsonData['color']['mouth'],
        cheekColor: jsonData['color']['cheek'],
        avatarTx: jsonData['avatar']['tx'],
        avatarTy: jsonData['avatar']['ty'],
        avatarRotate: jsonData['avatar']['rot'],
        bodyTx: jsonData['body']['tx'],
        bodyTy: jsonData['body']['ty'],
        bodyRotate: jsonData['body']['rot'],
        faceTx: jsonData['face']['tx'],
        faceTy: jsonData['face']['ty'],
        faceRotate: jsonData['face']['rot']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "color": {
        "background": this.backgroundColor,
        "body": this.bodyColor,
        "line": this.lineColor,
        "eye": this.eyeColor,
        "mouth": this.mouthColor,
        "cheek": this.cheekColor
      },
      "avatar": {
        "tx": this.avatarTx,
        "ty": this.avatarTy,
        "rot": this.avatarRotate
      },
      "body": {
        "tx": this.bodyTx,
        "ty": this.bodyTy,
        "rot": this.bodyRotate
      },
      "face": {
        "tx": this.faceTx,
        "ty": this.faceTy,
        "rot": this.faceRotate
      }
    };
  }
}