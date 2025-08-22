// To parse this JSON data, do
//
//     final favBarberModel = favBarberModelFromJson(jsonString);

import 'dart:convert';

FavBarberModel favBarberModelFromJson(String str) => FavBarberModel.fromJson(json.decode(str));

String favBarberModelToJson(FavBarberModel data) => json.encode(data.toJson());

class FavBarberModel {
  final bool? success;
  final String? message;
  final List<FavBarberData>? data;

  FavBarberModel({this.success, this.message, this.data});

  factory FavBarberModel.fromJson(Map<String, dynamic> json) => FavBarberModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<FavBarberData>.from(json["data"]!.map((x) => FavBarberData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FavBarberData {
  final String? id;
  final String? userId;
  final String? barberId;
  final DateTime? createdAt;
  final Barber? barber;

  FavBarberData({this.id, this.userId, this.barberId, this.createdAt, this.barber});

  factory FavBarberData.fromJson(Map<String, dynamic> json) => FavBarberData(
    id: json["id"],
    userId: json["userId"],
    barberId: json["barberId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    barber: json["barber"] == null ? null : Barber.fromJson(json["barber"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "barberId": barberId,
    "createdAt": createdAt?.toIso8601String(),
    "barber": barber?.toJson(),
  };
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
  final dynamic barberServiceCategoryId;
  final double? latitude;
  final double? longitude;
  final String? addressName;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? states;
  final String? country;
  final String? postalCode;
  final dynamic bio;
  final dynamic experience;
  final String? userType;
  final String? deviceType;
  final String? deviceToken;
  final dynamic image;
  final String? barberAccountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<BarberService>? barberService;
  final SelectedHair? selectedHairType;
  final SelectedHair? selectedHairLength;
  final BarberExperience? barberExperience;
  final List<BarberAvailableHour>? barberAvailableHour;

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
    this.barberService,
    this.selectedHairType,
    this.selectedHairLength,
    this.barberExperience,
    this.barberAvailableHour,
  });

  factory Barber.fromJson(Map<String, dynamic> json) => Barber(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    gender: json["gender"],
    isCreatedProfile: json["isCreatedProfile"],
    selectedHairTypeId: json["selectedHairTypeId"],
    selectedHairLengthId: json["selectedHairLengthId"],
    barberExperienceId: json["barberExperienceId"],
    barberServiceCategoryId: json["barberServiceCategoryId"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    addressName: json["addressName"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    city: json["city"],
    states: json["states"],
    country: json["country"],
    postalCode: json["postalCode"],
    bio: json["bio"],
    experience: json["experience"],
    userType: json["userType"],
    deviceType: json["deviceType"],
    deviceToken: json["deviceToken"],
    image: json["image"],
    barberAccountId: json["barberAccountId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    barberService: json["BarberService"] == null ? [] : List<BarberService>.from(json["BarberService"]!.map((x) => BarberService.fromJson(x))),
    selectedHairType: json["selectedHairType"] == null ? null : SelectedHair.fromJson(json["selectedHairType"]),
    selectedHairLength: json["selectedHairLength"] == null ? null : SelectedHair.fromJson(json["selectedHairLength"]),
    barberExperience: json["barberExperience"] == null ? null : BarberExperience.fromJson(json["barberExperience"]),
    barberAvailableHour: json["BarberAvailableHour"] == null
        ? []
        : List<BarberAvailableHour>.from(json["BarberAvailableHour"]!.map((x) => BarberAvailableHour.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "phoneNumber": phoneNumber,
    "password": password,
    "gender": gender,
    "isCreatedProfile": isCreatedProfile,
    "selectedHairTypeId": selectedHairTypeId,
    "selectedHairLengthId": selectedHairLengthId,
    "barberExperienceId": barberExperienceId,
    "barberServiceCategoryId": barberServiceCategoryId,
    "latitude": latitude,
    "longitude": longitude,
    "addressName": addressName,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "city": city,
    "states": states,
    "country": country,
    "postalCode": postalCode,
    "bio": bio,
    "experience": experience,
    "userType": userType,
    "deviceType": deviceType,
    "deviceToken": deviceToken,
    "image": image,
    "barberAccountId": barberAccountId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "BarberService": barberService == null ? [] : List<dynamic>.from(barberService!.map((x) => x.toJson())),
    "selectedHairType": selectedHairType?.toJson(),
    "selectedHairLength": selectedHairLength?.toJson(),
    "barberExperience": barberExperience?.toJson(),
    "BarberAvailableHour": barberAvailableHour == null ? [] : List<dynamic>.from(barberAvailableHour!.map((x) => x.toJson())),
  };
}

class BarberAvailableHour {
  final String? id;
  final String? day;
  final String? startTime;
  final String? endTime;
  final String? createdById;

  BarberAvailableHour({this.id, this.day, this.startTime, this.endTime, this.createdById});

  factory BarberAvailableHour.fromJson(Map<String, dynamic> json) =>
      BarberAvailableHour(id: json["id"], day: json["day"], startTime: json["startTime"], endTime: json["endTime"], createdById: json["createdById"]);

  Map<String, dynamic> toJson() => {"id": id, "day": day, "startTime": startTime, "endTime": endTime, "createdById": createdById};
}

class BarberExperience {
  final String? id;
  final String? title;
  final String? description;
  final String? createdById;

  BarberExperience({this.id, this.title, this.description, this.createdById});

  factory BarberExperience.fromJson(Map<String, dynamic> json) =>
      BarberExperience(id: json["id"], title: json["title"], description: json["description"], createdById: json["createdById"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title, "description": description, "createdById": createdById};
}

class BarberService {
  final String? id;
  final String? serviceCategoryId;
  final String? price;
  final String? createdById;
  final ServiceCategory? serviceCategory;

  BarberService({this.id, this.serviceCategoryId, this.price, this.createdById, this.serviceCategory});

  factory BarberService.fromJson(Map<String, dynamic> json) => BarberService(
    id: json["id"],
    serviceCategoryId: json["serviceCategoryId"],
    price: json["price"],
    createdById: json["createdById"],
    serviceCategory: json["serviceCategory"] == null ? null : ServiceCategory.fromJson(json["serviceCategory"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceCategoryId": serviceCategoryId,
    "price": price,
    "createdById": createdById,
    "serviceCategory": serviceCategory?.toJson(),
  };
}

class ServiceCategory {
  final String? id;
  final String? service;
  final String? genderCategory;
  final String? createdById;

  ServiceCategory({this.id, this.service, this.genderCategory, this.createdById});

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(id: json["id"], service: json["service"], genderCategory: json["genderCategory"], createdById: json["createdById"]);

  Map<String, dynamic> toJson() => {"id": id, "service": service, "genderCategory": genderCategory, "createdById": createdById};
}

class SelectedHair {
  final String? id;
  final String? name;
  final String? createdById;

  SelectedHair({this.id, this.name, this.createdById});

  factory SelectedHair.fromJson(Map<String, dynamic> json) => SelectedHair(id: json["id"], name: json["name"], createdById: json["createdById"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "createdById": createdById};
}
