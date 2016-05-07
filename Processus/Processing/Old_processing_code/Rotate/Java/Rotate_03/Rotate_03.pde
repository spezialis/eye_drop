int particleCount = 1000;
Particle[] particles = new Particle[particleCount+1];

PVector circle = new PVector(250, 250);
int radiusC = 500;

void setup() {
  size(500, 500);
  //stroke(255);

  for (int x = particleCount; x >= 0; x--) {
    particles[x] = new Particle();
  }
}

void draw() {
  noCursor();
  background(0);

  //fill(0);
  //ellipse(circle.x, circle.y, radiusC, radiusC);

  for (int i = particleCount; i >= 0; i--) {
    Particle particle = (Particle) particles[i];
    particle.update();
  }
}

class Particle {
  PVector location;
  PVector velocity = new PVector();

  Particle() {
    float randAngle = random(-PI, PI);
    float randRayon = random(0, radiusC/2);

    location = new PVector(circle.x + cos(randAngle) * randRayon, circle.y + sin(randAngle) * randRayon);
  }

  void update() {
    PVector m = new PVector(mouseX, mouseY);
    //if (dist(m.x, m.y, circle.x, circle.y) > radiusC/2) {
    if (m.dist(circle) > radiusC/2) {
      m.sub(circle);
      m.normalize();
      m.mult(radiusC/2);
      m.add(circle);
    }

    float radius = location.dist(m);
    int sizeM = 100;

    stroke(255, 0, 0);
    strokeWeight(1);
    if (radius < sizeM) {
      //stroke(255, map(radius, 0, sizeM, 0, 255), map(radius, 0, sizeM, 0, 255));
      stroke(255, map(radius, 0, sizeM, 255, 0), map(radius, 0, sizeM, 255, 0));
      strokeWeight(map(radius, 0, sizeM, 3, 1));
      
      float angle = atan2(location.y-m.y, location.x-m.x);

      velocity.x -= (sizeM - radius) * 0.01 * cos(angle + (0.7 + 0.0005 * (sizeM - radius)));
      velocity.y -= (sizeM - radius) * 0.01 * sin(angle + (0.7 + 0.0005 * (sizeM - radius)));
    }

    //location is increased by the velocity
    location.add(velocity);

    //The velocity is decreased by 3%
    velocity.mult(0.97);

    //Boundary collision is calculated here. If the particle is beyond the boundary, its velocity is reversed and the particle is moved back into the main area.
    if (location.dist(circle) > radiusC/2) {
      velocity.mult(-1);
    }

    point(int(location.x), int(location.y));

    noStroke();
    noFill();
    ellipse(m.x, m.y, 25, 25);
  }
}