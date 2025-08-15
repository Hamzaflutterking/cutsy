import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favorites = <Person>[
    Person(name: "Richard Anderson", address: "134 North Square, New York", image: "assets/images/Frame 567 (1).png"),
    Person(name: "Noah Wilson", address: "78 Willow Crescent, Vancouver, CA", image: "assets/images/Frame 567 (2).png"),
    Person(name: "Emily Harper", address: "134 Pennsylvania Square, Ontario, CA", image: "assets/images/Frame 567 (3).png"),
    Person(name: "Olivia Brooks", address: "11 Maplewood Drive, Montreal, CA", image: "assets/images/Frame 567.png"),
    Person(name: "Jack Reynolds", address: "213 Oakridge Court, Victoria, CA", image: "assets/images/Frame 567 (7).png"),
    Person(name: "Sophie Tran", address: "245 Brighton Lane, Calgary, CA", image: "assets/images/Frame 567.png"),
  ].obs;
}

class Person {
  final String name;
  final String address;
  final String image;

  Person({required this.name, required this.address, required this.image});
}
