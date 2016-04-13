import ketai.sensors.*;
import ketai.ui.*;

import android.os.Bundle;
import android.view.WindowManager;

KetaiSensor sensor;
KetaiVibrate vibe;

PVector accelerometer, gyroscope, rotation;

float x, y, z;
float newX, newY;

int value = 0;

color c = color(255, 255, 255);

void onCreate(Bundle bundle) {
  super.onCreate(bundle);
  getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void setup() {
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);
  textAlign(CENTER, CENTER);
  textSize(20);

  vibe = new KetaiVibrate(this);

  accelerometer = new PVector();
  gyroscope = new PVector();
  rotation = new PVector();
}

void draw() {
  background(value);
  fill(255);
  text("Accelerometer: \n" + 
    "x: " + nfp(accelerometer.x, 1, 1) + "\n" +
    "y: " + nfp(accelerometer.y, 1, 1) + "\n" +
    "z: " + nfp(accelerometer.z, 1, 1) + "\n" +
    "Gyroscope: " +  "\n" +
    "x: " + nfp(gyroscope.x, 1, 1) + "\n" +
    "y: " + nfp(gyroscope.y, 1, 1) + "\n" +
    "z: " + nfp(gyroscope.z, 1, 1), 0, 0, width, height);

  x = map(accelerometer.x, -10, 10, displayWidth, 0);
  y = map(accelerometer.y, -10, 10, 0, displayHeight);
  z = map(accelerometer.z, -10, 10, 0, 50);

  newX = lerp(newX, x, 0.07);
  newY = lerp(newY, y, 0.07);

  //fill(255);
  //rect(0, height/1.2, width, 10); 

  if (newY > 0 && newY < height/2.5) {
    c = color(0, 0, 255);
    //fill(0, 0, 255);
  }
  if (newY > height/2.5 && newY < height/1.5) {
    c = color(255, 0, 0);
    //fill(255, 0, 0);
  } 
  if (newY > height/1.5 && newY < height) {
    c = color(0, 255, 200);
    //fill(0, 255, 200);
  }

  //if (accelerometer.z >= 6.0 && accelerometer.z <= 6.1) {
  //  vibe.vibrate(500);
  //}

  fill(c);
  ellipse(newX, newY, z, z);
}

void onAccelerometerEvent(float x, float y, float z) {
  accelerometer.set(x, y, z);
}

void onGyroscopeEvent(float x, float y, float z) {
  gyroscope.set(x, y, z);
}

void mousePressed() {
  vibe.vibrate(500);
}

/*
  available sensors/methods 
 
 * void onSensorEvent(SensorEvent e) - raw android sensor event <br />
 * void onAccelerometerEvent(float x, float y, float z, long a, int b): x,y,z force in m/s^2, a=timestamp(nanos), b=accuracy
 *! void onAccelerometerEvent(float x, float y, float z):  x,y,z force in m/s2
 * void onOrientationEvent(float x, float y, flaot z, long a, int b):  x,y,z rotation in degrees, a=timestamp(nanos), b=accuracy
 ** void onOrientationEvent(float x, float y, float z) : x,y,z rotation in degrees
 * void onMagneticFieldEvent(float x, float y, float z, long a, int b) : x,y,z geomag field in uT, a=timestamp(nanos), b=accuracy
 ** void onMagneticFieldEvent(float x, float y, float z): x,y,z geomagnetic field in uT
 * void onGyroscopeEvent(float x, float y, float z, long a, int b):x,y,z rotation in rads/sec, a=timestamp(nanos), b=accuracy
 *! void onGyroscopeEvent(float x, float y, float z): x,y,z rotation in rads/sec
 * void onGravityEvent(float x, float y, float z, long a, int b): x,y,z force of gravity in m/s^2, a=timestamp(nanos), b=accuracy
 ** void onGravityEvent(float x, float y, float z): x,y,z rotation in m/s^s
 * void onProximityEvent(float d, long a, int b): d distance from sensor (typically 0,1), a=timestamp(nanos), b=accuracy
 ** void onProximityEvent(float d): d distance from sensor (typically 0,1)
 * void onLightEvent(float d, long a, int b): d illumination from sensor in lx
 ** void onLightEvent(float d): d illumination from sensor in lx
 * void onPressureEvent(float p, long a, int b): p ambient pressure in hPa or mbar, a=timestamp(nanos), b=accuracy
 *! void onPressureEvent(float p): p ambient pressure in hPa or mbar
 * void onTemperatureEvent(float t, long a, int b): t temperature in degrees in degrees Celsius, a=timestamp(nanos), a=timestamp(nanos), b=accuracy
 ** void onTemperatureEvent(float t): t temperature in degrees in degrees Celsius
 * void onLinearrotationEvent(float x, float y, float z, long a, int b): x,y,z rotation force in m/s^2, minus gravity, a=timestamp(nanos), b=accuracy
 *! void onLinearrotationEvent(float x, float y, float z): x,y,z rotation force in m/s^2, minus gravity
 * void onRotationVectorEvent(float x, float y, float z, long a, int b): x,y,z rotation vector values, a=timestamp(nanos), b=accuracy
 *! void onRotationVectorEvent(float x, float y, float z):x,y,z rotation vector values
 * void onAmibentTemperatureEvent(float t): same as temp above (newer API)
 * void onRelativeHumidityEvent(float h): h ambient humidity in percentage
 * void onSignificantMotionEvent(): trigger for when significant motion has occurred
 * void onStepDetectorEvent(): called on every step detected
 * void onStepCounterEvent(float s): s is the step count since device reboot, is called on new step
 ** void onGeomagneticRotationVectorEvent(float x, float y, float z):
 * void onGameRotationEvent(float x, float y, float z): 
 * void onHeartRateEvent(float r): returns current heart rate in bpm 
 */