class UserModel {
  final String objectId;
  final String username;
  final String fullName;
  final bool isAdmin;
  final String? token; // Add the token field here

  UserModel({
    required this.objectId,
    required this.username,
    required this.fullName,
    required this.isAdmin,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      objectId: json['objectId'],
      username: json['username'],
      fullName: json['fullName'],
      isAdmin: json['isAdmin'],
      token: json['sessionToken'], // Ensure the sessionToken is fetched here
    );
  }
}
