import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/model/update_profile.dart/profile_update_model.dart';
import 'package:store_app/data/repostories/profile_update_repository.dart';
import 'package:store_app/feature/profile_update/managers/profile_update_event.dart';
import 'package:store_app/feature/profile_update/managers/profile_update_state.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  final ProfileUpdateRepository _repository;
  ProfileUpdateModel? _currentProfile;

  ProfileUpdateBloc(this._repository) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateFullName>(_onUpdateFullName);
    on<UpdateEmail>(_onUpdateEmail);
    on<UpdatePhoneNumber>(_onUpdatePhoneNumber);
    on<UpdateBirthDate>(_onUpdateBirthDate);
    on<UpdateGender>(_onUpdateGender);
    on<ResetProfileState>(_onResetProfileState);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileUpdateState> emit) async {
    emit(const ProfileLoading());
    
    final result = await _repository.getCurrentProfile();
    
    result.fold(
      (error) => emit(ProfileError(error.toString())),
      (profile) {
        _currentProfile = profile;
        emit(ProfileLoaded(profile));
      },
    );
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileUpdateState> emit) async {
    if (_currentProfile == null) return;
    
    emit(ProfileUpdating(_currentProfile!));
    
    final result = await _repository.updateProfile(event.profile);
    
    result.fold(
      (error) => emit(ProfileError(error.toString(), _currentProfile)),
      (profile) {
        _currentProfile = profile;
        emit(ProfileUpdateSuccess(profile));
      },
    );
  }

  void _onUpdateFullName(UpdateFullName event, Emitter<ProfileUpdateState> emit) {
    if (_currentProfile == null) return;
    
    _currentProfile = _currentProfile!.copyWith(fullName: event.fullName);
    emit(ProfileFieldUpdated(_currentProfile!));
  }

  void _onUpdateEmail(UpdateEmail event, Emitter<ProfileUpdateState> emit) {
    if (_currentProfile == null) return;
    
    _currentProfile = _currentProfile!.copyWith(email: event.email);
    emit(ProfileFieldUpdated(_currentProfile!));
  }

  void _onUpdatePhoneNumber(UpdatePhoneNumber event, Emitter<ProfileUpdateState> emit) {
    if (_currentProfile == null) return;
    
    _currentProfile = _currentProfile!.copyWith(phoneNumber: event.phoneNumber);
    emit(ProfileFieldUpdated(_currentProfile!));
  }

  void _onUpdateBirthDate(UpdateBirthDate event, Emitter<ProfileUpdateState> emit) {
    if (_currentProfile == null) return;
    
    _currentProfile = _currentProfile!.copyWith(birthDate: event.birthDate);
    emit(ProfileFieldUpdated(_currentProfile!));
  }

  void _onUpdateGender(UpdateGender event, Emitter<ProfileUpdateState> emit) {
    if (_currentProfile == null) return;
    
    _currentProfile = _currentProfile!.copyWith(gender: event.gender);
    emit(ProfileFieldUpdated(_currentProfile!));
  }

  void _onResetProfileState(ResetProfileState event, Emitter<ProfileUpdateState> emit) {
    if (_currentProfile != null) {
      emit(ProfileLoaded(_currentProfile!));
    }
  }
}