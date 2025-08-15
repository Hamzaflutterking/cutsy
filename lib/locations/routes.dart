// routes.dart
import 'package:cutcy/auth/hair_selection_screen.dart';
import 'package:cutcy/locations/address_details_scree.dart';
import 'package:cutcy/locations/confirm_location_screen.dart';
import 'package:cutcy/locations/map_screen.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: '/', page: () => HairSelectionScreen()),
  GetPage(name: '/map', page: () => MapScreen()),
  GetPage(name: '/search', page: () => AddressDetailScreen()),
  GetPage(name: '/confirm_location', page: () => ConfirmLocationScreen()),
  GetPage(name: '/address_details', page: () => AddressDetailScreen()),
];
