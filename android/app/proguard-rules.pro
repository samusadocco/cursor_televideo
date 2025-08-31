# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Geocoding
-keep class com.google.android.gms.location.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.common.annotation.** { *; }

# Keep your application class
-keep class it.codebysam.televideo.** { *; }

# Play Core
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.*.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.review.** { *; }
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.assetpacks.** { *; }
-keep class com.google.android.play.core.common.** { *; }
-keep class com.google.android.play.core.install.** { *; }
-keep class com.google.android.play.core.listener.** { *; }
-keep class com.google.android.play.core.missingsplits.** { *; }
-keep class com.google.android.play.core.splitinstall.model.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.ktx.** { *; }

# Keep R8 rules
-keepattributes SourceFile,LineNumberTable
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exception

# Keep entry points
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep parcelables
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep R classes
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Keep all classes that might be used by Flutter
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * extends io.flutter.embedding.engine.plugins.activity.ActivityAware { *; }
-keep class * extends io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter { *; }
-keep class * extends io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry { *; }
-keep class * extends io.flutter.plugin.common.PluginRegistry$Registrar { *; }
-keep class * extends io.flutter.plugin.platform.PlatformViewFactory { *; }
-keep class * extends io.flutter.plugin.platform.PlatformView { *; }
-keep class * extends io.flutter.view.TextureRegistry$SurfaceTextureEntry { *; }
-keep class * extends io.flutter.view.FlutterView { *; }
-keep class * extends io.flutter.view.FlutterNativeView { *; }
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }
-keep class * extends io.flutter.embedding.android.FlutterFragment { *; }
-keep class * extends io.flutter.embedding.android.FlutterView { *; }
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.EventChannel$StreamHandler { *; }
-keep class * extends io.flutter.plugin.common.BasicMessageChannel$MessageHandler { *; }
-keep class * extends io.flutter.plugin.common.StandardMessageCodec { *; }
-keep class * extends io.flutter.plugin.common.StandardMethodCodec { *; }
-keep class * extends io.flutter.plugin.common.JSONMethodCodec { *; }
-keep class * extends io.flutter.plugin.common.StringCodec { *; }
-keep class * extends io.flutter.plugin.common.BinaryCodec { *; } 

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task