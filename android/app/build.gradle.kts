plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

apply(plugin = "com.google.gms.google-services")



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
        versionCode = 10
        versionName = "1.0.8"

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
            isMinifyEnabled = false // Disabilitiamo R8
            isShrinkResources = false // Disabilitiamo la rimozione delle risorse inutilizzate
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    implementation("com.google.android.ump:user-messaging-platform:2.1.0")
    implementation("com.google.android.gms:play-services-base:18.3.0")
    implementation("com.google.android.gms:play-services-basement:18.3.0")
}

flutter {
    source = "../.."
}
