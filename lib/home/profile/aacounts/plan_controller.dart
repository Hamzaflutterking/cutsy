import 'package:get/get.dart';

class PlanController extends GetxController {
  // Current plan details
  var currentPlan = 'Free'.obs;
  var planPrice = '\$0/year'.obs;
  var planFeatures = [
    'Quick and simple scheduling with your favorite stylists.',
    'Never miss your hair appointment with timely notifications.',
    'Reschedule and cancel with ease directly from the app.',
  ].obs;
}

class MembershipController extends GetxController {
  var benefits = [
    'Get access to top stylists and preferred time slots.',
    'Enjoy members-only pricing on all services.',
    'Be the first to book appointments with in-demand stylists.',
    'Get expert advice before every appointment.',
    'Enjoy easy rescheduling and instant reminders.',
  ].obs;
}
