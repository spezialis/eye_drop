/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity and fade out over time
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */

ParticleSystem ps;

int diametreZone = 500;
float force;
int delayTime;
//boolean diminuer;
//boolean augmenter;
//float augmente;
//float diminue;
float seed = 0;

void setup() {
  size(500, 500);
  //pixelDensity(2);
  ps = new ParticleSystem(new PVector(width/2, 50));
}

void draw() {
  noCursor();
  background(0);
  pushMatrix();
  translate(width/2, height/2);

  force = map(mouseX, 0, width, 0.1, 2);

  //seed += 0.01;
  //if (seed > 1000000) {
  //  seed = 0;
  //}

  //if (noise(seed) > 0.5) {
   //if(frameCount % 10 == 0) {
    ps.addParticle(diametreZone/2, force);
   //}
  //}

  // ps.addParticle(diametreZone/2,force);
  ps.run(mouseX, mouseY);
  popMatrix();

  noFill();
  stroke(255);
  strokeWeight(2);
  //ellipse(width/2, height/2, diametreZone, diametreZone);
}

void ajout() {
  delay(1000);
  ps.addParticle(diametreZone/2, force);
}