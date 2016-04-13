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

  Particle(PVector l, int r) {
    radius = r;
    //acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    //velocity = new PVector(random(-1, 1), random(-1, 1));
    //location = l.get();
    //location = new PVector(mouseX - width/2, mouseY - height/2);
    location = new PVector(0, 0);
    lifespan = 200.0;
  }

  void run(float gravX, float gravY) {
    update(gravX, gravY);
    display();
  }

  // Method to update location
  void update(float gravX, float gravY) {
    acceleration = new PVector(map(gravX, -10, 10, 0.1, -0.1), 
      map(gravY, -10, 10, -0.1, 0.1));
    velocity.add(acceleration);
    location.limit(radius);
    location.add(velocity);
    lifespan -= 1.0;

    if (location.dist(origin) > radius) {
      PVector n = location.get();
      n.normalize();
      n.mult(1.5*n.dot(velocity));
      velocity.sub(n);
    }
  }

  // Method to display
  void display() {
    //stroke(255);
    //stroke(0, 0, map(lifespan, 0, 200, 0, 255));
    stroke(constrain(map(lifespan, 0, 200, 255, 0), 0, 255), constrain(map(lifespan, 0, 200, 255, 0), 0, 255), 255);
    strokeWeight(constrain(map(lifespan, 0, 200, 0, 5), 0, 5));
    //fill(255, lifespan);
    //ellipse(location.x,location.y,8,8);
    point(location.x, location.y);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}