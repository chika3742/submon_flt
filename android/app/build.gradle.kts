import com.android.build.api.dsl.ApplicationExtension
import java.util.Properties

plugins {
    id("com.android.application")
    id("com.android.built-in-kotlin")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.firebase-perf")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

extensions.configure<ApplicationExtension> {
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            val keyPropertiesFile = rootProject.file("key.properties")
            if (keyPropertiesFile.exists()) {
                val keyProperties = Properties()
                keyPropertiesFile.inputStream().use { keyProperties.load(it) }
                storeFile = rootProject.file(keyProperties["submon.keyStorePath"] as String)
                storePassword = keyProperties["submon.keyStorePassword"] as String
                keyAlias = keyProperties["submon.keyAlias"] as String
                keyPassword = keyProperties["submon.keyPassword"] as String
            }
        }
    }

    sourceSets {
        getByName("main").java.directories += "src/main/kotlin"
    }

    defaultConfig {
        applicationId = "net.chikach.submon"
        minSdk = 24
        compileSdk = 36
        targetSdk = 36
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            manifestPlaceholders["appLinkHostName"] = "submon.app"
            manifestPlaceholders["applicationLabel"] = "Submon"
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
            )
            ndk {
                debugSymbolLevel = "FULL"
            }
        }
        getByName("profile") {
            versionNameSuffix = "-profile"
            manifestPlaceholders["appLinkHostName"] = "dev.submon.app"
            manifestPlaceholders["applicationLabel"] = "[P]Submon"
            applicationIdSuffix = ".debug"
        }
        debug {
            versionNameSuffix = "-debug"
            manifestPlaceholders["appLinkHostName"] = "dev.submon.app"
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

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {}