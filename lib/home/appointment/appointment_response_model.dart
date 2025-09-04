class AppointmentResponse {
  final bool? success;
  final String? message;
  final List<Appointment>? data;

  AppointmentResponse({this.success, this.message, this.data});

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List<dynamic>?)?.map((item) => Appointment.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.map((appointment) => appointment.toJson()).toList()};
  }
}

class Appointment {
  final String? id;
  final String? userId;
  final String? barberId;
  final String? day;
  final String? startTime;
  final String? endTime;
  final double? amount;
  final String? locationName;
  final double? locationLat;
  final double? locationLng;
  final String? status;
  final String? cancellationReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? totalAmount;
  final Barber? barber;
  final List<AppointmentService>? services;

  Appointment({
    this.id,
    this.userId,
    this.barberId,
    this.day,
    this.startTime,
    this.endTime,
    this.amount,
    this.locationName,
    this.locationLat,
    this.locationLng,
    this.status,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
    this.totalAmount,
    this.barber,
    this.services,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      barberId: json['barberId'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      amount: json['amount']?.toDouble(),
      locationName: json['locationName'],
      locationLat: json['locationLat']?.toDouble(),
      locationLng: json['locationLng']?.toDouble(),
      status: json['status'],
      cancellationReason: json['cancellationReason'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      totalAmount: json['totalAmount']?.toDouble(),
      barber: json['barber'] != null ? Barber.fromJson(json['barber'] as Map<String, dynamic>) : null,
      services: (json['services'] as List<dynamic>?)?.map((service) => AppointmentService.fromJson(service as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'barberId': barberId,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'amount': amount,
      'locationName': locationName,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'status': status,
      'cancellationReason': cancellationReason,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'totalAmount': totalAmount,
      'barber': barber?.toJson(),
      'services': services?.map((service) => service.toJson()).toList(),
    };
  }
}

class Barber {
  final String? id;
  final String? email;
  final String? name;
  final String? phoneNumber;
  final String? password;
  final String? gender;
  final bool? isCreatedProfile;
  final String? selectedHairTypeId;
  final String? selectedHairLengthId;
  final String? barberExperienceId;
  final String? barberServiceCategoryId;
  final double? latitude;
  final double? longitude;
  final String? addressName;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? states;
  final String? country;
  final String? postalCode;
  final String? bio;
  final String? experience;
  final String? userType;
  final String? deviceType;
  final String? deviceToken;
  final String? image;
  final String? barberAccountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Barber({
    this.id,
    this.email,
    this.name,
    this.phoneNumber,
    this.password,
    this.gender,
    this.isCreatedProfile,
    this.selectedHairTypeId,
    this.selectedHairLengthId,
    this.barberExperienceId,
    this.barberServiceCategoryId,
    this.latitude,
    this.longitude,
    this.addressName,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.states,
    this.country,
    this.postalCode,
    this.bio,
    this.experience,
    this.userType,
    this.deviceType,
    this.deviceToken,
    this.image,
    this.barberAccountId,
    this.createdAt,
    this.updatedAt,
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      gender: json['gender'],
      isCreatedProfile: json['isCreatedProfile'],
      selectedHairTypeId: json['selectedHairTypeId'],
      selectedHairLengthId: json['selectedHairLengthId'],
      barberExperienceId: json['barberExperienceId'],
      barberServiceCategoryId: json['barberServiceCategoryId'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      addressName: json['addressName'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      states: json['states'],
      country: json['country'],
      postalCode: json['postalCode'],
      bio: json['bio'],
      experience: json['experience'],
      userType: json['userType'],
      deviceType: json['deviceType'],
      deviceToken: json['deviceToken'],
      image: json['image'],
      barberAccountId: json['barberAccountId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'gender': gender,
      'isCreatedProfile': isCreatedProfile,
      'selectedHairTypeId': selectedHairTypeId,
      'selectedHairLengthId': selectedHairLengthId,
      'barberExperienceId': barberExperienceId,
      'barberServiceCategoryId': barberServiceCategoryId,
      'latitude': latitude,
      'longitude': longitude,
      'addressName': addressName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'states': states,
      'country': country,
      'postalCode': postalCode,
      'bio': bio,
      'experience': experience,
      'userType': userType,
      'deviceType': deviceType,
      'deviceToken': deviceToken,
      'image': image,
      'barberAccountId': barberAccountId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class AppointmentService {
  final String? id;
  final String? bookingId;
  final String? serviceCategoryId;
  final double? price;

  AppointmentService({this.id, this.bookingId, this.serviceCategoryId, this.price});

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json['id'],
      bookingId: json['bookingId'],
      serviceCategoryId: json['serviceCategoryId'],
      price: json['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'bookingId': bookingId, 'serviceCategoryId': serviceCategoryId, 'price': price};
  }
}

// Usage example:
// To parse the JSON data:
// 
// import 'dart:convert';
// 
// String jsonString = '...'; // Your JSON string
// Map<String, dynamic> jsonMap = json.decode(jsonString);
// AppointmentResponse response = AppointmentResponse.fromJson(jsonMap);
// 
// // Access the data (with null safety):
// if (response.data != null) {
//   for (Appointment appointment in response.data!) {
//     print('Appointment ID: ${appointment.id ?? 'N/A'}');
//     print('Barber Name: ${appointment.barber?.name ?? 'N/A'}');
//     print('Status: ${appointment.status ?? 'N/A'}');
//     print('Amount: ${appointment.amount ?? 0.0}');
//     
//     if (appointment.services != null) {
//       for (AppointmentService service in appointment.services!) {
//         print('Service Price: ${service.price ?? 0.0}');
//       }
//     }
//   }
// }