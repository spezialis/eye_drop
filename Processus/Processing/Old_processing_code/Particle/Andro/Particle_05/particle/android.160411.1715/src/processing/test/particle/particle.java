package processing.test.particle;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ketai.sensors.*; 
import android.os.Bundle; 
import android.view.WindowManager; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class particle extends PApplet {

//FOR ANDROID
// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  PVector origin = new PVector();
  //int diameter = 500;
  int radius;

  Particle(PVector l, int r, float force) {
    radius = r;
    //acceleration = new PVector(0, 0.05);
    //velocity = new PVector(random(-1, 1), random(-2, 0));
    //velocity = new PVector(random(-1, 1), random(-1, 1));
    velocity = new PVector(random(-force, force), random(-force, force));
    //location = l.get();
    //location = new PVector(mouseX - width/2, mouseY - height/2);
    location = new PVector(0, 0);
    lifespan = 200.0f;
  }

  public void run(float gravX, float gravY) {
    update(gravX, gravY);
    display();
  }

  // Method to update location
  public void update(float gravX, float gravY) {
    acceleration = new PVector(map(gravX, -10, 10, 0.1f, -0.1f), 
      map(gravY, -10, 10, -0.1f, 0.1f));
    velocity.add(acceleration);
    location.limit(radius);
    location.add(velocity);
    lifespan -= 1.0f;

    if (location.dist(origin) > radius) {
      PVector n = location.get();
      n.normalize();
      n.mult(1.8f*n.dot(velocity));
      velocity.sub(n);
    }
  }

  // Method to display
  public void display() {
    //stroke(255);
    //stroke(0, 0, map(lifespan, 0, 200, 0, 255));
    stroke(constrain(map(lifespan, 0, 200, 0, 255), 0, 255), constrain(map(lifespan, 0, 200, 0, 255), 0, 255), 255);
    strokeWeight(constrain(map(lifespan, 0, 200, 0, 3), 0, 3));
    //fill(255, lifespan);
    //ellipse(location.x,location.y,8,8);
    point(location.x, location.y);
  }

  // Is the particle still useful?
  public boolean isDead() {
    if (lifespan < 0.0f) {
      return true;
    } else {
      return false;
    }
  }
}
// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  public void addParticle(int diam, float force) {
    particles.add(new Particle(origin, diam, force));
  }

  public void run(float gravX, float gravY) {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run(gravX, gravY);
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
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





KetaiSensor sensor;
//float accelerometerX, accelerometerY, accelerometerZ;
PVector accelerometer, gyroscope, pgyroscope;

public void onCreate(Bundle bundle) {
  super.onCreate(bundle);
  getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

public void onAccelerometerEvent(float x, float y, float z) {
  accelerometer.set(x, y, z);
  //accelerometerX = x;
  //accelerometerY = y;
  //accelerometerZ = z;
}

int lastTime = 0, pauseTime = 0, delay = 2000;
boolean paused = false;
public void onGyroscopeEvent(float x, float y, float z) {
  gyroscope.set(x, y, z);

  int time = millis();
  //int delta = time - lastTime;
  gyroscope.set(x, y, z);
  if (gyroscope.x - pgyroscope.x > -0.05f && gyroscope.x - pgyroscope.x < 0.05f &&
    gyroscope.y - pgyroscope.y > -0.05f && gyroscope.y - pgyroscope.y < 0.05f &&
    gyroscope.z - pgyroscope.z > -0.05f && gyroscope.z - pgyroscope.z < 0.05f) {
    if (time - pauseTime > delay) {
      paused = true;
    }
  } else {
    pauseTime = time;
    paused = false;
    if (gyroscope.x - pgyroscope.x < -10 || gyroscope.x - pgyroscope.x > 10 ||
      gyroscope.y - pgyroscope.y < -10 || gyroscope.y - pgyroscope.y > 10 ||
      gyroscope.z - pgyroscope.z < -10 || gyroscope.z - pgyroscope.z > 10) {
      force = 2;
      slow = false;
    }
  }
  pgyroscope.set(x, y, z);
  lastTime = time;
}
/////////////////////////////////////

ParticleSystem ps;
int diametreZone = 300;

float newX;
float newY;

float force;
float seed = 0;

boolean slow = true;

public void setup() {
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

public void draw() {
  /////////////////////////////////////
  //newX = map(accelerometer.x, -10, 10, displayWidth, 0);
  //newY = map(accelerometer.y, -10, 10, 0, displayHeight); 
  /////////////////////////////////////

  //force = map(mouseX, 0, width, .2, 2);
  //force = constrain(map(gyroscope.x, -2, 2, .2, 2), .2, 2);

  background(0);
  pushMatrix();
  translate(width/2, height/2);

  //seed += 0.01;
  //if (seed > 1000000) {
  // seed = 0;
  //}

  if (slow) {
    if (frameCount % 10 == 0) {
      ps.addParticle(diametreZone/2, .1f);
    }
  } else {
    ps.addParticle(diametreZone/2, force);
    force -= .05f;
    if (force <= .1f) {
      slow = true;
    }
  }

  //ps.addParticle(diametreZone/2, force);
  //ps.run(accelerometer.x, accelerometer.y);
  ps.run(accelerometer.x, accelerometer.y);
  popMatrix();

  //noFill();
  //stroke(255);
  //ellipse(width/2, height/2, diametreZone, diametreZone);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#030303", "--stop-color=#cccccc", "particle" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
