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

int diametreZone = 400;

void setup() {
  size(400, 400);
  pixelDensity(2);
  ps = new ParticleSystem(new PVector(width/2, 50));
}

void draw() {
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  ps.addParticle(diametreZone/2);
  ps.run(mouseX, mouseY);
  popMatrix();

  noFill();
  stroke(255);
  strokeWeight(2);
  ellipse(width/2, height/2, diametreZone, diametreZone);
}