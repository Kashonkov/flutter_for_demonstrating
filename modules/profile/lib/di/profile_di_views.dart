import 'package:auto_route/auto_route.dart';
import 'package:common/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/presentation/edit_profile_bottom_sheet/bloc/edit_profile_cubit.dart';
import 'package:profile/presentation/edit_profile_bottom_sheet/edit_profile_bottom_sheet.dart';
import 'package:profile/presentation/profile_screen/bloc/profile_screen_cubit.dart';
import 'package:profile/presentation/profile_screen/profile_screen_content.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileScreenCubit(
        getProfileStreamUseCase: getIt(),
        updateProfileUseCase: getIt(),
        logoutUseCase: getIt(),
        getAppVersionUseCase: getIt(),
        getAvatarUseCase: getIt(),
        navigator: getIt(),
      ),
      child: ProfileScreenContent(),
    );
  }
}

class EditProfileBottomSheet extends StatelessWidget {
  const EditProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => EditProfileCubit(getIt(), getIt()),
    child: EditProfileBottomSheetContent(),
  );
}
