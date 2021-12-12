import 'package:flutter/material.dart';
import 'package:submon/components/list_tile.dart';

class SettingsListView extends StatelessWidget {
  const SettingsListView({Key? key, required this.categories})
      : super(key: key);

  final List<SettingsCategory> categories;

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];

    for (var element in categories) {
      list.add(CategoryListTile(element.title));

      list.addAll(element.tiles.map((e) => e.buildWidget()));
    }

    return Material(
      child: ListView(
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
  Widget buildWidget();
}

class SettingsTile extends AbstractSettingsTile {
  SettingsTile(
      {this.title,
      this.titleTextStyle,
      this.subtitle,
      this.leading,
      this.onTap});

  final String? title;
  final TextStyle? titleTextStyle;
  final String? subtitle;
  final Widget? leading;
  final void Function()? onTap;

  @override
  Widget buildWidget() {
    return ListTile(
      title: title != null ? Text(title!, style: titleTextStyle) : null,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: leading,
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
  Widget buildWidget() {
    return SwitchListTile(
      title: title != null ? Text(title!) : null,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: onChanged,
    );
  }
}
