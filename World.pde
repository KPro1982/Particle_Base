class World {

  boolean showAxes = true;

  float screenWidth, screenHeight, worldWidth, worldHeight;
  ArrayList<Entity> entities;
  Entity selected;


  World(float _screenWidth, float _screenHeight, float _worldWidth, float _worldHeight) {
    screenWidth = _screenWidth; 
    screenHeight = _screenHeight;
    worldWidth = _worldWidth;
    worldHeight = _worldHeight;
    entities = new ArrayList<Entity>();
  }

  void addParticle(Entity _p) {

    entities.add(_p);
  }

  //void createParticle() {
  //  Particle p = new LadyBug(this);
  //  p.loadSkin();
  //  entities.add(p);

  //}

  void createParticle(float _ex, float _ey, float _rot) {
    entities.add(new Entity(this, _ex, _ey, _rot));
  }

  void setup() {

    for (Entity p : entities) {
      p.loadSkin();
    }
    selected = entities.get(0);
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

    for (Entity p : entities) {

      p.draw();
    }
  }

  void run() {



    //for (Entity p : entities) {
    //  //p.particle.run();
    //}
  }

  Entity isMouseOver() {

    for (Entity p : entities) {
      if (p.mouseOver()) {  // assumes that mouse is over only one object at  a time
        return p;
      } else {
      }
    }
    return null;
  }
  void mouseDragged() {
    Entity p = isMouseOver();
    if (p != null) {
      p.mouseDragged();
    }
  }
   void mouseClicked() {
    Entity p = isMouseOver();
    if (p != null) {
      p.mouseClicked();
    }
  }
}


void setSelected(Entity _p) {

  //  if (selected != null) {  // reset old selected
  //    selected.isSelected = false;
  //  }

  //  if (_p != null) {  // set new particle as slected
  //    selected = _p;
  //    selected.isSelected = true;
  //  }
}
