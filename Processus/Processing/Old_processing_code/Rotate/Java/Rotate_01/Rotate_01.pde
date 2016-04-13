int particleCount = 1000;
Particle[] particles = new Particle[particleCount+1];

void setup() {
  size(500, 500);
  colorMode(RGB, 1);
  stroke(1);

  fill(0);
  frameRate(30);

  for (int x = particleCount; x >= 0; x--) {
    particles[x] = new Particle();
  }
}

void draw() {
  background(0);

  fill(255);
  ellipse(mouseX, mouseY, 25, 25);

  ellipse(width/2, height/2, width, height);
  //quad(10, 10, width-10, 10, width-10, height-10, 10, height-10);
  for (int i = particleCount; i >= 0; i--) {
    Particle particle = (Particle) particles[i];
    particle.update();
  }
}

class Particle {
  float x;
  float y;
  float vx;
  float vy;

  //////////////////////////////////
  //PVector location;
  //PVector velocity;
  //////////////////////////////////

  Particle() {
    x = random(10, height-10);
    y = random(10, height-10);

    //////////////////////////////////
    //location = new PVector(x, y);
    //location.limit(radius-50);
    //velocity = new PVector(vx, vy);
    //////////////////////////////////
  }

  void update() {
    float rx = mouseX;
    float ry = mouseY;
    float radius = dist(x, y, rx, ry);
   
    float angleBig = atan2(500-x, 500-y);

    if (radius < 150) {
      float angle = atan2(y-ry, x-rx);

       vx -= (150 - radius) * 0.01 * cos(angle + (0.7 + 0.0005 * (150 - radius)));
       vy -= (150 - radius) * 0.01 * sin(angle + (0.7 + 0.0005 * (150 - radius)));
    }

    // x and y are increased by our velocities
    x += vx;
    y += vy;

    //The velocities are decreased by 3%
    vx *= 0.97;
    vy *= 0.97;

    /*
    Boundary collision is calculated here. If the particle is beyond the boundary, its velocity is reversed and the particle is moved back into the main area.
     */
    if (x > width-10) {
    vx *= -1;
    x = width-11;
    }
    if (x < 10) {
    vx *= -1;
    x = 11;
    }
    if (y > height-10) {
    vy *= -1;
    y = height-11;
    }
    if (y < 10) {
    vy *= -1;
    y = 11;
    }
    
    if (x > angleBig){
        //vx *= -1;
    }

    point((int)x, (int)y);
  }
}