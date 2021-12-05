import 'package:flutter/material.dart';

class SimpleListTile extends StatelessWidget {
  const SimpleListTile({Key? key, required this.title, this.onTap})
      : super(key: key);

  final String? title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    assert(title != null);
    return ListTile(
      title: Text(title!),
      onTap: onTap,
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
        style: const TextStyle(color: Colors.pink),
      ),
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 4),
    );
  }
}
