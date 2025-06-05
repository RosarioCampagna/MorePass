class Users {
  int? id;
  String color;
  bool first;
  String? creato;
  String? uid;
  String salt;

  Users(
      {this.id,
      required this.color,
      required this.first,
      this.creato,
      this.uid,
      required this.salt});

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        color: json['color'],
        first: json['first'],
        creato: json['creato'],
        uid: json['uid'],
        salt: json['salt'],
      );

  Map<String, dynamic> toJson() =>
      {'color': color, 'first': first, 'salt': salt};
}
