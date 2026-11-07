import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:profile/domain/entity/avatar_source.dart';
import 'package:profile/l10n/localization_extension.dart';

typedef OnSourceSelected = Function(AvatarSource source);

class SelectAvatarSourceBottomSheet extends StatelessWidget {
  final OnSourceSelected onSourceSelected;

  const SelectAvatarSourceBottomSheet({super.key, required this.onSourceSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AvatarSource.values
          .map(
            (value) => _SelectItem(
              onTap: (source) {
                AutoRouter.of(context).pop();
                onSourceSelected(source);
              },
              source: value,
            ),
          )
          .toList(),
    );
  }
}

class _SelectItem extends StatelessWidget {
  final AvatarSource source;
  final OnSourceSelected onTap;

  const _SelectItem({super.key, required this.onTap, required this.source});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(source),
      child: Container(
          width: double.maxFinite,
          height: 48,
          alignment: Alignment.centerLeft,
          child: Text(_mapSourceName(context, source))),
    );
  }

  String _mapSourceName(BuildContext context, AvatarSource source) {
    return switch (source) {
      AvatarSource.gallery => context.loc.gallery,
      AvatarSource.camera => context.loc.photo,
    };
  }
}
