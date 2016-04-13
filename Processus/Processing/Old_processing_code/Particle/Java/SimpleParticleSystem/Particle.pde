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
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));

    //velocity = new PVector(random(-1, 1), random(-1, 1));
    //location = l.get();
    location = new PVector(mouseX - width/2, mouseY - height/2);
    /////////////////////////////////////////////
  
    location.limit(radius);
   
    /////////////////////////////////////////////
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
    /////////////////////////////////////////////
    if (location.dist(origin) > radius) {
    PVector n = location.get();
    n.normalize();
    n.mult(2*n.dot(velocity));
    velocity.sub(n);
    }
    /////////////////////////////////////////////
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
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