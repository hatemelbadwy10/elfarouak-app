class ApiConstants {
  static const String baseUrl = "https://dev.8worx.com/8x-workflow-test/api/v1/";
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String forgetPassword='auth/reset-password';
  static const String resetPassword= 'auth/new-password';
  static const String updateEmail = "auth/update-mail";
  static const String updateMobile = "auth/update-phone";
  static const String updatePassword ='auth/update-password';
  static const String requests = "requests";
  static const String requestForm = "requests/get-request-form";
  static const String requestVacation ='requests/vacation/store';
  static const String updateUserToken ="users/update-device-token";
  static const String userRequests ='requests/workflow-requests';
  static const String singleRequest = "requests/show";
  static const String updateVacation = "requests/request-workflow/update";
  static const String requestsTypes = 'requests/workflow-request-status';
  static const String storeForm = 'requests/request-workflow/store';
  static const String userUpdateVacation ="requests/request-workflow/user-update";
  static const String getAppLists ="lists/get-app-list";
}
