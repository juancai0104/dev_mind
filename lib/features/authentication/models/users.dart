class User {
  final String? googleId;
  final String fullName;
  final String username;
  final String phoneNumber;
  final String email;
  final String? password;

  User({
    this.googleId,
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'googleId': googleId,
      'fullName': fullName,
      'username': username,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      googleId: json['googleId'],
      fullName: json['fullName'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
    );
  }
}