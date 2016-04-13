ArrayList<Dot> dots;

boolean snap;

void setup() {
  size(500, 500);
  smooth();
  dots = new ArrayList<Dot>();

  int numH = 40;
  int numV = 40;
  float space = 10;
  float ox = (width - space * (numH-1)) / 2;
  float oy = (height - space * (numV-1)) / 2;  

  for (int j=0; j<numV; j++) {  
    for (int i=0; i<numH; i++) {
      PVector g = new PVector(ox + space * i, oy + space * j);
      Dot d = new Dot(g, i, j);
      dots.add(d);
    }
  }
}

void draw() {
   background(0);
   //fill(255);
   stroke(255);
   //noStroke();
  for (Dot d : dots){
    d.bouge();
    d.affiche();
    
    float distance = dist(d.pos.x, d.pos.y, mouseX, mouseY);
    if (distance < 50) {
      d.dpos.x = d.pos.x + (d.pos.x - mouseX); 
      d.dpos.y = d.pos.y + (d.pos.y - mouseY);
    } else {
      d.dpos = d.gpos.get();
    }
  } 
}

class Dot {
  PVector gpos, dpos, pos;
  int px, py;

  Dot(PVector gpos, int px, int py) {
    this.px = px;
    this.py = py;
    this.gpos = gpos.get();
   // pos = new PVector(random(width), random(height));
     pos = new PVector(width/2, height/2);
    dpos = gpos.get();
  }

  void bouge() {
   pos.x += (dpos.x - pos.x) * 0.05;
   pos.y += (dpos.y - pos.y) * 0.05;
  }

  void affiche() {
    point(pos.x, pos.y);
    //rect(pos.x, pos.y, 3, 3);
  }
}