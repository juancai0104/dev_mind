class User {
  final int? id;
  final String? googleId;
  final String fullName;
  final String username;
  final String? phoneNumber;
  final String email;
  final String? password;

  User({
    this.id,
    this.googleId,
    required this.fullName,
    required this.username,
    this.phoneNumber,
    required this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      googleId: json['googleId'],
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'],
      email: json['email'] ?? '',
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'googleId': googleId,
      'fullName': fullName,
      'username': username,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
    };
  }

  User copyWith({
    int? id,
    String? googleId,
    String? fullName,
    String? username,
    String? phoneNumber,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      googleId: googleId ?? this.googleId,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
