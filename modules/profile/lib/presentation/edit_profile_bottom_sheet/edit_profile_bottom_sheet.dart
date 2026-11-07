import 'package:auto_route/auto_route.dart';
import 'package:common/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:profile/l10n/localization_extension.dart';
import 'package:profile/presentation/edit_profile_bottom_sheet/bloc/edit_profile_cubit.dart';
import 'package:profile/presentation/edit_profile_bottom_sheet/bloc/edit_profile_news.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/index.dart';

class EditProfileBottomSheetContent extends StatefulWidget {
  const EditProfileBottomSheetContent({super.key});

  @override
  State<EditProfileBottomSheetContent> createState() => _EditProfileBottomSheetContentState();
}

class _EditProfileBottomSheetContentState
    extends StateWithCubit<EditProfileCubit, EditProfileBottomSheetContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  void onNewsReceived(BlocNews news) {
    if (news is SetProfileDataNews) {
      _nameController.text = news.name ?? "";
      _phoneController.text = news.phone ?? "";
      _emailController.text = news.email ?? "";
      _companyController.text = news.company ?? "";
    } else if (news is NavigateBackNews) {
      AutoRouter.of(context).pop();
    } else {
      super.onNewsReceived(news);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.loc.editPersonalInfo, style: context.rfTextTheme().header1,),
        Gap(16),
        RfTextField(controller: _nameController, label: context.loc.name),
        Gap(12),
        RfTextField(controller: _phoneController, label: context.loc.phoneNumber),
        Gap(12),
        RfTextField(controller: _emailController, label: context.loc.email, isEnabled: false),
        Gap(12),
        RfTextField(controller: _companyController, label: context.loc.company),
        Gap(16),
        Row(
          children: [
            RfButton(
              type: ButtonType.secondary,
              size: ButtonSize.medium,
              title: context.loc.cancel.toUpperCase(),
              isInsideRowOrFlex: true,
              onPressed: () => AutoRouter.of(context).pop(),
            ),
            Gap(12),
            RfButton(
              type: ButtonType.primary,
              size: ButtonSize.medium,
              title: context.loc.save.toUpperCase(),
              isInsideRowOrFlex: true,
              onPressed: () => bloc.onSaveTap(
                name: _nameController.text,
                phone: _phoneController.text,
                company: _companyController.text,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
