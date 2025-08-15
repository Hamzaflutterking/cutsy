import 'package:get/get.dart';

class NearbyController extends GetxController {
  var people = <PersonModel>[
    PersonModel(name: "Richard Anderson", address: "134 North Square, New York", image: "assets/images/Frame 567 (1).png"),
    PersonModel(name: "Noah Wilson", address: "78 Willow Crescent, Vancouver, CA", image: "assets/images/Frame 567 (2).png"),
    PersonModel(name: "Emily Harper", address: "134 Pennsylvania Square, Ontario, CA", image: "assets/images/Frame 567 (3).png"),
    PersonModel(name: "Olivia Brooks", address: "11 Maplewood Drive, Montreal, CA", image: "assets/images/Frame 567.png"),
    PersonModel(name: "Jack Reynolds", address: "213 Oakridge Court, Victoria, CA", image: "assets/images/Frame 567 (7).png"),
    PersonModel(name: "Sophie Tran", address: "245 Brighton Lane, Calgary, CA", image: "assets/images/Frame 567.png"),
  ].obs;
}

class PersonModel {
  final String name;
  final String address;
  final String image;

  PersonModel({required this.name, required this.address, required this.image});
}
