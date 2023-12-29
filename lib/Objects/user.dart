/// This class is used to store the user data
class UserData {
  /// Constructor for UserData object with required parameters
  UserData({
    required this.email,
    required this.id,
  });

  /// Email of the user
  String email;

  /// Id of the user (used to identify the user in the database)
  String id;
}
