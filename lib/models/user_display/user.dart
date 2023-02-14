class User {
  final String firstName;
  final String lastName;
  final String imageUrl;

  User(
      {required this.firstName,
      required this.lastName,
      required this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: (json['name']['first'] as String?) ?? '',
        lastName: (json['name']['last'] as String?) ?? '',
        imageUrl: (json['picture']['large'] as String?) ?? '');
  }
}
