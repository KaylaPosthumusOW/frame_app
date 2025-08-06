import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';

enum UserRole { user, admin }

class AppUserProfile extends Equatable {
  final String? uid;
  final String? name;
  final String? surname;
  final String? email;
  final String? phoneNumber;
  final String? pushToken;
  final String? profilePicture;
  final Timestamp? createdAt;
  final UserRole? role;

  const AppUserProfile({this.uid, this.name, this.surname, this.email, this.phoneNumber, this.pushToken, this.profilePicture, this.createdAt, this.role});

  @override
  List<Object?> get props => [uid, name, surname, email, phoneNumber, pushToken, profilePicture, createdAt, role];

  bool get isProfileComplete => !StringHelpers.isNullOrEmpty(name) && !StringHelpers.isNullOrEmpty(surname) && !StringHelpers.isNullOrEmpty(email) && !StringHelpers.isNullOrEmpty(phoneNumber);

  factory AppUserProfile.fromAuthProviderUserDetails(AuthProviderUserDetails authProviderUserDetails) => AppUserProfile(
        uid: authProviderUserDetails.uid,
        email: authProviderUserDetails.email,
        name: authProviderUserDetails.name,
        surname: authProviderUserDetails.surname,
        createdAt: authProviderUserDetails.createdAt,
      );

  AppUserProfile copyWith({
    String? uid,
    String? name,
    String? surname,
    String? email,
    String? phoneNumber,
    String? pushToken,
    String? profilePicture,
    Timestamp? createdAt,
    UserRole? role,
  }) {
    return AppUserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pushToken: pushToken ?? this.pushToken,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
    );
  }

  AppUserProfile copyWithNull({
    String? uid,
    String? name,
    String? surname,
    String? email,
    String? phoneNumber,
    String? pushToken,
    String? profilePicture,
    Timestamp? createdAt,
  }) {
    return AppUserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pushToken: pushToken ?? this.pushToken,
      profilePicture: profilePicture,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap({bool timeStampSafe = false}) {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'email': email,
      'phoneNumber': phoneNumber,
      'pushToken': pushToken,
      'profilePicture': profilePicture,
      'createdAt': timeStampSafe ? createdAt?.toDate().toIso8601String() : createdAt,
      'role': role?.name,
    };
  }

  factory AppUserProfile.fromMap(Map<String, dynamic> map, {bool timeStampSafe = false}) {
    var createdAt = map['createdAt'];
    if (createdAt != null) {
      if (createdAt is String) {
        createdAt = Timestamp.fromDate(DateTime.parse(map['createdAt']));
      }

      if (createdAt is int) {
        createdAt = Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(map['createdAt']));
      }
    } else {
      createdAt = createdAt;
    }

    return AppUserProfile(
      uid: map['uid'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      pushToken: map['pushToken'],
      profilePicture: map['profilePicture'],
      createdAt: createdAt,
      role: map['role'] != null ? UserRole.values.firstWhere((e) => e.name == map['role']) : null,
    );
  }
}
