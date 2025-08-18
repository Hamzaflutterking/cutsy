class ApiConfig {
  static const String baseUrl = "http://192.168.1.35:4000/api/v1/"; //LIVE URL
  static const String merdiaUrl = "http://192.168.1.35:4000/api/v1/"; //LIVE URL
  static const String socketUrl = "http://192.168.1.10:4000/afford_ride"; //LIVE URL
  // static String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:4000/afford_ride/api' : 'http://192.168.1.6:4000/afford_ride';

  static const String getUserDetails = "auth/me";

  //////////////////////////////Authentication API////////////////////////////////
  static const String login = "user/auth/Login";
  static const String register = "user/auth/SignUp";
  static const String forgetPassword = "user/auth/forgetPassword";
  static const String logout = "auth/logout";
  static const String resendOtp = "user/auth/resendOtp";
  static const String resetPassword = "user/auth/resetPassword";
  static const String createprofile = "user/auth/createdProfile";
  static const String verifyOtp = "user/auth/VerifyOtp";
  static const String getContacts = "user/contact/showUserContacts";
  static const String getFavoriteContacts = "user/contact/showFavoriteUserContacts";
  static const String addContact = "user/contact/saveUserContacts";
  static const String updateOnboardingStep = "user/driver/profile/onboarding-checklist";
  static const String allLibraryCategories = "user/library/showAllMessageStickersCategory";
  static const String libraryCategoriesById = "user/library/showAllMessageByCategory/";
  static const String fetchMilestoneCategories = "user/milestone/showMileStoneCategory";
  static const String showOtherMilestoneCategory = "user/milestone/showOtherMilestoneCategory";
  static const String showReminderCategory = "user/milestone/showReminderCategory";
  static const String showReminderType = "user/milestone/showOtherMilestoneCategory";
  static const String createMilestone = "user/milestone/createMilestone";
  static const String showAllMilestones = "user/milestone/showAllMilestone";
  static const todayReminders = 'user/milestone/todayReminders';
  // ApiConfigs.dart
  static const String showAllMilestone = 'user/milestone/showAllMilestone';
  static const showMileStoneByRange = 'user/milestone/showMilestoneByDayWeekMonthYearly';
  static const getMe = 'user/auth/getMe';
  static const String showAllNotifications = 'user/notification/showAllNotifications';
  static const String onOffNotification = 'user/notification/onAndOffNotification';
  static const String editProfile = 'user/auth/editProfile';
  static String saveFavoriteContact(String contactId) => 'user/contact/saveFavoriteUserContact/$contactId';
  static String editMilestone(String id) => 'user/milestone/editMilestone/$id';
  static String sendMilestoneToNumber(String milestoneId) => 'user/milestone/sendMilestoneToNumber/$milestoneId';

  //////////////////////////////Authentication API////////////////////////////////
  //////////////////////////////payment API////////////////////////////////

  //////////////////////////////Patyment API////////////////////////////////

  ////////////////////////////// User API////////////////////////////////

  static const String updateCarDetails = "user/driver/vehicle";
  static const String updateLocation = "user/driver/location";
  static const String onlineStatus = "user/driver/profile/status";
  static const String getLocation = "user/driver/location";

  ////////////////////////////// User API////////////////////////////////
}
