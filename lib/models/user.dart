class User {
  String id;
  String username;
  String avatarData;
  int index;
  int win;
  int loss;
  int draw;
  double score;
  String last_login;
  String fcm_token;
  int xp;

  User({
    this.id = '',
    this.username = '',
    this.avatarData = '',
    this.index = 0,
    this.win = 0,
    this.loss = 0,
    this.draw = 0,
    this.score = 0,
    this.last_login = '',
    this.fcm_token = '',
    this.xp = 0
  });
}