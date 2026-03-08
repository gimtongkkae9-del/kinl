[app]
title = Kinl
package.name = com.kinl.executor.papaya
source.dir = ./
version.market = 0.1
requirements = python3,kivy
orientation = portrait
product.icon = icon.png

[buildozer]
log_level = 2
warn_on_root = 1

[app]
# Android project
# Debug mode: 1, Release mode: 0
release.mode = 0

# Permissions
android.permissions = INTERNET, WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE

# Include additional libraries
# Adds my_engine.so to the APK
android.include_libs = my_engine.so

# iOS support
ios.kivy_ios = true
