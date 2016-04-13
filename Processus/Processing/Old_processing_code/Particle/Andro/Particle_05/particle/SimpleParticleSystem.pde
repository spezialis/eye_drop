//FOR ANDROID
/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity and fade out over time
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */
/////////////////////////////////////
import ketai.sensors.*;

import android.os.Bundle;
import android.view.WindowManager;

KetaiSensor sensor;
//float accelerometerX, accelerometerY, accelerometerZ;
PVector accelerometer, paccelerometer, gyroscope, pgyroscope;

void onCreate(Bundle bundle) {
  super.onCreate(bundle);
  getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void onAccelerometerEvent(float x, float y, float z) {
  accelerometer.set(x, y, z);
  //accelerometerX = x;
  //accelerometerY = y;
  //accelerometerZ = z;

  int time = millis();
  if (accelerometer.x - paccelerometer.x > -0.01 && accelerometer.x - paccelerometer.x < 0.01 &&
    accelerometer.y - paccelerometer.y > -0.01 && accelerometer.y - paccelerometer.y < 0.01 &&
    accelerometer.z - paccelerometer.z > -0.01 && accelerometer.z - paccelerometer.z < 0.01) {
    if (time - pauseTime > delay) {
      paused = true;
    }
  } else {
    pauseTime = time;
    paused = false;
    if (accelerometer.x - paccelerometer.x < -1 || accelerometer.x - paccelerometer.x > 1 ||
      accelerometer.y - paccelerometer.y < -1 || accelerometer.y - paccelerometer.y > 1 ||
      accelerometer.z - paccelerometer.z < -1 || accelerometer.z - paccelerometer.z > 1) {
      force = 2;
      slow = false;
    }
  }

  paccelerometer.set(x, y, z);
  lastTime = time;
}

int lastTime = 0, pauseTime = 0, delay = 2000;
boolean paused = false;
//void onGyroscopeEvent(float x, float y, float z) {
//  //gyroscope.set(x, y, z);

//  int time = millis();
//  //int delta = time - lastTime;
//  gyroscope.set(x, y, z);
//  if (gyroscope.x - pgyroscope.x > -0.1 && gyroscope.x - pgyroscope.x < 0.1 &&
//    gyroscope.y - pgyroscope.y > -0.1 && gyroscope.y - pgyroscope.y < 0.1 &&
//    gyroscope.z - pgyroscope.z > -0.1 && gyroscope.z - pgyroscope.z < 0.1) {
//    if (time - pauseTime > delay) {
//      paused = true;
//    }
//  } else {
//    pauseTime = time;
//    paused = false;
//    if (gyroscope.x - pgyroscope.x < -4 || gyroscope.x - pgyroscope.x > 4 ||
//      gyroscope.y - pgyroscope.y < -4 || gyroscope.y - pgyroscope.y > 4 ||
//      gyroscope.z - pgyroscope.z < -4 || gyroscope.z - pgyroscope.z > 4) {
//      force = 2;
//      slow = false;
//    }
//  }
//  pgyroscope.set(x, y, z);
//  lastTime = time;
//}
/////////////////////////////////////

ParticleSystem ps;
int diametreZone = 300;

float newX;
float newY;

float force;
float seed = 0;

boolean slow = true;

void setup() {
  /////////////////////////////////////
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);

  accelerometer = new PVector();
  gyroscope = new PVector();

  size(displayWidth, displayHeight);
  /////////////////////////////////////

  // size(500,500);
  ps = new ParticleSystem(new PVector(0, 0));
}

void draw() {
  /////////////////////////////////////
  //newX = map(accelerometer.x, -10, 10, displayWidth, 0);
  //newY = map(accelerometer.y, -10, 10, 0, displayHeight); 
  /////////////////////////////////////

  //force = map(mouseX, 0, width, .2, 2);
  //force = constrain(map(gyroscope.x, -2, 2, .2, 2), .2, 2);

  background(0);

  if (!paused) {
    pushMatrix();
    translate(width/2, height/2);

    //seed += 0.01;
    //if (seed > 1000000) {
    // seed = 0;
    //}

    if (slow) {
      if (frameCount % 10 == 0) {
        ps.addParticle(diametreZone/2, .1);
      }
    } else {
      ps.addParticle(diametreZone/2, force);
      force -= .05;
      if (force <= .1) {
        slow = true;
      }
    }

    //ps.addParticle(diametreZone/2, force);
    //ps.run(accelerometer.x, accelerometer.y);
    ps.run(accelerometer.x, accelerometer.y);
    popMatrix();
  }

  //noFill();
  //stroke(255);
  //ellipse(width/2, height/2, diametreZone, diametreZone);
}