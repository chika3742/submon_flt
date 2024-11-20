import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            if (localProperties.containsKey("submon.keyStorePath")) {
                storeFile = file(localProperties.getProperty("submon.keyStorePath"))
                storePassword = localProperties.getProperty("submon.keyStorePassword")
                keyAlias = localProperties.getProperty("submon.keyAlias")
                keyPassword = localProperties.getProperty("submon.keyPassword")
            }
        }
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "net.chikach.submon"
        minSdk = 24
        compileSdk = 34
        targetSdk = 34
        versionCode = flutterVersionCode
        versionName = flutterVersionName

        ndk {
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a", "x86_64"))
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            manifestPlaceholders["appLinkHostName"] = "open.submon.app"
            manifestPlaceholders["applicationLabel"] = "Submon"
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            ndk {
                debugSymbolLevel = "FULL"
            }
        }
        getByName("profile") {
            versionNameSuffix = "-profile"
            manifestPlaceholders["appLinkHostName"] = "dev.open.submon.app"
            manifestPlaceholders["applicationLabel"] = "[P]Submon"
            applicationIdSuffix = ".debug"
        }
        getByName("debug") {
            versionNameSuffix = "-debug"
            manifestPlaceholders["appLinkHostName"] = "dev.open.submon.app"
            manifestPlaceholders["applicationLabel"] = "[D]Submon"
            applicationIdSuffix = ".debug"
        }
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }
    namespace = "net.chikach.submon"
}

flutter {
    source = "../.."
}

dependencies {
}
