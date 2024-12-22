class User {
  String id;
  String username;
  String img_url;
  String avatarData;
  int index;
  int win;
  int loss;
  int draw;
  double score;
  String last_login;
  String fcm_token;

  User({
    this.id = '',
    this.username = '',
    this.img_url = '',
    this.avatarData = '',
    this.index = 0,
    this.win = 0,
    this.loss = 0,
    this.draw = 0,
    this.score = 0,
    this.last_login = '',
    this.fcm_token = ''
  });
}