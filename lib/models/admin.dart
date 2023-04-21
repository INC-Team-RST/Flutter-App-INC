class AdminData {
  int id;
  String emailId;
  String displayName;
  String uid;
  String profession;
  String photoURL;
  String phone;

  AdminData({
    required this.id,
    required this.emailId,
    required this.displayName,
    required this.uid,
    required this.profession,
    required this.photoURL,
    required this.phone,
  });
}

class AdminAppointment {
  int id;
  int userId;
  int adminId;
  String userName;
  String userEmail;
  String userPhone;
  String userPhotoURL;
  String status;
  String startTime;
  String endTime;
  String date;

  AdminAppointment({
    required this.id,
    required this.userId,
    required this.adminId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userPhotoURL,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.date,
  });
}
