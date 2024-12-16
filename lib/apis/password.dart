class Passwords {
  int? id;
  String username;
  String provider;
  String password;
  String notes;
  String? creato;

  Passwords(
      {this.id,
      required this.provider,
      required this.username,
      required this.password,
      required this.notes,
      this.creato});

  factory Passwords.fromJson(Map<String, dynamic> json) => Passwords(
      id: json['id'],
      username: json['username'],
      provider: json['provider'],
      password: json['password'],
      notes: json['notes'],
      creato: json['creato']);

  Map<String, dynamic> toJson() => {
        'username': username,
        'provider': provider,
        'password': password,
        'notes': notes
      };
}
