import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:must_invest_service_man/core/extensions/is_logged_in.dart';
import 'package:must_invest_service_man/core/extensions/num_extension.dart';
import 'package:must_invest_service_man/core/extensions/theme_extension.dart';
import 'package:must_invest_service_man/core/extensions/widget_extensions.dart';
import 'package:must_invest_service_man/core/services/di.dart';
import 'package:must_invest_service_man/core/static/icons.dart';
import 'package:must_invest_service_man/core/theme/colors.dart';
import 'package:must_invest_service_man/core/translations/locale_keys.g.dart';
import 'package:must_invest_service_man/core/utils/dialogs/error_toast.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_back_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_elevated_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/buttons/custom_icon_button.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/custom_form_field.dart';
import 'package:must_invest_service_man/core/utils/widgets/inputs/image_picker_avatar.dart';
import 'package:must_invest_service_man/features/profile/data/models/update_profile_params.dart';
import 'package:must_invest_service_man/features/profile/presentation/cubit/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  PlatformFile? selectedImage;

  // Text editing controllers
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    final user = context.user;
    _fullNameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    // Dispose controllers
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateProfile(ProfileCubit cubit) {
    if (_formKey.currentState!.validate()) {
      final params = UpdateProfileParams(name: _fullNameController.text.trim(), image: selectedImage);

      cubit.updateProfile(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(sl()),
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(),
                    Text(LocaleKeys.edit_profile.tr(), style: context.titleLarge.copyWith()),
                    CustomIconButton(
                      color: Color(0xffEAEAF3),
                      iconColor: AppColors.primary,
                      iconAsset: AppIcons.qrCodeIc,
                      onPressed: () {},
                    ),
                  ],
                ),
                40.gap,

                // Profile Image Section
                ImagePickerAvatar(
                  initialImage: '',
                  pickedImage: selectedImage,
                  onPick: (image) {
                    setState(() {
                      selectedImage = image;
                    });
                  },
                ),
                28.gap,

                // Name Field
                CustomTextFormField(
                  controller: _fullNameController,
                  margin: 0,
                  hint: LocaleKeys.full_name.tr(),
                  title: LocaleKeys.full_name.tr(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.name_required.tr();
                    }
                    return null;
                  },
                ),
                16.gap,

                // Phone Field (Read-only)
                CustomTextFormField(
                  controller: _phoneController,
                  margin: 0,
                  hint: LocaleKeys.phone_number.tr(),
                  title: LocaleKeys.phone_number.tr(),
                  readonly: true,
                  disabled: true,
                ),
              ],
            ).paddingHorizontal(24),
          ),
        ),
        bottomNavigationBar: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              // Update the current user in the app
              context.setCurrentUser(state.user);
              showSuccessToast(context, LocaleKeys.profile_updated_successfully.tr());
              context.pop();
            } else if (state is UpdateProfileError) {
              showErrorToast(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is UpdateProfileLoading;

            return Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    heroTag: 'cancel',
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              context.pop();
                            },
                    title: LocaleKeys.cancel.tr(),
                    backgroundColor: Color(0xffF4F4FA),
                    textColor: AppColors.primary.withValues(alpha: 0.5),
                    isBordered: false,
                  ),
                ),
                16.gap,
                Expanded(
                  child: CustomElevatedButton(
                    loading: isLoading,
                    heroTag: 'save',
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              _updateProfile(context.read<ProfileCubit>());
                            },
                    title: LocaleKeys.save.tr(),
                  ),
                ),
              ],
            ).paddingAll(30);
          },
        ),
      ),
    );
  }
}
