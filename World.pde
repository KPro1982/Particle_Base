class World {

  boolean showAxes = true;

  float screenWidth, screenHeight, worldWidth, worldHeight;
  ArrayList<Entity> entities;
  Entity selected;
  int nextId = 0;


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

  void createParticle() {
    if (random(0, 2) > 1.2) {
      entities.add(new Wolf(nextId++, this, random(-worldWidth/2,+worldWidth/2), random(-worldHeight/2,+worldHeight/2), random(0,2*PI)));
    } else {
      entities.add(new Cow(nextId++, this, random(-worldWidth/2,+worldWidth/2), random(-worldHeight/2,+worldHeight/2), random(0,2*PI)));
    }
  }

  void createParticle(float _ex, float _ey, float _rot) {
    if (random(0, 2) > 1.5) {
      entities.add(new Wolf(nextId++, this, _ex, _ey, _rot));
    } else {
      entities.add(new Cow(nextId++, this, _ex, _ey, _rot));
    }
  }

  void setup() {

    for (Entity p : entities) {
      p.loadSkin();
    }
    selected = entities.get(0);
  }

  void sortByDistance(Entity p) {

    Collections.sort(entities, new DistanceComparator(p));
  }

  void print() {
    for (Entity p : entities) {
      println(p);
    }
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

  void step() {

    for (Entity p : entities) {
      ((Animal) p).step();
    }
  }

  void sense() {

    for (Entity p : entities) {
      ((Animal) p).sense();
    }
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
      sense();
    }
  }
  void mouseClicked() {
    Entity p = isMouseOver();
    if (p != null) {
      p.mouseClicked();
      println(p);
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
