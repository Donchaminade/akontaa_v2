plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.akontaa"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        // ✅ Syntaxe Kotlin correcte pour le desugaring
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.akontaa"
        minSdk = 21 // ⚠️ Mets au moins 21 si flutter.minSdkVersion < 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Syntaxe Kotlin correcte
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

}
