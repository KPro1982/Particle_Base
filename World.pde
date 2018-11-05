class World {

  boolean showAxes = true;

  float screenWidth, screenHeight, worldWidth, worldHeight;
  ArrayList<Particle> particles;
  Particle selected;


  World(float _screenWidth, float _screenHeight, float _worldWidth, float _worldHeight) {
    screenWidth = _screenWidth; 
    screenHeight = _screenHeight;
    worldWidth = _worldWidth;
    worldHeight = _worldHeight;
    particles = new ArrayList<Particle>();
  }

  void addParticle(Particle _p) {

    particles.add(_p);
  }

  void createParticle() {
    Particle p = new LadyBug(this);
    p.loadSkin();
    particles.add(p);
    
  }

  void createParticle(float _ex, float _ey, float _rot) {
    particles.add(new LadyBug(this, _ex, _ey, _rot));
  }

  void setup() {

    for (Particle p : particles) {
      p.loadSkin();
    }
    selected = particles.get(0);
  }


  void draw() {
    background(200);
    pushStyle();
    stroke(225);
    if (showAxes) {
      line(screenWidth/2, 0, screenWidth/2, screenHeight);  // draw y - axis
      line(0, screenHeight/2, screenWidth, screenHeight/2);  // draw x - axis
    }
    popStyle();

    for (Particle p : particles) {

      p.draw();
    }
  }

  void run() {

 

    for (Particle p : particles) {
      p.run();
    }
  }

  Particle isMouseOver() {

    for (Particle p : particles) {
      if (p.mouseOver()) {  // assumes that mouse is over only one object at  a time
        return p;
      } else {

      }
    }
    return null;
  }
  void setSelected(Particle _p) {

    if (selected != null) {  // reset old selected
      selected.isSelected = false;
    }
    
    if (_p != null) {  // set new particle as slected
      selected = _p;
      selected.isSelected = true;
    }
  }
}
