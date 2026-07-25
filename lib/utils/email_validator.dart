String? emailValidator(String? value) {
  if (value == null || value.isEmpty) return "入力してください";

  final regex = RegExp("^[a-zA-Z0-9.!#\$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");
  return regex.hasMatch(value) ? null : "メールアドレスの形式が正しくありません";
}
