class UserModel {
  String uid;
  String name;
  String email;
  String photoUrl;
  String token;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.token});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      name: map['displayName'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      token: map['token'],
    );
  }

  Map<String, dynamic> get toMap => {
        'uid': uid,
        'displayName': name,
        'email': email,
        'photoUrl': photoUrl,
        'token': token
      };
}
