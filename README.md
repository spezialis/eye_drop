## Drop_Eye

## Concept:
Eye Drop is a set of bottles containing a digital liquid made of shiny particles, that you can shake and play with, the fluidity make it feel reel. Eye drop uses a Huawei smart watch and a magnifying glass from Google Cardboard to give an impression of immersive screen. 
We took existing code from Daniel Erickson and Daniel Schiffman that we modified.

This projet took part of the Milano Design Week Fuorisalone on 2016 at the "When object dreams" exhibition made by ECAL - Ecole Cantonale d'Art de Lausanne
Check the site for some more infos about our school:
http://ecal.ch/fr/100/homepage

## Processing coding:
For each code there is one version in java for execute on Processing with the Java Mode. And one version with the Android Mode to build the application inside the smartwatch via USB or bluetooth.
For installing the Android Mode for Processing check this github:
https://github.com/processing/processing-android/wiki

## Android Wear Debug inside the Terminal:
//Check inside the terminal which Android device is/are connected:
adb devices

//Connect Android Wear via bluetooth:
adb forward tcp:4444 localabstract:/adb-hub

adb connect 127.0.0.1:4444
adb -connect localhost:4444

//If the host and the target are connecte on the mobile:
Host: connected
Target: connected

//Reboot the Android Wear on the terminal:
adb -s 127.0.0.1:4444 reboot
adb -s localhost:4444 reboot

//First find the APKs location, find the last apk builded and use the APPLICATION-debug.apk (APPLICATION = name of the app):
cd ../
cd var
open .
/private/var/folders/0q/mnmr2rb14273d107szplrrw80000gn/T

//Install APK over bluetooth (this is an exemple):
adb -e install -r /private/var/folders/0q/mnmr2rb14273d107szplrrw80000gn/T/android6712214751317668388sketch/bin/Romain-debug-unaligned.apk

//Unistall APK over bluetooth:
adb -s 127.0.0.1:4444 uninstall

//Unistall APK  over USB cable (application = name of the app on minuscule):
adb -s uninstall processing.test.application

//Install APK over USB cable (APPLICATION = name of the app):
adb -e install -r APPLICATION.apk
