int particleCount = 1000;
Particle[] particles = new Particle[particleCount+1];

PVector circle = new PVector(250, 250);
int radiusC = 500;

void setup() {
  size(500, 500);
  colorMode(RGB, 1);
  stroke(1);

  fill(0);
  //frameRate(30);

  for (int x = particleCount; x >= 0; x--) {
    particles[x] = new Particle();
  }
}

void draw() {
  background(0);

  fill(255);
  //ellipse(mouseX, mouseY, 25, 25);

  ellipse(circle.x, circle.y, radiusC, radiusC);
  //ellipse(width/2, height/2, width, height);
  //quad(10, 10, width-10, 10, width-10, height-10, 10, height-10);
  for (int i = particleCount; i >= 0; i--) {
    Particle particle = (Particle) particles[i];
    particle.update();
  }
}

class Particle {
  //float x;
  //float y;
  //float vx;
  //float vy;

  //////////////////////////////////
  PVector location;
  PVector velocity = new PVector();
  //////////////////////////////////

  Particle() {
    //x = random(10, height-10);
    //y = random(10, height-10);
    
    float randAngle = random(-PI, PI);
    //translate(width/2, height/2);
    float randRayon = random(0, radiusC/2);

    //////////////////////////////////
    //location = new PVector(random(10, height-10), random(10, height-10));
    location = new PVector(circle.x + cos(randAngle) * randRayon, circle.y + sin(randAngle) * randRayon);
    //if (location.dist(circle) > radiusC/2){
    //  location = new PVector(random(10, height-10), random(10, height-10));
    //}
    //location.sub(circle);
    //location.limit(radiusC-50);
    //velocity = new PVector(vx, vy);
    //////////////////////////////////
  }

  void update() {
    //float rx = mouseX;
    //float ry = mouseY;

    PVector m = new PVector(mouseX, mouseY);
    //if (dist(m.x, m.y, circle.x, circle.y) > radiusC/2) {
      if (m.dist(circle) > radiusC/2) {
      m.sub(circle);
      m.normalize();
      m.mult(radiusC/2);
      m.add(circle);
    }

    //float radius = dist(x, y, rx, ry);
    //float radius = dist(x, y, m.x, m.y);
    //float radius = dist(location.x, location.y, m.x, m.y);
    float radius = location.dist(m);

    if (radius < 100) {
      //float angle = atan2(y-ry, x-rx);
      //float angle = atan2(y-m.y, x-m.x);
      float angle = atan2(location.y-m.y, location.x-m.x);

      //vx -= (150 - radius) * 0.01 * cos(angle + (0.7 + 0.0005 * (150 - radius)));
      //vy -= (150 - radius) * 0.01 * sin(angle + (0.7 + 0.0005 * (150 - radius)));
      velocity.x -= (150 - radius) * 0.01 * cos(angle + (0.7 + 0.0005 * (150 - radius)));
      velocity.y -= (150 - radius) * 0.01 * sin(angle + (0.7 + 0.0005 * (150 - radius)));
    }

    // x and y are increased by our velocities
    //x += vx;
    //y += vy;
    //location.x += vx;
    //location.y += vy;
    //location.x += velocity.x;
    //location.y += velocity.y;
    location.add(velocity);

    //The velocities are decreased by 3%
    //vx *= 0.97;
    //vy *= 0.97;
    //velocity.x *= 0.97;
    //velocity.y *= 0.97;
    velocity.mult(0.97);

    /*
    Boundary collision is calculated here. If the particle is beyond the boundary, its velocity is reversed and the particle is moved back into the main area.
     */
    //if (x > width-10) {
    //  vx *= -1;
    //  x = width-11;
    //}
    //if (x < 10) {
    //  vx *= -1;
    //  x = 11;
    //}
    //if (y > height-10) {
    //  vy *= -1;
    //  y = height-11;
    //}
    //if (y < 10) {
    //  vy *= -1;
    //  y = 11;
    //}

    //if (dist(location.x, location.y, circle.x, circle.y) > radius/2) {
    //vx *= -1;
    //vy *= -1;
    //location.sub(circle);
    //location.normalize();
    //location.mult(radius/2);
    //location.add(circle);
    //}

    if (location.dist(circle) > radiusC/2) {
      //location.sub(velocity);
      //location.normalize();
      velocity.mult(-1);

      //location.limit(radiusC);
      
      //location.limit(radiusC/2);

      //location.sub(circle);
      
      //location.mult(radius/2);
      //location.add(circle);

      //PVector n = location.get();
      //n.normalize();
      //n.mult(1.5*n.dot(velocity));
      //velocity.sub(n);
    }

    //if (location.x > width-10) {
    //  velocity.x *= -1;
    //  location.x = width-11;
    //}
    //if (location.x < 10) {
    //  velocity.x *= -1;
    //  location.x = 11;
    //}
    //if (location.y > height-10) {
    //  velocity.y *= -1;
    //  location.y = height-11;
    //}
    //if (location.y < 10) {
    //  velocity.y *= -1;
    //  location.y = 11;
    //}
    //if (location.x > angleBig) {
    //  velocity.x *= -1;
    //}

    //point((int)x, (int)y);
    //point((int)location.x, (int)location.y);
    point(int(location.x), int(location.y));

    ellipse(m.x, m.y, 25, 25);
  }
}