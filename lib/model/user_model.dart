class UserModel {
  String uid;
  String name;
  String email;
  String photoUrl;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.photoUrl});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        name: map['displayName'],
        email: map['email'],
        photoUrl: map['photoUrl']);
  }

  Map<String, dynamic> get toMap =>
      {'uid': uid, 'displayName': name, 'email': email, 'photoUrl': photoUrl};
}
