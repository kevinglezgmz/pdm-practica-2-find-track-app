class UserModel {
  final String uid;
  final String email;
  final String username;

  UserModel({
    required this.username,
    required this.email,
    required this.uid,
  });

  UserModel.fromMap(Map<String, dynamic> item)
      : username = item['username'],
        email = item['email'],
        uid = item['uid'];
}
