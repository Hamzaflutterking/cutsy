// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final bool? success;
  final String? message;
  final Data? data;

  UserModel({this.success, this.message, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(success: json["success"], message: json["message"], data: json["data"] == null ? null : Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson()};
}

class Data {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? password;
  final String? gender;
  final String? selectedHairTypeId;
  final String? selectedHairLengthId;
  // FIXED: doubles
  final double? latitude;
  final double? longitude;
  final String? addressName;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? states;
  final String? country;
  final bool? isCreatedProfile;
  final String? postalCode;
  final String? userType;
  final String? deviceType;
  final String? deviceToken;
  final String? image;
  final String? customerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userToken;

  // NEW: nested hair objects
  final HairOption? selectedHairType;
  final HairOption? selectedHairLength;

  Data({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.password,
    this.gender,
    this.selectedHairTypeId,
    this.selectedHairLengthId,
    this.latitude,
    this.longitude,
    this.addressName,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.states,
    this.country,
    this.isCreatedProfile,
    this.postalCode,
    this.userType,
    this.deviceType,
    this.deviceToken,
    this.image,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.userToken,
    this.selectedHairType,
    this.selectedHairLength,
  });
  // Handy fallbacks
  String? get hairTypeId => selectedHairTypeId ?? selectedHairType?.id;
  String? get hairLengthId => selectedHairLengthId ?? selectedHairLength?.id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    gender: json["gender"],
    selectedHairTypeId: json["selectedHairTypeId"],
    selectedHairLengthId: json["selectedHairLengthId"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    addressName: json["addressName"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    city: json["city"],
    states: json["states"],
    country: json["country"],
    isCreatedProfile: json["isCreatedProfile"],
    postalCode: json["postalCode"],
    userType: json["userType"],
    deviceType: json["deviceType"],
    deviceToken: json["deviceToken"],
    image: json["image"],
    customerId: json["customerId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    userToken: json["userToken"],
    selectedHairType: json["selectedHairType"] == null ? null : HairOption.fromJson(json["selectedHairType"]),
    selectedHairLength: json["selectedHairLength"] == null ? null : HairOption.fromJson(json["selectedHairLength"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "password": password,
    "gender": gender,
    "selectedHairTypeId": selectedHairTypeId,
    "selectedHairLengthId": selectedHairLengthId,
    "latitude": latitude,
    "longitude": longitude,
    "addressName": addressName,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "city": city,
    "states": states,
    "country": country,
    "isCreatedProfile": isCreatedProfile,
    "postalCode": postalCode,
    "userType": userType,
    "deviceType": deviceType,
    "deviceToken": deviceToken,
    "image": image,
    "customerId": customerId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "userToken": userToken,
    "selectedHairType": selectedHairType?.toJson(),
    "selectedHairLength": selectedHairLength?.toJson(),
  };
}

class HairOption {
  final String? id;
  final String? name;
  final String? createdById;

  const HairOption({this.id, this.name, this.createdById});

  /// Accepts:
  /// - null  -> returns empty HairOption
  /// - String (id only) -> HairOption(id: that string)
  /// - Map'<'String, dynamic'>' with id/name/createdById
  factory HairOption.fromJson(dynamic json) {
    if (json == null) return const HairOption();

    if (json is String) {
      // sometimes APIs may just return an ID string
      return HairOption(id: json);
    }

    if (json is Map<String, dynamic>) {
      final rawId = json['id'];
      final rawName = json['name'];
      final rawCreatedById = json['createdById'];

      return HairOption(id: rawId?.toString(), name: rawName?.toString(), createdById: rawCreatedById?.toString());
    }

    // Fallback for unexpected types
    return const HairOption();
  }

  Map<String, dynamic> toJson() => {if (id != null) 'id': id, if (name != null) 'name': name, if (createdById != null) 'createdById': createdById};

  HairOption copyWith({String? id, String? name, String? createdById}) {
    return HairOption(id: id ?? this.id, name: name ?? this.name, createdById: createdById ?? this.createdById);
  }
}
