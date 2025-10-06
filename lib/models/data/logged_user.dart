class LoggedInUser {
  // Private static instance variable
  static final LoggedInUser _instance = LoggedInUser._internal();

  // Private constructor to prevent external instantiation
  LoggedInUser._internal();

  // Factory constructor to provide the single instance
  factory LoggedInUser() {
    return _instance;
  }

  // Example data and methods
  String name = '';
  String? uid = '';
  String role = 'guest';

  void updateUser(String uid, String newName, String newRole) {
    if (this.uid == null || this.uid!.isEmpty) {
      this.uid = uid;
      this.name = newName;
      this.role = newRole;
    }
  }
}