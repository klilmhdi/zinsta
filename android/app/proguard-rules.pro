# Add these rules to your proguard-rules.pro file
-keep class java.beans.** { *; }
-keep class org.w3c.dom.bootstrap.** { *; }

# Jackson Databind rules
-keep class com.fasterxml.jackson.databind.** { *; }

# JavaBeans classes
-keep class java.beans.** { *; }

# DOM classes
-keep class org.w3c.dom.** { *; }
-keep class org.w3c.dom.bootstrap.** { *; }

# Keep annotations
-keepattributes *Annotation*, Signature, InnerClasses

# General rules
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses

# Disable Java 7 support module in Jackson
-dontwarn com.fasterxml.jackson.databind.ext.Java7Support
-dontwarn com.fasterxml.jackson.databind.ext.Java7SupportImpl