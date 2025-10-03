import 'package:equatable/equatable.dart';
import 'package:store_app/data/model/update_profile.dart/profile_update_model.dart';

abstract class ProfileUpdateEvent extends Equatable {
  const ProfileUpdateEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileUpdateEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileUpdateEvent {
  final ProfileUpdateModel profile;

  const UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UpdateFullName extends ProfileUpdateEvent {
  final String fullName;

  const UpdateFullName(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class UpdateEmail extends ProfileUpdateEvent {
  final String email;

  const UpdateEmail(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdatePhoneNumber extends ProfileUpdateEvent {
  final String phoneNumber;

  const UpdatePhoneNumber(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class UpdateBirthDate extends ProfileUpdateEvent {
  final String birthDate;

  const UpdateBirthDate(this.birthDate);

  @override
  List<Object?> get props => [birthDate];
}

class UpdateGender extends ProfileUpdateEvent {
  final String gender;

  const UpdateGender(this.gender);

  @override
  List<Object?> get props => [gender];
}

class ResetProfileState extends ProfileUpdateEvent {
  const ResetProfileState();
}