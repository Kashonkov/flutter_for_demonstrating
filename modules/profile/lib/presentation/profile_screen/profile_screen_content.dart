import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/bloc/bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/di/profile_di_views.dart';
import 'package:profile/domain/entity/avatar_entity.dart';
import 'package:profile/domain/entity/profile_entity.dart';
import 'package:profile/l10n/localization_extension.dart';
import 'package:profile/presentation/avatar_source_dialog/select_avatar_source_bottom_sheet.dart';
import 'package:profile/presentation/profile_screen/bloc/profile_screen_cubit.dart';
import 'package:profile/presentation/profile_screen/bloc/profile_screen_news.dart';
import 'package:profile/presentation/profile_screen/bloc/profile_screen_state.dart';
import 'package:ui_kit/bottom_sheet/ui_bottom_sheet.dart';
import 'package:ui_kit/button/rf_button.dart';
import 'package:ui_kit/index.dart';

class ProfileScreenContent extends StatefulWidget {
  const ProfileScreenContent({super.key});

  @override
  State<ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends StateWithCubit<ProfileScreenCubit, ProfileScreenContent> {
  @override
  void onNewsReceived(BlocNews news) {
    if (news is ShowAvatarSourceSelection) {
      _showSelectAvatarBottomSheet(context);
    } else {
      super.onNewsReceived(news);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 73, bottom: 16),
        child: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
          bloc: bloc,
          builder: (context, state) {
            return switch (state) {
              ProfileScreenLoadingState() => _LoadingFrame(),
              EmptyDataState() => _EmptyDataFrame(
                onOrdersTap: bloc.onOrdersTap,
                onContactTap: bloc.onContactSupportTap,
                onLogoutTap: bloc.onLogoutTap,
                version: state.version,
              ),
              ProfileDataState() => _DataFrame(
                profile: state.profile,
                onSelectAvatarTap: bloc.onSelectAvatarTap,
                onOrdersTap: bloc.onOrdersTap,
                onContactTap: bloc.onContactSupportTap,
                onLogoutTap: bloc.onLogoutTap,
                version: state.version,
              ),
            };
          },
        ),
      ),
    );
  }

  void _showSelectAvatarBottomSheet(BuildContext context) {
    showUiModalBottomSheet(
      context: context,
      builder: (context) => SelectAvatarSourceBottomSheet(
        onSourceSelected: (source) {
          bloc.onAvatarSourceSelected(source);
        },
      ),
    );
  }
}

class _LoadingFrame extends StatelessWidget {
  const _LoadingFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class _EmptyDataFrame extends StatelessWidget {
  final VoidCallback onOrdersTap;
  final VoidCallback onLogoutTap;
  final VoidCallback onContactTap;
  final String? version;

  const _EmptyDataFrame({
    super.key,
    required this.onOrdersTap,
    required this.onLogoutTap,
    required this.onContactTap,
    this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OrdersCard(onTap: onOrdersTap),
        Spacer(),
        _Footer(onLogoutTap: onLogoutTap, onContactTap: onContactTap, version: version),
      ],
    );
  }
}

class _DataFrame extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onSelectAvatarTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onLogoutTap;
  final VoidCallback onContactTap;
  final String? version;

  const _DataFrame({
    super.key,
    required this.profile,
    required this.onSelectAvatarTap,
    required this.onOrdersTap,
    required this.onLogoutTap,
    required this.onContactTap,
    this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(16),
        _Avatar(profile: profile, onSelectAvatarTap: onSelectAvatarTap),
        Gap(10),
        Text(profile.name, style: context.rfTextTheme().body1),
        Gap(4),
        Text(profile.email, style: context.rfTextTheme().body2),
        Gap(16),
        _OrdersCard(onTap: onOrdersTap, ),
        Gap(10),
        _DataCard(profile: profile),
        Spacer(),
        _Footer(onLogoutTap: onLogoutTap, onContactTap: onContactTap, version: version),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onSelectAvatarTap;

  const _Avatar({super.key, required this.profile, required this.onSelectAvatarTap});

  @override
  Widget build(BuildContext context) {
    return
    // Stack(
    // children: [
    // SizedBox(height: 82, width: 87),
    _AvatarContent(profile: profile);
    // Positioned(
    //   bottom: 0,
    //   right: 0,
    //   child: _SelectAvatarBtn(onSelectAvatarTap: onSelectAvatarTap),
    // ),
    // ],
    // );
  }
}

class _AvatarContent extends StatelessWidget {
  final ProfileEntity profile;

  const _AvatarContent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final avatar = profile.avatar;
    if (avatar == null) {
      return _EmptyAvatar(profile: profile);
    }
    return switch (avatar) {
      FileAvatarEntity() => _FileAvatar(profile: profile),
      NetAvatarEntity() => _NetAvatar(profile: profile),
    };
  }
}

