import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:store_app/data/model/update_profile.dart/profile_update_model.dart';
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/profile_update/managers/profile_update_bloc.dart';
import 'package:store_app/feature/profile_update/managers/profile_update_event.dart';
import 'package:store_app/feature/profile_update/managers/profile_update_state.dart';
import 'package:store_app/feature/profile_update/widgets/profile_date_feild.dart' show ProfileDateField;
import 'package:store_app/feature/profile_update/widgets/profile_drodown_field.dart' show ProfileDropdownField;
import 'package:store_app/feature/profile_update/widgets/profile_photo_detail.dart' show ProfilePhoneField;
import 'package:store_app/feature/profile_update/widgets/profile_update_widget.dart' show ProfileTextField;

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  String _selectedGender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    context.read<ProfileUpdateBloc>().add(const LoadProfile());
  }

  void _updateControllers(ProfileUpdateModel profile) {
    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
    _birthDateController.text = profile.birthDate;
    _selectedGender = profile.gender.isNotEmpty ? profile.gender : 'Male';
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      _birthDateController.text = formattedDate;
      context.read<ProfileUpdateBloc>().add(UpdateBirthDate(formattedDate));
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final profile = ProfileUpdateModel(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        birthDate: _birthDateController.text,
        gender: _selectedGender,
      );
      context.read<ProfileUpdateBloc>().add(UpdateProfile(profile));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(
        title: "My Details",
        arrow: "assets/arrow.png",
        first: "assets/notifaction.png",
      ),
      body: BlocConsumer<ProfileUpdateBloc, ProfileUpdateState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          ProfileUpdateModel? profile;
          if (state is ProfileLoaded) profile = state.profile;
          if (state is ProfileFieldUpdated) profile = state.profile;
          if (state is ProfileUpdateSuccess) profile = state.profile;
          if (state is ProfileUpdating) profile = state.currentProfile;

          if (profile != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateControllers(profile!);
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileTextField(
                    label: 'Full Name',
                    controller: _fullNameController,
                    hint: 'Enter your full name',
                    onChanged: (v) => context.read<ProfileUpdateBloc>().add(UpdateFullName(v)),
                  ),
                  const SizedBox(height: 20),
                  ProfileTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    onChanged: (v) => context.read<ProfileUpdateBloc>().add(UpdateEmail(v)),
                  ),
                  const SizedBox(height: 20),
                  ProfileDateField(
                    controller: _birthDateController,
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 20),
                  ProfileDropdownField(
                    label: 'Gender',
                    value: _selectedGender,
                    items: _genderOptions,
                    onChanged: (v) {
                      setState(() => _selectedGender = v);
                      context.read<ProfileUpdateBloc>().add(UpdateGender(v));
                    },
                  ),
                  const SizedBox(height: 20),
                  ProfilePhoneField(
                    controller: _phoneController,
                    onChanged: (v) => context.read<ProfileUpdateBloc>().add(UpdatePhoneNumber(v)),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is ProfileUpdating ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state is ProfileUpdating
                          ? const CircularProgressIndicator(color: Colors.white)
                          :  Text(
                              'Submit',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigatorNews()
    );
  }
}
