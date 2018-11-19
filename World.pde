class World {

  boolean showAxes = true;

  float screenWidth, screenHeight, worldWidth, worldHeight;
  ArrayList<Animal> entities;
  Entity selected;
  int nextId = 0;
  int tickCounter = 0;


  World(float _screenWidth, float _screenHeight, float _worldWidth, float _worldHeight) {
    screenWidth = _screenWidth; 
    screenHeight = _screenHeight;
    worldWidth = _worldWidth;
    worldHeight = _worldHeight;
    entities = new ArrayList<Animal>();
  }

  void addParticle(Animal _p) {

    entities.add(_p);
  }
  void addAnimal(Animal _animal) {
    _animal.setId(nextId++);
    entities.add(_animal);
  }

  void setup() {

    for (Entity p : entities) {
      p.loadSkin();
    }
    selected = entities.get(0);
  }

  //void sortByDistance(Entity p) {

  //  Collections.sort(entities, new DistanceComparator(p));
  //}  

  void print() {
    for (Entity p : entities) {
      Console(p);
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

  void tick() {
    tickCounter++;
    for (int i = entities.size() - 1; i >=0; i--) {
      Animal p = entities.get(i);
      p.tick(tickCounter);
    }
  }

  void dinner(Animal p) {
    entities.remove(p);  // remove dead bodies
    Console("Carcass Eaten");
  }

  //void execute() {
  //  for (Animal a : entities) {
  //     a.execute(); 
  //  }

  //}
  Animal isMouseOver() {

    for (Animal p : entities) {
      if (p.mouseOver()) {  // assumes that mouse is over only one object at  a time
        return p;
      } else {
      }
    }
    return null;
  }
  void mouseDragged() {
    Animal p = isMouseOver();
    if (p != null) {
      p.mouseDragged();
      p.execute();
    }
  }
  void mouseClicked() {
    Animal p = isMouseOver();
    if (p != null) {
      p.mouseClicked();
      //p.toggleTagged();
    }
  }
  void mouseReleased() {
    tick();
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
