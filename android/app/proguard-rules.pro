# Flutter specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class com.example.gamestore.** { *; }

# Play Core (split install) - used by Flutter for deferred components
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Keep annotations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# flutter_map
-keep class org.xml.sax.** { *; }
-keep class android.graphics.** { *; }
-dontwarn org.xml.sax.**
-dontwarn com.jhlabs.**

# mailer (SMTP)
-keep class javax.mail.** { *; }
-keep class com.sun.mail.** { *; }
-dontwarn javax.mail.**
-dontwarn com.sun.mail.**

# latlong2
-keep class com.latlong.** { *; }

# Keep all native methods and JNI
-keepclasseswithmembernames class * {
    native <methods>;
}
