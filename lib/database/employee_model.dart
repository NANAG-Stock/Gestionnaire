// ignore_for_file: file_names

class EmployeeModel {
  final String nomEmp;
  final String cnibEmp;
  final String telEmp;
  final String motdepassEmp;
  final String droitEmp;
  final String idEmp;
  final String codeEmp;
  final String statutEmp;
  final String salaireEmp;
  final String sexe;
  final String dateUser;
  final String username;

  EmployeeModel({
    required this.nomEmp,
    required this.cnibEmp,
    required this.telEmp,
    required this.motdepassEmp,
    required this.droitEmp,
    required this.idEmp,
    required this.codeEmp,
    required this.statutEmp,
    required this.salaireEmp,
    required this.sexe,
    required this.dateUser,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'nomEmp': nomEmp.toString(),
      'cnibEmp': cnibEmp.toString(),
      'telEmp': telEmp.toString(),
      'motdepassEmp': motdepassEmp.toString(),
      'idEmp': idEmp.toString(),
      'codeEmp': codeEmp.toString(),
      'statutEmp': statutEmp.toString(),
      'salaireEmp': salaireEmp.toString(),
    };
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      nomEmp: json['nomEmp'].toString(),
      cnibEmp: json['cnibEmp'].toString(),
      telEmp: json['telEmp'].toString(),
      motdepassEmp: json['motdepassEmp'].toString(),
      idEmp: json['idEmp'].toString(),
      codeEmp: json['codeEmp'].toString(),
      statutEmp: json['statutEmp'].toString(),
      salaireEmp: json['salaireEmp'].toString(),
      droitEmp: json['droitEmp'].toString(),
      sexe: json['sexe'].toString(),
      dateUser: json['dateUser'].toString(),
      username: json['username'].toString(),
    );
  }
}
