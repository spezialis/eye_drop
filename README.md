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

## Find the path/location of an APKs (or drag and drop the file on the Terminal):
```
cd /path
```

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

- If the host and the target are connected on the Android Wear mobile app, you should see:
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

- Install APK:
```
adb -s install -r [nameOfApplication].apk
```

- Unistall APK:
```
adb -s 127.0.0.1:4444 uninstall [packageName]
```

- List all packages installed on the device:
```
adb -s 127.0.0.1:4444 shell pm list packages
```

- Lauch application directly on the device:
```
adb -s 127.0.0.1:4444 shell am start -n [packageName]/[.activityName]
```

<<<<<<< HEAD
- To find the activityName data check the AndroidManifest.xml of the app you want to launch. Here a schematized structure with only the field we are interested in:
```html
<manifest package="com.example.project" . . . >
    <application . . . >
        <activity android:name=".ExampleActivity" . . . >
            . . .
        </activity>
        . . .
    </application>
</manifest>
```

=======
>>>>>>> 25b7bb54b32cd2d7682beb5c44074b6c550420ce
### Connect the Android Wear via USB cable:
- Unistall APK:
```
adb -d uninstall [packageName]
```

- Install APK:
```
adb -d install -r [nameOfApplication].apk
```

- Reboot the watch:
```
adb -d reboot
```

- List all packages installed on the device:
```
adb shell pm list packages
```

- Lauch application directly on the device:
```
adb shell am start -n [packageName]/[.activityName]
```

## Credits
By [Charlotte Broccard](http://charlottebroccard.ch/), [Stella Speziali](http://stellaspeziali.ch/)<br>
Eye Drop<br>
Lead by Alain Bellet, Cyril Diagne, Vincent Jacquier<br>
Assisted by [Romain Cazier](http://romaincazier.com/), Tibor Udvari<br>
ECAL/Bachelor Media & Interaction Design<br>
University of Art & Design, Lausanne 2017<br>
[www.ecal.ch](www.ecal.ch)
