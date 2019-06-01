#!/bin/sh
SDK=/opt/android-sdk/
BUILD_TOOLS="${SDK}/build-tools/27.0.3"
PLATFORM="${SDK}/platforms/android-21"
"${BUILD_TOOLS}/aapt" package -f -m -J build/gen/ -S res -M AndroidManifest.xml -I "${PLATFORM}/android.jar" 
javac -source 1.7 -target 1.7 -bootclasspath "${JAVA_HOME}/jre/lib/rt.jar" -classpath "${PLATFORM}/android.jar" -d build/obj build/gen/com/bala/manualcount/R.java java/com/bala/manualcount/MainActivity.java
"${BUILD_TOOLS}/dx" --dex --output=build/apk/classes.dex build/obj/ 
"${BUILD_TOOLS}/aapt" package -f -M AndroidManifest.xml -S res/ -I "${PLATFORM}/android.jar" -F build/ManualCount.unsigned.apk build/apk/
"${BUILD_TOOLS}/zipalign" -f -p 4 build/ManualCount.unsigned.apk build/ManualCount.aligned.apk
"${BUILD_TOOLS}/apksigner" sign --ks keystore.jks --ks-key-alias androidkey --ks-pass pass:android --key-pass pass:android --out build/ManualCount.apk build/ManualCount.aligned.apk
"${SDK}/platform-tools/adb" install -r "build/ManualCount.apk"
"${SDK}/platform-tools/adb" shell am start -n com.bala.manualcount/.MainActivity
