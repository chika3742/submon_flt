flutter pub run pigeon \
  --input pigeons/messages.dart \
  --dart_out lib/messages.dart \
  --objc_header_out ios/Runner/messages.h \
  --objc_source_out ios/Runner/messages.m \
  --objc_prefix FLT \
  --java_out android/app/src/main/java/net/chikach/submon/Messages.java \
  --java_package "net.chikach.submon"
