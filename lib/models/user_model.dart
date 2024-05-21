import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Generated file by Hive

@HiveType(typeId: 0) // Unique typeId for User
class User extends HiveObject {
  @HiveField(0) // Index 0 for username
  String username;

  User(this.username);
}
