//////////////////////////////

import ketai.sensors.*;
import ketai.ui.*;

import android.os.Bundle;
import android.view.WindowManager;

KetaiSensor sensor;
KetaiVibrate vibe;

void onCreate(Bundle bundle) {
  super.onCreate(bundle);
  getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void onAccelerometerEvent(float x, float y, float z) {
  acc.set(x, y, z);
}

double lastTime, pauseTime;
boolean explosion;
int explosionCount;

void onGyroscopeEvent(float x, float y, float z) {
  double time = millis();
  double delta = time - lastTime;
  gyro.set(x, y, z);
  if (gyro.x - pgyro.x > -0.05 && gyro.x - pgyro.x < 0.05 &&
    gyro.y - pgyro.y > -0.05 && gyro.y - pgyro.y < 0.05 &&
    gyro.z - pgyro.z > -0.05 && gyro.z - pgyro.z < 0.05) {
    if (time - pauseTime > delay) {
      paused = true;
      rot.set(0, 0, 0);
    }
  } else {
    pauseTime = time;
    paused = false;
    if (gyro.x - pgyro.x < -10 || gyro.x - pgyro.x > 10 ||
      gyro.y - pgyro.y < -10 || gyro.y - pgyro.y > 10 ||
      gyro.z - pgyro.z < -10 || gyro.z - pgyro.z > 10) {
      explosion = true;
    }
  }
  rot.x -= gyro.x * (delta / 1000);
  rot.y += gyro.y * (delta / 1000);
  rot.z += gyro.z * (delta / 1000);
  pgyro.set(x, y, z);
  lastTime = time;
}

void onRotationVectorEvent(float x, float y, float z) {
  rotTest.set(x, y, z);
}

//////////////////////////////

PVector acc, gyro, pgyro, rot, rotTest;
int inc = 0, rand = 10;

ArrayList<PVector> points;
ArrayList<ShootingStar> shootingStars;
ArrayList<Star> stars;

PVector sun;

int delay;
boolean paused;

void setup() {
  ////////////////////////////

  sensor = new KetaiSensor(this);
  sensor.start();

  vibe = new KetaiVibrate(this);

  orientation(PORTRAIT);

  lastTime = millis();

  textAlign(CENTER);

  delay = 2000;

  ////////////////////////////

  size(400, 400, P3D);

  /* 
   * Even distribution of points inside a sphere
   *
   * http://stackoverflow.com/a/5408843
   *
   */

  points = new ArrayList<PVector>();
  for (int i = 0; i < 100; i++) {
    float phi = random(0, TWO_PI);
    float costheta = random(-1, 1);
    float u = random(0, 1);
    float theta = acos(costheta);
    float r = random(50, width / 2) * pow(u, 1/3);

    points.add(new PVector(r * sin(theta) * cos(phi), 
      r * sin(theta) * sin(phi), 
      r * cos(theta)));
  }

  shootingStars = new ArrayList<ShootingStar>();

  stars = new ArrayList<Star>();
  for (int i = 0; i < 100; i++) {
    stars.add(new Star());
  }

  acc = new PVector();
  gyro = new PVector();
  pgyro = new PVector();
  rot = new PVector(0, 0, 0);
  rotTest = new PVector();

  explosionCount = 0;
  explosion = false;

  sphereDetail(20);
}

void draw() {
  background(0);

  pushMatrix();
  translate(width/2, height/2, width/2);
  rotateZ(rot.z);
  rotateY(rot.y);
  rotateX(rot.x);
  //rotateX(map(mouseY, 0, height, -PI / 2, PI / 2));
  //rotateY(map(mouseX, 0, width, -PI, PI));

  stroke(255);

  //noFill();
  //sphere(200);

  strokeWeight(2);
  if (!paused) {
    for (int i = 0; i < points.size(); i++) {
      PVector p = points.get(i);
      point(p.x, p.y, p.z);
    }
  }

  // je voudrais faire une ligne qui reste tout le temps droite
  // pour pouvoir faire une détection des points à proximité du centre

  stroke(255, 0, 0);
  strokeWeight(1);
  //line(0, 0, 0, 0, 0, width/2);
  //ellipse(0, 0, width, height);

  // X, Y, Z

  //stroke(255, 0, 0);
  //line(0, 0, 0, 50, 0, 0);
  //stroke(0, 255, 0);
  //line(0, 0, 0, 0, 50, 0);
  //stroke(0, 0, 255);
  //line(0, 0, 0, 0, 0, 50);

  if (!paused) {
    if (explosion && frameCount % 4 == 0) {
      shootingStars.add(new ShootingStar(true));
      if (explosionCount++ >= 15) {
        explosion = false;
        explosionCount = 0;
      }
    }

    if (frameCount % 60 == 0) {
      shootingStars.add(new ShootingStar(false));
    }

    for (int i = shootingStars.size() - 1; i > 0; i--) {
      shootingStars.get(i).update();
      shootingStars.get(i).display();
      if (shootingStars.get(i).isDead()) shootingStars.remove(i);
    }

    stroke(255, 125);
    for (Star s : stars) {
      s.display();
    }
  }


  popMatrix();

  hint(DISABLE_DEPTH_TEST);
  //stroke(255);
  //noFill();
  //ellipse(width/2, height/2, 30, 30);

  //text("x: " + (gyro.x - pgyro.x) + ", y: " + (gyro.y - pgyro.y) + ", z: " + (gyro.z - pgyro.z), width/2, height/2);

  hint(ENABLE_DEPTH_TEST);
}

//void mouseMoved() {
// rot.x += pmouseY - mouseY;
// rot.y += pmouseX - mouseX;
//}

class ShootingStar {

  PVector tip, tail, dest;
  Boolean dead, red;

  ShootingStar(boolean _red) {
    tip = new PVector(random(-width/2, width/2), random(-height/2, height/2), random(-width/2, width/2));

    tail = new PVector();
    tail.set(tip.x, tip.y, tip.z);

    dest = new PVector(random(-width/2, width/2), random(-height/2, height/2), random(-width/2, width/2));

    dead = false;

    red = _red;
  }

  void update() {
    if (!dead) {
      tip.x += (dest.x - tip.x) * .3;
      tip.y += (dest.y - tip.y) * .3;
      tip.z += (dest.z - tip.z) * .3;

      tail.x += (dest.x - tail.x) * .1;
      tail.y += (dest.y - tail.y) * .1;
      tail.z += (dest.z - tail.z) * .1;
    }

    if (!dead && tip.dist(dest) < .01 && tail.dist(dest) < .01) {
      dead = true;
    }
  }

  void display() {
    if (!dead) {
      if (red) stroke(255, 0, 0);
      else stroke(255);
      line(tip.x, tip.y, tip.z, tail.x, tail.y, tail.z);
    }
  }

  boolean isDead() {
    return dead;
  }
}

class Star {

  PVector pos;
  int life, maxLife;
  boolean dead;

  Star() {
    float phi = random(0, TWO_PI);
    float costheta = random(-1, 1);
    float u = random(0, 1);
    float theta = acos(costheta);
    float r = width * pow(u, 1/3);
    pos = new PVector(r * sin(theta) * cos(phi), 
      r * sin(theta) * sin(phi), 
      r * cos(theta));
    life = int(random(100, 200));
    maxLife = life;
    dead = false;
  }

  void update() {
    if (!dead) life--;
    if (life == 0) dead = true;
  }

  void display() {
    //stroke(255, life <= 40 ? map(life, 0, 40, 0, 120) : life >= maxLife - 40 ? map(life, maxLife - 40, maxLife, 120, 0) : 120);
    point(pos.x, pos.y, pos.z);
  }

  boolean isDead() {
    return dead;
  }
}