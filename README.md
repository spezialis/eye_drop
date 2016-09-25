# Drop Eye
![alt tag](https://raw.githubusercontent.com/spezialis/Drop_Eye/master/Processus/Eye_Drop.jpg)
Eye Drop is a set of bottles containing a digital liquid made of shiny particles, that you can shake and play with, the fluidity make it feel real. Eye Drop uses a Huawei smartwatch and a lens from Google Cardboard to give an impression of immersive screen. 
We took existing codes from Daniel Erickson and Daniel Schiffman that we modified.

![alt tag](https://raw.githubusercontent.com/spezialis/Drop_Eye/master/Processus/Bottle_inside.gif)

This projet took part of the Milano Design Week Fuorisalone on 2016 at the "When object dreams" exhibition made by [ECAL - Ecole Cantonale d'Art de Lausanne](http://www.ecal.ch/fr/100/homepage).

A video demonstration can be viewed [here](https://www.youtube.com/watch?v=5UhNIojhL8o).

## Processing coding:
For each code we tested, there's one version in Java to execute on Processing PDE with the Java Mode. And one version to use with the Android Mode that will build an android application inside the smartwatch via USB or bluetooth.
For installing the Android Mode for Processing check [here](https://github.com/processing/processing-android/wiki). It's important to have installed the Android SDK.
We also use the [Ketai Library](http://ketai.org/) for Processing which helped us to develop and build all application for android.

Some screencast of some applications:
![alt tag](https://raw.githubusercontent.com/spezialis/Drop_Eye/master/Processus/Gifs/Fluid.gif)
![alt tag](https://raw.githubusercontent.com/spezialis/Drop_Eye/master/Processus/Gifs/Particle.gif)
![alt tag](https://raw.githubusercontent.com/spezialis/Drop_Eye/master/Processus/Gifs/Rotate.gif)
![alt tag](https://raw.githubusercontent.com/spezialis/Drop_Eye/master/Processus/Gifs/Snap.gif)

## Android Wear Debug inside the Terminal:
- adb commands:
```
adb help
```

- Check inside the terminal which Android device is/are connected:
```
adb devices
```

### Connect the Android Wear via bluetooth:
Use an Android mobile connected via an USB cable to the computer, run the [Android Wear - Smartwatch](https://play.google.com/store/apps/details?id=com.google.android.wearable.app) app, the watch and the mobile need to be connected using the app. Then run on the Terminal these commands:
```
adb forward tcp:4444 localabstract:/adb-hub
adb connect 127.0.0.1:4444
```

If it doesn't work try:

```
adb -connect localhost:4444
```

- If the host and the target are connected on the Android Wear mobile app:
```
Host: connected
Target: connected
```

- Reboot the Android Wear:
```
adb -s 127.0.0.1:4444 reboot
```

If it doesn't work try:
```
adb -s localhost:4444 reboot
```

- Install APK (this is an exemple):
```
adb -s install -r /private/var/folders/0q/mnmr2rb14273d107szplrrw80000gn/T/android6712214751317668388sketch/bin/APPLICATION-debug.apk
```

- To find the APKs location, find the builded apk and use the APPLICATION-debug.apk (APPLICATION = name of the app):
```
cd ../
cd var
open .
```
This is an exemple where to locate the builded apk
```
/private/var/folders/0q/mnmr2rb14273d107szplrrw80000gn/T
```

- Unistall APK:
```
adb -s 127.0.0.1:4444 uninstall processing.test.application
```


### Connect the Android Wear via USB cable:

- Unistall APK (application = name of the app on lowercase):
```
adb -d uninstall processing.test.application
```

- Install APK (APPLICATION = name of the app):
```
adb -d install -r APPLICATION.apk
```

- Reboot the watch:
```
adb -d reboot
```

### Credits
####Students in media & interaction design
[Charlotte Broccard](http://charlottebroccard.ch/) &
[Stella Speziali](http://stellaspeziali.ch/)

####Assistant
[Romain Cazier](http://romaincazier.com/)

[ECAL](http://www.ecal.ch/fr/100/homepage) - Ecole cantonale d'art de Lausanne


