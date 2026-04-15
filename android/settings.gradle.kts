pluginManagement {
    val flutterSdkPath = java.util.Properties().apply {
        file("local.properties").inputStream().use { load(it) }
    }.getProperty("flutter.sdk") ?: error("flutter.sdk not set in local.properties")

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.0" apply false
    id("com.android.built-in-kotlin") version "9.1.0" apply false
    id("com.google.gms.google-services") version "4.4.4" apply false
    id("com.google.firebase.firebase-perf") version "2.0.2" apply false
    id("com.google.firebase.crashlytics") version "3.0.7" apply false
}

rootProject.name = "submon_flt_android"

include(":app")
