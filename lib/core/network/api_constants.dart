class ApiConstants {
  static const String baseUrl = "https://library.asr3-languages.com/api/v1/";
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String users = "users/list";
  static const String storeUser = "users/store";
  static const String updateUser = '/users/update/';
  static const String deleteUser = '/users/delete/';
  static const String customers = 'customer/index';
  static const String storeCustomer = 'customer/store';
  static const String updateCustomer = 'customer/update/';
  static const String deleteCustomer = 'customer/delete/';
  static const String getTransfers = 'transfer/index';
  static const String storeTransfers = 'transfer/store';
  static const String updateTransfer = 'transfer/update/';
  static const String deleteTransfer = 'transfer/delete/';
  static const String getCashBox = 'cash-box/index';
  static const String storeCashBox = 'cash-box/store';
  static const String updateCashBox = '/cash-box/update/';
  static const String deleteCashBox = '/cash-box/delete/';
  static String autoComplete(String resource, String query) {
    return '$resource/search?query=$query';
  }
  static String storeTag = 'tag/store';
  static const String getExpense ='expense/index';
  static const String storeExpense ='expense/store';
  static const String updateExpense ='expense/update/';
  static const String deleteExpense ='expense/delete/';
  static const String getDebtor = 'customer/debtor-customers';
}
