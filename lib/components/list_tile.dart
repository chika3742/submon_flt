import 'package:flutter/material.dart';

class SimpleListTile extends StatelessWidget {
  const SimpleListTile(
      {Key? key, required this.title, this.onTap, this.leadingIcon})
      : super(key: key);

  final String? title;
  final Widget? leadingIcon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    assert(title != null);
    return ListTile(
      title: Text(title!),
      onTap: onTap,
      leading: leadingIcon,
    );
  }
}

class CategoryListTile extends StatelessWidget {
  const CategoryListTile(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 4),
    );
  }
}
