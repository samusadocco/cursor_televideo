plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}



android {
    namespace = "it.codebysam.televideo"
    compileSdk = 35 // Necessario per le librerie AndroidX
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "it.codebysam.televideo"
        minSdk = flutter.minSdkVersion
        targetSdk = 35 // Manteniamo Android 14 come target
        versionCode = 4
        versionName = "1.0.2"

        // Disabilita i componenti differiti
        manifestPlaceholders["enableDeferredComponents"] = "false"
    }

    signingConfigs {
        create("release") {
            storeFile = file("upload-keystore.jks")
            storePassword = "televideo"
            keyAlias = "upload"
            keyPassword = "televideo"
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
