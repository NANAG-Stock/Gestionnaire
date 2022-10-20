import 'package:application_principal/redux/actions.dart';
import 'package:application_principal/redux/app_state.dart';

AppState reducer(AppState prevState, dynamic action) {
  AppState newState = AppState.fromAppState(prevState);
  if (action is UserRedux) {
    newState.user = action.user;
  } else if (action is CompanyRedux) {
    newState.company = action.company;
  } else if (action is SideBarAction) {
    newState.sideBarElements = action.sidebarElements;
  } else if (action is OpenSideBar) {
    newState.isClosed = action.isClosed;
  }
  return newState;
}
