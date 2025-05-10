class UserEntity {
  final String userName, userCountry, userPhone, userAddress, userRole,userEmail;
  final int userId;

  UserEntity(
      {required this.userName,
      required this.userCountry,
      required this.userPhone,
      required this.userAddress,
      required this.userRole,
      required this.userId,
      required this.userEmail
      });
}
