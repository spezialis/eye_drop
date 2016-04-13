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
float accelerometerX, accelerometerY, accelerometerZ;
//PVector accelerometer;

ParticleSystem ps;
int diametreZone = 300;

float newX;
float newY;

void onCreate(Bundle bundle) {
  super.onCreate(bundle);
  getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void onAccelerometerEvent(float x, float y, float z) {
  //accelerometer.set(x, y, z);
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}
/////////////////////////////////////

void setup() {
  /////////////////////////////////////
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);

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
  newX=0;
  newY=0;

  background(0);
  pushMatrix();
  translate(width/2, height/2);
  ps.addParticle(diametreZone/2);
  //ps.run(accelerometer.x, accelerometer.y);
  ps.run(accelerometerX, accelerometerY);
  popMatrix();

  //noFill();
  //stroke(255);
  //ellipse(width/2, height/2, diametreZone, diametreZone);
}