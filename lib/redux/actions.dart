// ignore_for_file: non_constant_identifier_names

import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/user.dart';

// redux user model
class UserRedux {
  final User user;
  UserRedux({
    required this.user,
  });
}

// redux company model
class CompanyRedux {
  final CompanyModel company;
  CompanyRedux({
    required this.company,
  });
}

// redux SidbarAction
class SideBarAction {
  final Map<String, dynamic> sidebarElements;

  SideBarAction({required this.sidebarElements});
}

// redux open/close side bar
class OpenSideBar {
  final bool isClosed;
  OpenSideBar({required this.isClosed});
}
