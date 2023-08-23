abstract class User {
  late String _id;
  late String _name;

  String get id => _id;
  set id(String value);

  String get name => _name;
  set name(String value);
}