class _NetAvatar extends StatefulWidget {
  final ProfileEntity profile;

  const _NetAvatar({super.key, required this.profile});

  @override
  State<_NetAvatar> createState() => _NetAvatarState();
}

class _NetAvatarState extends State<_NetAvatar> {
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    final avatar = widget.profile.avatar as NetAvatarEntity;
    return _isError
        ? _EmptyAvatar(profile: widget.profile)
        : CircleAvatar(
            radius: 40,
            backgroundColor: Colors.transparent,
            foregroundImage: CachedNetworkImageProvider(
              avatar.uri,
              errorListener: (_) {
                setState(() {
                  _isError = true;
                });
              },
            ),
          );
  }
}

class _FileAvatar extends StatelessWidget {
  final ProfileEntity profile;

  const _FileAvatar({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final avatar = profile.avatar as FileAvatarEntity;

    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 40,
      foregroundImage: FileImage(File(avatar.filePath)),
    );
  }
}

class _EmptyAvatar extends StatelessWidget {
  final ProfileEntity profile;

  const _EmptyAvatar({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 40,
      child: _EmptyAvatarContent(profile: profile),
    );
  }
}

class _EmptyAvatarContent extends StatelessWidget {
  final ProfileEntity profile;

  const _EmptyAvatarContent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final raw = profile.name;
    final String source;

    source = raw.substring(0, 1);

    return Text(
      source.toUpperCase(),
      style: context.rfTextTheme().largeTitle.copyWith(color: Colors.black),
    );
  }
}

class _SelectAvatarBtn extends StatelessWidget {
  final VoidCallback onSelectAvatarTap;

  const _SelectAvatarBtn({super.key, required this.onSelectAvatarTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectAvatarTap,
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        shape: CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: UiIcon(UiIcons.camera),
        ),
      ),
    );
  }
}

class _OrdersCard extends StatelessWidget {
  final VoidCallback onTap;

  const _OrdersCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RfCard(
        padding: EdgeInsets.only(right: 16, top: 14, bottom: 14, left: 24 ),
        child: Row(
          spacing: 12,
          children: [
            UiIcon(UiIcons.shoppingBag, size: UiIconSize.medium),
            Expanded(
              child: Text(
                context.loc.myOrders,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.rfTextTheme().body1,
              ),
            ),
            UiIcon(UiIcons.chevronRight, size: UiIconSize.medium,),
          ],
        ),
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final ProfileEntity profile;

  const _DataCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return RfCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          Row(
            children: [
              Text(context.loc.personalInfo, style: context.rfTextTheme().header1),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _showEditBottomSheet(context);
                },
                child: UiIcon(UiIcons.pen),
              ),
            ],
          ),
          _DataItem(iconPath: UiIcons.profile, title: profile.name ?? ""),
          if (profile.phone != null) _DataItem(iconPath: UiIcons.phone, title: profile.phone ?? ""),
          _DataItem(iconPath: UiIcons.mail, title: profile.email ?? ""),
          if (profile.company.isNotEmpty)
            _DataItem(iconPath: UiIcons.group, title: profile.company ?? ""),
        ],
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    showUiModalBottomSheet(context: context, builder: (context) => EditProfileBottomSheet());
  }
}

class _DataItem extends StatelessWidget {
  final String iconPath;
  final String title;

  const _DataItem({super.key, required this.iconPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Row(
        spacing: 12,
        children: [
          UiIcon(iconPath, size: UiIconSize.medium),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.rfTextTheme().body1,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onLogoutTap;

  const _LogoutButton({super.key, required this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    return RfButton(
      type: ButtonType.textButton,
      onPressed: onLogoutTap,
      title: context.loc.logOut.toUpperCase(),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final VoidCallback onContactTap;

  const _SupportItem({super.key, required this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${context.loc.haveQuestions} ",
            style: TextStyle().copyWith(color: Colors.grey),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = () => onContactTap(),
            text: context.loc.contactSupport,
            style: TextStyle().copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onLogoutTap;
  final VoidCallback onContactTap;
  final String? version;

  const _Footer({super.key, required this.onContactTap, required this.onLogoutTap, this.version});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 85,
            child: _LogoutButton(onLogoutTap: onLogoutTap)),
        // Gap(10),
        // _SupportItem(onContactTap: onContactTap),
        if (version != null) ...[Gap(20), Text("v $version", style: context.rfTextTheme().body2)],
      ],
    );
  }
}
