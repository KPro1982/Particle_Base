class World {

  boolean showAxes = true;

  float screenWidth, screenHeight, worldWidth, worldHeight;
  ArrayList<Animal> animals;
  Animal selected;
  int nextId = 0;
  int tickCounter = 0;
  float scale = 1;
  float xOffset = 0;
  float yOffset = 0;


  World(float _screenWidth, float _screenHeight, float _worldWidth, float _worldHeight) {
    screenWidth = _screenWidth; 
    screenHeight = _screenHeight;
    worldWidth = _worldWidth;
    worldHeight = _worldHeight;
    animals = new ArrayList<Animal>();
  }

  void addParticle(Animal _p) {

    animals.add(_p);
  }
  void addAnimal(Animal _animal) {
    _animal.setId(nextId++);
    animals.add(_animal);
  }

  void setup() {

    for (Animal p : animals) {
      //p.loadSkin();
    }
    selected = animals.get(0);
  }

  //void sortByDistance(Animal p) {

  //  Collections.sort(animals, new DistanceComparator(p));
  //}  


  float getScale() {
     return scale; 
  }
  void setScale(float _scale) {
    scale = _scale;
  }
  void addScale(float _scale) {
    scale += _scale;
    
  }
  PVector getOffset() {
    
    return new PVector(xOffset,yOffset);
  }
  void setOffset(PVector _offset) {
    xOffset = _offset.x;
    yOffset = _offset.y;
  }
    void addOffset(PVector _offset) {
    xOffset += _offset.x;
    yOffset += _offset.y;
  }
  float getScaleFactor() {
    if (scale < 0) 
    {
       return 1/abs(scale);
    } else {
      return scale;
      
    }
    
  }
  void print() {
    for (Animal p : animals) {
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

    for (Animal p : animals) {

      p.draw();
    }
  }

  void tick() {
    tickCounter++;
    for (int i = animals.size() - 1; i >=0; i--) {
      Animal p = animals.get(i);
      p.tick(tickCounter);
    }
  }

  void dinner(Animal p) {
    animals.remove(p);  // remove dead bodies
    Console("Carcass Eaten");
  }

  //void execute() {
  //  for (Animal a : animals) {
  //     a.execute(); 
  //  }

  //}
  Animal isMouseOver() {

    for (Animal p : animals) {
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
      tick();
    } else {

      for (Animal a : animals) {
        if (a.isTagged()) {
          a.getParticle().rotateToMouse();
        }
      }
    }
  }
  void mouseClicked() {
    Animal p = isMouseOver();
    if (p != null) {
      p.mouseClicked();
    }
  }
  void mouseReleased() {
    tick();
  }
}


void setSelected(Animal _p) {

  //  if (selected != null) {  // reset old selected
  //    selected.isSelected = false;
  //  }

  //  if (_p != null) {  // set new particle as slected
  //    selected = _p;
  //    selected.isSelected = true;
  //  }
}
