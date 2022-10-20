// ignore_for_file: non_constant_identifier_names

class User {
  final String id;
  final String nom;
  final String droit;
  final String is_active;
  final String username;
  final String l_online;
  final String l_connect;
  final String l_update;
  final String date_creation;
  final String code;
  final String is_entreprise;

  User({
    required this.l_update,
    required this.nom,
    required this.date_creation,
    required this.is_entreprise,
    required this.id,
    required this.username,
    required this.l_online,
    required this.l_connect,
    required this.code,
    required this.droit,
    required this.is_active,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'nom': nom.toString(),
      'droit': droit.toString(),
      'is_active': is_active.toString(),
      'l_online': l_online.toString(),
      'l_connect': l_connect.toString(),
      'code': code.toString(),
      'username': username.toString(),
      'date': date_creation.toString(),
      'l_update': l_update.toString(),
      'is_entreprise': is_entreprise.toString(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      nom: json['nom'].toString(),
      droit: json['droit'].toString(),
      is_active: json['is_active'].toString(),
      username: json['username'].toString(),
      code: json['code'].toString(),
      date_creation: json['date'].toString(),
      l_online: json['l_online'].toString(),
      l_update: json['l_update'].toString(),
      is_entreprise: json['is_entreprise'].toString(),
      l_connect: json['l_connect'].toString(),
    );
  }
}
