plugins {
    id("com.android.application")
    id("kotlin-android")
    // Der Flutter‑Gradle‑Plugin muss nach Android & Kotlin kommen
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.learnify_prototype"

    compileSdk = 35
    ndkVersion = "27.0.12077973"         

    defaultConfig {
        applicationId = "com.example.learnify_prototype"

        minSdk = 23                      
        targetSdk = 35

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

    buildTypes {
        release {
            // Signing‑Config nur Beispiel
            signingConfig = signingConfigs.getByName("debug")
            // Optional: minifyEnabled, shrinkResources, …
        }
    }
}

flutter {
    source = "../.."
}
