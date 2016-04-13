//////////////////////////////////
import android.os.Bundle;
import android.view.WindowManager;

import ketai.sensors.*;

KetaiSensor sensor;
PVector accelerometer, gyroscope;

void onCreate(Bundle bundle) {
  super.onCreate(bundle);
  getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void onAccelerometerEvent(float x, float y, float z) {
  accelerometer.set(x, y, z);
}

double lastTime, pauseTime;
PVector gyro, pgyro;
int delay;
boolean paused;

void onGyroscopeEvent(float x, float y, float z) {
  double time = millis();
  gyro.set(x, y, z);
  if (gyro.x - pgyro.x > -0.005 && gyro.x - pgyro.x < 0.005 &&
    gyro.y - pgyro.y > -0.005 && gyro.y - pgyro.y < 0.005 &&
    gyro.z - pgyro.z > -0.005 && gyro.z - pgyro.z < 0.005) {
    if (time - pauseTime > delay) {
      paused = true;
    }
  } else {
    pauseTime = time;
    paused = false;
  }
  pgyro.set(x, y, z);
  lastTime = time;
}
//////////////////////////////////

//////////////////////////////////
// Fluid Particles
//////////////////////////////////
// copyright: Daniel Erickson 2012

float[][] xvels;
float[][] yvels;
float SCALE = 0.09;
float DIFFUSE = 0.1;
float MOUSE_MULTIPLIER = 12;
float SPEED = 12;
int PIXELS = 15;
int N = 200;
float PARTICLE_SPEED = 24;
float RADIUS = 3;

int WIDTH;
int HEIGHT;

float sample(float[][] arr, int x, int y) {
  int w = WIDTH;
  int h = HEIGHT;
  return arr[(x + w) % w][(y + h) % h];
}

float sample_surrounding(float[][] arr, float x, float y) {
  float w = WIDTH-1;
  float h = HEIGHT-1;
  x = (x + 10*w) % w;
  y = (y + 10*h) % h;
  int fx = int(x);
  int fy = int(y);
  int cx = fx+1;
  int cy = fy+1;
  float wx1 = cx - x;
  float wx2 = x - fx;
  float wy1 = cy - y;
  float wy2 = y - fy;

  return  arr[fx][fy] * wx1*wy1 +
    arr[fx][cy] * wx1*wy2 +
    arr[cx][fy] * wx2*wy1 +
    arr[cx][cy] * wx2*wy2;
}

float[][] diffuse(float[][] arr, float dt, float drag) {
  float[][] ret = new float[WIDTH][HEIGHT];
  float wsurrounding = dt*DIFFUSE;
  float wcenter = drag-(wsurrounding*4);
  for (int x = 0; x < WIDTH; x++) {
    for (int y = 0; y < HEIGHT; y++) {
      ret[x][y] = wcenter * sample(arr, x, y) +
        wsurrounding * sample(arr, x, y-1) +
        wsurrounding * sample(arr, x, y+1) +
        wsurrounding * sample(arr, x-1, y) +
        wsurrounding * sample(arr, x+1, y);
    }
  };
  return ret;
}

void project(float[][] xarr, float[][] yarr, float dt) {
  float[][] proj = new float[WIDTH][HEIGHT];

  for (int x=0; x < WIDTH; x++) {
    for (int y=0; y < HEIGHT; y++) {
      proj[x][y] = -0.5 * ((sample(xarr, x+1, y) - sample(xarr, x-1, y)) +
        (sample(yarr, x, y+1) - sample(yarr, x, y-1)));
    }
  }

  proj = diffuse(proj, dt, 1);

  for (int x=0; x < WIDTH; x++) {
    for (int y=0; y < HEIGHT; y++) {
      xarr[x][y] += -0.5 * (sample(proj, x+1, y) - sample(proj, x-1, y));
      yarr[x][y] += -0.5 * (sample(proj, x, y+1) - sample(proj, x, y-1));
    }
  }
}

void update(float dt) {
  float[][] xvels1 = new float[WIDTH][HEIGHT];
  float[][] yvels1 = new float[WIDTH][HEIGHT];

  xvels = diffuse(xvels, dt, 0.98);
  yvels = diffuse(yvels, dt, 0.98);

  project(xvels, yvels, dt);

  // advect
  for (int x=0; x<WIDTH; x++) {
    for (int y=0; y<HEIGHT; y++) {
      xvels1[x][y] = sample_surrounding(xvels, (float)x-xvels[x][y]*dt*SPEED, (float)y-yvels[x][y]*dt*SPEED);
      yvels1[x][y] = sample_surrounding(yvels, (float)x-xvels[x][y]*dt*SPEED, (float)y-yvels[x][y]*dt*SPEED);
    }
  }

  project(xvels1, yvels1, dt);

  xvels = xvels1;
  yvels = yvels1;
}

PVector[] particles;
//color[] colors;

void setup() {
  //////////////////////////////////
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);

  accelerometer = new PVector();
  gyroscope = new PVector();

  gyro = new PVector();
  pgyro = new PVector();
  //////////////////////////////////

  noStroke();
  smooth();
  //size(500, 500);
  WIDTH = (width - 100) / PIXELS;
  HEIGHT = (height - 100) / PIXELS;
  xvels = new float[width - 100][height - 100];
  yvels = new float[width - 100][height - 100];
  for (int x=0; x < width - 100; x++) {
    for (int y=0; y < height - 100; y++) {
      xvels[x][y] = 0;//SPEED*(noise(x*SCALE, y*SCALE)-0.4);
      yvels[x][y] = 0;//SPEED*(noise(x*SCALE, y*SCALE)-0.4);
    }
  }

  particles = new PVector[N];
  //colors = new color[N];
  for (int i=0; i<N; i++) {
    particles[i] = new PVector(random(width), random(height), 0);
    //colors[i] = color(random(110, 240), random(160, 240), 220);
  }
}

