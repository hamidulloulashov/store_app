import 'package:equatable/equatable.dart';
import 'package:store_app/data/model/update_profile.dart/profile_update_model.dart';

abstract class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileUpdateState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileUpdateState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileUpdateState {
  final ProfileUpdateModel profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdating extends ProfileUpdateState {
  final ProfileUpdateModel currentProfile;

  const ProfileUpdating(this.currentProfile);

  @override
  List<Object?> get props => [currentProfile];
}

class ProfileUpdateSuccess extends ProfileUpdateState {
  final ProfileUpdateModel profile;

  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileUpdateState {
  final String message;
  final ProfileUpdateModel? currentProfile;

  const ProfileError(this.message, [this.currentProfile]);

  @override
  List<Object?> get props => [message, currentProfile];
}

class ProfileFieldUpdated extends ProfileUpdateState {
  final ProfileUpdateModel profile;

  const ProfileFieldUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}