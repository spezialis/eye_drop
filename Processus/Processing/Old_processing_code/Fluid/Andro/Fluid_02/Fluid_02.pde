// Fluid Particles
// copyright: Daniel Erickson 2012

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

void onGyroscopeEvent(float x, float y, float z) {
  gyroscope.set(x, y, z);
}
//////////////////////////////////

float[][] xvels;
float[][] yvels;
float SCALE = 0.09;
float DIFFUSE = 0.1;
float MOUSE_MULTIPLIER = 4;
float SPEED = 2;
int PIXELS = 25;
int N = 400;
float PARTICLE_SPEED = 20;
float RADIUS = 2;

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
  int fx = floor(x);
  int fy = floor(y);
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
  for (int x=0; x<WIDTH; x++) {
    for (int y=0; y<HEIGHT; y++) {
      ret[x][y] = wcenter*sample(arr, x, y) +
        wsurrounding*sample(arr, x, y-1) +
        wsurrounding*sample(arr, x, y+1) +
        wsurrounding*sample(arr, x-1, y) +
        wsurrounding*sample(arr, x+1, y);
    }
  };
  return ret;
}

void project(float[][] xarr, float[][] yarr, float dt) {
  float[][] proj = new float[WIDTH][HEIGHT];

  for (int x=0; x<WIDTH; x++) {
    for (int y=0; y<HEIGHT; y++) {
      proj[x][y] = -0.5 * ((sample(xarr, x+1, y) - sample(xarr, x-1, y)) +
        (sample(yarr, x, y+1) - sample(yarr, x, y-1)));
    }
  }

  proj = diffuse(proj, dt, 1);

  for (int x=0; x<WIDTH; x++) {
    for (int y=0; y<HEIGHT; y++) {
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

void setup() {
  //////////////////////////////////
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);

  accelerometer = new PVector();
  gyroscope = new PVector();
  //////////////////////////////////

  noStroke();
  smooth();
  //size(500, 500);
  
  WIDTH = width/PIXELS;
  HEIGHT = height/PIXELS;
  xvels = new float[width][height];
  yvels = new float[width][height];
  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      xvels[x][y] = 0;//SPEED*(noise(x*SCALE, y*SCALE)-0.4);
      yvels[x][y] = 0;//SPEED*(noise(x*SCALE, y*SCALE)-0.4);
    }
  }

  particles = new PVector[N];
  for (int i=0; i<N; i++) {
    particles[i] = new PVector(random(width), random(height), 0);
  }
}
//////////////////////////////////
int old_mousex;
int old_mousey;
int mousex;
int mousey;

//color white = color(255, 255, 255);
//color cyan = color(0, 255, 200);

float red = 1;
float blue = 1;
float count = -0.00005;
boolean startCount = false;
//////////////////////////////////

void draw() {
  //////////////////////////////////
  float newX = constrain(map(accelerometer.x, -10, 10, width, 0), 0, width);
  float newY = constrain(map(accelerometer.y, -10, 10, 0, height), 0, height);

  //mousex = int(newX / PIXELS);
  //mousey = int(newY / PIXELS);
  mousex = int(lerp(mousex, (newX / PIXELS), 0.5));
  mousey = int(lerp(mousey, (newY / PIXELS), 0.5));
  //////////////////////////////////

  //if (mousex == old_mousex && mousey == old_mousey) {
  //old_mousex = 0;
  //old_mousey = 0;

  //} else {
  if (old_mousex > 0 && old_mousey > 0 &&
    mousex < WIDTH && mousey < HEIGHT) {
    xvels[mousex][mousey] = MOUSE_MULTIPLIER * max(-20, min(20, mousex - old_mousex));
    yvels[mousex][mousey] = MOUSE_MULTIPLIER * max(-20, min(20, mousey - old_mousey));
  }
  old_mousex = mousex;
  old_mousey = mousey;
  //}

  update(0.1);

  background(0);

  for (int i=0; i<N; i++) {
    PVector particle = particles[i];
    float velx = sample_surrounding(xvels, particle.x/PIXELS, particle.y/PIXELS);
    float vely = sample_surrounding(yvels, particle.x/PIXELS, particle.y/PIXELS);
    particle.x = (particle.x + velx*PARTICLE_SPEED + width) % width;
    particle.y = (particle.y + vely*PARTICLE_SPEED + height) % height;
    particle.z *= 0.99;
    particle.z = max(particle.z, pow((abs(velx) + abs(vely)), 0.75)*RADIUS);

    // fill(255);
    
    //////////////////////////////////
    float r = map(red, 0, 1, 255, 0);
    float b = map(blue, 0, 1, 255, 200);
    fill(r, 255, b);

    if (gyroscope.x > 0.3 || gyroscope.x < -0.3) {
      startCount = true;
      red = 1;
      blue = 1;
    } 
    if (startCount == true) {
      red += count;
      blue += count;
    } 
    if (red <= 0) {
      startCount = false;
    }

    //if (gyroscope.x > 0.3 || gyroscope.x < -0.3) {
    //  fill(cyan);
    //}
    //if (gyroscope.x < 0.3 && gyroscope.x > -0.3) {
    //  fill(white);
    //}

    //fill(constrain(map(particle.z, 2, 5, 255, 0), 0, 255), 
    //  255, 
    //  constrain(map(particle.z, 2, 0, 255, 200), 200, 255));

    //if (particle.z < 3) {
    //  fill(white);
    //} 
    //if (particle.z > 3) {
    //  fill(cyan);
    //}
    //////////////////////////////////

    ellipse(particle.x, particle.y, particle.z, particle.z);
  }
}