class User {
  String id;
  String username;
  String img_url;
  int rank;
  int win;
  int loss;
  int draw;
  double score;

  User({
    this.id = '',
    this.username = '',
    this.img_url = '',
    this.rank = 0,
    this.win = 0,
    this.loss = 0,
    this.draw = 0,
    this.score = 0,
  });
}