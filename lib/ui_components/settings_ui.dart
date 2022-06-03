import 'package:flutter/material.dart';
import 'package:submon/ui_components/list_tile.dart';

class SettingsListView extends StatelessWidget {
  const SettingsListView(
      {Key? key, required this.categories, this.shrinkWrap = false})
      : super(key: key);

  final List<SettingsCategory> categories;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];

    for (var element in categories) {
      list.add(CategoryListTile(element.title));

      list.addAll(element.tiles.map((e) => e.buildWidget(context)));
    }

    return Scrollbar(
      child: ListView(
        shrinkWrap: shrinkWrap,
        children: list,
      ),
    );
  }
}

class SettingsCategory {
  SettingsCategory({required this.title, required this.tiles});

  final String title;
  final List<AbstractSettingsTile> tiles;
}

abstract class AbstractSettingsTile {
  Widget buildWidget(BuildContext context);
}

class SettingsTile extends AbstractSettingsTile {
  SettingsTile(
      {this.title,
      this.titleTextStyle,
      this.subtitle,
      this.enabled = true,
      this.leading,
      this.trailing,
      this.onTap});

  final String? title;
  final TextStyle? titleTextStyle;
  final String? subtitle;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget buildWidget(BuildContext context) {
    return ListTile(
      title: title != null ? Text(title!, style: titleTextStyle) : null,
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(height: 1.5))
          : null,
      enabled: enabled,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class SwitchSettingsTile extends AbstractSettingsTile {
  SwitchSettingsTile(
      {this.title,
      this.subtitle,
      required this.value,
      required this.onChanged});

  final String? title;
  final String? subtitle;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget buildWidget(BuildContext context) {
    return SwitchListTile(
      title: title != null ? Text(title!) : null,
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(height: 1.5))
          : null,
      value: value,
      onChanged: onChanged,
    );
  }
}

class CheckBoxSettingsTile extends AbstractSettingsTile {
  CheckBoxSettingsTile(
      {this.title,
      this.subtitle,
      required this.value,
      required this.onChanged});

  final String? title;
  final String? subtitle;
  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget buildWidget(BuildContext context) {
    return CheckboxListTile(
      title: title != null ? Text(title!) : null,
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(height: 1.5))
          : null,
      value: value,
      onChanged: onChanged,
    );
  }
}

class RadioSettingsTile extends AbstractSettingsTile {
  RadioSettingsTile({
    this.title,
    this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String? title;
  final String? subtitle;
  final Object value;
  final Object groupValue;
  final void Function(Object?) onChanged;

  @override
  Widget buildWidget(BuildContext context) {
    return RadioListTile(
      title: title != null ? Text(title!) : null,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
