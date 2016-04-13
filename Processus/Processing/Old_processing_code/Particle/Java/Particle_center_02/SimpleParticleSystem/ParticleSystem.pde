// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle(int diam,float force) {
    particles.add(new Particle(origin, diam,force));
  }

  void run(float gravX, float gravY) {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run(gravX, gravY);
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}