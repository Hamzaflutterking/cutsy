class ApiConfig {
  // Base(s)
  static const String baseUrl = "http://192.168.1.20:4000/api/v1/"; // from api.json {{localhost}}

  // ───────── USER ─────────

  // user/auth
  static const String userSignUp = "user/auth/signUp";
  static const String userVerifyOtp = "user/auth/verifyOtp";
  static const String userForgetPassword = "user/auth/forgetPassword";
  static const String userResetPassword = "user/auth/resetPassword";
  static const String userLogin = "user/auth/login";
  static const String userEditProfile = "user/auth/editProfile"; // PATCH (multipart supported)
  static const String userChangePassword = "user/auth/changePassword";
  static const String userLogout = "user/auth/logOut"; // POST
  static const String userDeleteAccount = "user/auth/deleteAccount"; // DELETE
  static const String userSocialLogin = "user/auth/socialLogin"; // POST
  static const String userResendOtp = "user/auth/resendOtp"; // POST
  static const String userCreateProfile = "user/auth/userCreateProfile";

  // user/chat
  static const String userCreateChatRoom = "user/chat/createChatRoom"; // POST
  static const String userGetChatRoom = "user/chat/getChatRoom"; // GET

  // user/address
  static const String userSaveAddress = "user/address/saveUserAddress"; // POST
  static const String userShowSavedAddress = "user/address/showUserSaveAddress"; // GET

  // user/homefeed
  static const String userShowNearestBarbers = "user/homefeed/showNearestBarbers"; // GET
  static const String userShowBarbersBySearch = "user/homefeed/showBarbersBySearchService"; // GET ?search=
  static String userSaveBarberInFavoriteList(String barberId) => "user/homefeed/saveBarberInFavoriteList/$barberId"; // POST
  static const String userShowBarberFavouriteList = "user/homefeed/showBarberFavouriteList"; // GET
  static const String userShowTrendingBarbers = "user/homefeed/showTrendingBarbers"; // GET

  // user/booking
  static const String userCreateBookingAndPayment = "user/booking/createBookingAndPayment"; // POST
  static String userShowAppointmentDetail(String bookingId) => "user/booking/showAppoinmentDetail/$bookingId"; // GET
  static String userCancelAppointment(String bookingId) => "user/booking/cancelAppointment/$bookingId"; // POST
  static String userTrackBarber(String barberId) => "user/booking/trackBarber/$barberId"; // GET
  static String userShowInvoiceDetail(String bookingId) => "user/booking/showInvoiceDetail/$bookingId"; // GET
  static String userShowPaymentReceipt(String receiptId) => "user/booking/showPaymentReceipt/$receiptId"; // GET
  static const String userSubmitReview = "user/booking/submitReview"; // POST

  // user/paymentmethod
  static const String userAddPaymentMethod = "user/paymentmethod/addPaymentMethod"; // POST
  static const String userShowPaymentMethods = "user/paymentmethod/showPaymentMethods"; // GET

  // user/appoinmenthistory  (note: API spelling kept as-is)
  static const String userUpcomingAppointments = "user/appoinmenthistory/showUserUpComingAppoinment";
  static const String userOngoingAppointments = "user/appoinmenthistory/showUserUpComingAppoinment"; // collection shows same path for ongoing
  static const String userPastAppointments = "user/appoinmenthistory/showUserPastAppoinment";

  // user/notification
  static const String userShowAllNotification = "user/notification/showAllNotification";
  static String userReadNotification(String id) => "user/notification/readNotification/$id";
  static const String userOnOffNotification = "user/notification/onAndOffNotification";

  // ───────── BARBER ─────────

  // barber/auth
  static const String barberSignUp = "barber/auth/singUp"; // API has 'singUp'
  static const String barberVerifyOtp = "barber/auth/verifyOtp";
  static const String barberForgetPassword = "barber/auth/forgetPassword";
  static const String barberResetPassword = "barber/auth/resetPassword";
  static const String barberLogin = "barber/auth/login";
  static const String barberEditProfile = "barber/auth/editProfile"; // PATCH (multipart supported)
  static const String barberLogout = "barber/auth/logOut"; // POST
  static const String barberChangePassword = "barber/auth/changePassword";
  static const String barberDeleteAccount = "barber/auth/deleteAccount";
  static const String barberSocialLogin = "barber/auth/socialLogin";
  static const String barberCreateProfile = "barber/auth/barberCreateProfile";
  static const String barberResendOtp = "barber/auth/resendOtp";

  // barber/service
  static String barberAddServices(String serviceId) => "barber/service/addServices/$serviceId"; // POST
  static const String barberShowServices = "barber/service/showServices"; // GET
  static String barberEditService(String serviceId) => "barber/service/editService/$serviceId"; // PUT

  // barber/availablehourandsubmitdocument
  static const String barberAddAvailableHour = "barber/availablehourandsubmitdocument/addAvailableHour"; // POST
  static const String barberShowAvailableHour = "barber/availablehourandsubmitdocument/showAvailableHour"; // GET
  static const String barberSubmitDocument = "barber/availablehourandsubmitdocument/barberSubmitDocument"; // POST (multipart)

  // barber/businessaccount
  static const String barberAddBusinessAccount = "barber/businessaccount/addbarberBusinessAccount"; // POST
  static const String barberShowBusinessAccount = "barber/businessaccount/showbarberBusinessAccount"; // GET
  static const String barberCheckBalance = "barber/businessaccount/checkBarberBalance"; // GET
  static const String barberWithdrawAmount = "barber/businessaccount/withDrawAmountBarber"; // POST
  static const String barberShowAllTransactions = "barber/businessaccount/showAllBarberTransactions"; // GET

  // barber/appoinmenthistory
  static const String barberUpcomingAppointments = "barber/appoinmenthistory/showBarberUpComingAppoinment";
  static const String barberOnGoingAppointments = "barber/appoinmenthistory/showBarberOnGoingAppoinment";
  static const String barberPastAppointments = "barber/appoinmenthistory/showBarberPastAppoinment";

  // barber/dashboard
  static const String barberLatestUpcomingAppointment = "barber/dashboard/showLatestUpcomingAppoinment";
  static const String barberAllUpcomingAppointments = "barber/dashboard/showAllUpcomingAppoinments";
  static const String barberAllStats = "barber/dashboard/showAllStats";

  // barber/notification
  static const String barberShowAllNotification = "barber/notification/showAllNotification";
  static String barberReadNotification(String id) => "barber/notification/readNotification/$id";
  static const String barberOnOffNotification = "barber/notification/onAndOffNotification";

  // ───────── ADMIN (optional, if you call from app) ─────────
  // auth
  static const String adminLogin = "admin/auth/adminLogin";

  // hair (type/length)
  static const String adminCreateHairType = "admin/hair/adminCreateHairType";
  static const String adminShowHairType = "admin/hair/adminShowHairType";
  static String adminUpdateHairType(String id) => "admin/hair/adminUpdateHairType/$id";
  static String adminDeleteHairType(String id) => "admin/hair/adminDeleteHairType/$id";

  static const String adminCreateHairLength = "admin/hair/adminCreateHairLength";
  static const String adminShowHairLength = "admin/hair/adminShowHairLength";
  static String adminUpdateHairLength(String id) => "admin/hair/adminUpdateHairLength/$id";
  static String adminDeleteHairLength(String id) => "admin/hair/adminDeleteHairLength/$id";

  // barberexperience
  static const String adminCreateBarberExperience = "admin/barberexperience/adminCreateBarberExperience";
  static const String adminShowBarberExperience = "admin/barberexperience/adminShowBarberExperience";
  static String adminUpdateBarberExperience(String id) => "admin/barberexperience/adminUpdateBarberExperience/$id";
  static String adminDeleteBarberExperience(String id) => "admin/barberexperience/adminDeleteBarberExperience/$id";

  // barberservice
  static const String adminCreateBarberService = "admin/barberservice/adminCreateBarberService";
  static const String adminShowBarberService = "admin/barberservice/adminShowBarberService";
  static String adminUpdateBarberService(String id) => "admin/barberservice/adminUpdateBarberService/$id";
  static String adminDeleteBarberService(String id) => "admin/barberservice/adminDeleteBarberService/$id";

  // content
  static const String adminCreatePrivacyPolicy = "admin/content/createPrivacyPolicy";
  static const String adminShowPrivacyPolicy = "admin/content/showPrivacyPolicy";
  static String adminUpdatePrivacyPolicy(String id) => "admin/content/updatePrivacyPolicy/$id";

  static const String adminCreateTerms = "admin/content/createTermsCondition";
  static const String adminShowTerms = "admin/content/showTermsCondtion";
  static String adminUpdateTerms(String id) => "admin/content/updateTermsCondition/$id";

  static const String adminShowAllUsers = "admin/content/showAllUsers";
  static const String adminShowAllBarbers = "admin/content/showAllBarbers";
  static const String adminCountUsers = "admin/content/countUsers";
  static const String adminIosUsers = "admin/content/iosUsers";
  static const String adminAndroidUsers = "admin/content/androidUsers";

  // payment
  static const String adminShowAllPaymentRecieved = "admin/payment/showAllPaymentRecieved";
  static const String adminTransferAmountToBarber = "admin/payment/transerAmountToBarberAccount";
}
