class Passwords {
  int? id;
  String username;
  String provider;
  String password;
  String notes;
  String category;
  String? creato;

  Passwords(
      {this.id,
      required this.provider,
      required this.username,
      required this.password,
      required this.notes,
      required this.category,
      this.creato});

  factory Passwords.fromJson(Map<String, dynamic> json) => Passwords(
      id: json['id'],
      username: json['username'],
      provider: json['provider'],
      password: json['password'],
      notes: json['notes'],
      category: json['category'],
      creato: json['creato']);

  Map<String, dynamic> toJson() => {
        'username': username,
        'provider': provider,
        'password': password,
        'category': category,
        'notes': notes
      };
}
