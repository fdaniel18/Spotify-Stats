class User {
  int _id; // Correct type to int for ID
  String _firstName;
  String _lastName;
  String _email;
  bool _isAdmin;

  // Constructor with an additional ID parameter
  User({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required bool isAdmin,
  })  : _id = id,
        _firstName = firstName,
        _lastName = lastName,
        _email = email,
        _isAdmin = isAdmin;

  // Getters
  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  bool get isAdmin => _isAdmin;

  // Setters
  set firstName(String value) {
    _firstName = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set email(String value) {
    _email = value;
  }

  set isAdmin(bool value) {
    _isAdmin = value;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id, // Include id as an int in the JSON map
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'isAdmin': _isAdmin,
    };
  }

  // Create a factory constructor to initialize from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int, 
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      isAdmin: json['is_admin'] as bool,
    );
  }

  @override
  String toString() {
    return 'User{id: $_id, firstName: $_firstName, lastName: $_lastName, email: $_email, isAdmin: $_isAdmin}';
  }
}