int old_mousex;
int old_mousey;

float X, Y;

void draw() {


  //////////////////////////////////
  float newX = constrain(map(accelerometer.x, -10, 10, width - 100, 0), 0, width - 100);
  float newY = constrain(map(accelerometer.y, -10, 10, 0, height - 100), 0, height - 100);

  X += (newX - X) * .3;
  Y += (newY - Y) * .3;

  int mousex = int(X) / PIXELS;
  int mousey = int(Y) / PIXELS;
  //////////////////////////////////

  //int mousex = (mouseX-1) / PIXELS;
  //int mousey = (mouseY-1) / PIXELS;

  if (mousex == old_mousex && mousey == old_mousey) {
    old_mousex = 0;
    old_mousey = 0;
  } else {
    if (old_mousex > 0 && old_mousey > 0 && mousex < WIDTH && mousey < HEIGHT) {
      xvels[mousex][mousey] = MOUSE_MULTIPLIER * max(-20, min(20, mousex - old_mousex));
      yvels[mousex][mousey] = MOUSE_MULTIPLIER * max(-20, min(20, mousey - old_mousey));
    }
    old_mousex = mousex;
    old_mousey = mousey;
  }

  if (!paused) { 
    update(0.1);
  }


  background(0);


  translate(50, 50);

  for (int i=0; i<N; i++) {
    PVector particle = particles[i];
    float velx = sample_surrounding(xvels, particle.x/PIXELS, particle.y/PIXELS);
    float vely = sample_surrounding(yvels, particle.x/PIXELS, particle.y/PIXELS);
    particle.x = (particle.x + velx*PARTICLE_SPEED + (width - 100)) % (width - 100);
    particle.y = (particle.y + vely*PARTICLE_SPEED + (height - 100)) % (height - 100);
    particle.z *= 0.99;
    particle.z = max(particle.z, pow((abs(velx) + abs(vely)), 0.75) * RADIUS);

    //fill(colors[i]);
    //CYAN
    //fill(
    //  constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 0), 0, 255), 
    //  constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 240), 240, 255), 
    //  constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 220), 220, 255));

    //RED
    //fill(
    //  constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 255), 255, 255), 
    //  constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 0), 0, 255), 
    //  constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 0), 0, 255));

    //BLUE
    fill(
      constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 0), 0, 255), 
      constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 0), 0, 255), 
      constrain(map(particle.z, 2 * RADIUS / 3, RADIUS * 2, 255, 255), 255, 255));
    ellipse(particle.x, particle.y, particle.z, particle.z);
  }


  //ellipse(X, Y, 10, 10);
}