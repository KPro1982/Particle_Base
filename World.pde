class World {


  boolean showAxes = true;

  float screenWidth, screenHeight, worldWidth, worldHeight;
  ArrayList<Entity> entities;
  ReportWindow animalReport, popReport;
  Entity selected = null;
  int nextId = 0;
  int tickCounter = 0;
  int murdered = 0;
  float scale = 1;
  float xOffset = 0;
  float yOffset = 0;



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
  void addAnimal(Entity _e) {
    _e.setId(nextId++);
    entities.add(_e);
  }
  void addMurdered() {
    murdered++;
  }
  void setup() {
    animalReport = new ReportWindow(this, "TOPRIGHT", 500, 800);
    popReport = new ReportWindow(this, "TOPLEFT", 500, 300);
    for (Entity p : entities) {
      //p.loadSkin();
    }
    selected = null;
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

    return new PVector(xOffset, yOffset);
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
  //void print() {
  //  for (Entity p : entities) {
  //    Console(p);
  //  }
  //}
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
  Entity findAnimal(int _id) {
    for (Entity a : entities) {
      if (a.getId() == _id) {
        return a;
      }
    }
    return null;
  }

  void tick() {
    tickCounter++;
    for (int i = entities.size() - 1; i >=0; i--) {
      Entity p = entities.get(i);
      p.tick(tickCounter);
    }
    reportPopulation();
  }
  void reportPopulation() {

    ArrayList<String> myData = new ArrayList();
    //myData.add("Ticks:");
    //myData.add(str(tickCounter));
    //myData.add("Total Population:");
    //myData.add(str(entities.size()) + "/" + countAnimal(false));
    //myData.add("Bears:");
    //myData.add(str(countAnimal("Bear")) + " (" + str(countAnimal("Bear", true)) + "/" + str(countAnimal("Bear", false)) + ")");
    //myData.add("Wolves:");
    //myData.add(str(countAnimal("Wolf")) + " (" + str(countAnimal("Wolf", true)) + "/" + str(countAnimal("Wolf", false)) + ")");
    //myData.add("Sheep:");
    //myData.add(str(countAnimal("Sheep")) + " (" + str(countAnimal("Sheep", true)) + "/" + str(countAnimal("Sheep", false)) + ")");
    //myData.add("Biggest Mama:");
    ////myData.add(str(biggestMama().getId()) + " (" + str(biggestMama().getNumberChildren())+ ")");
    ////myData.add("Murdered:");
    ////myData.add(str(murdered));
    ////myData.add("Serial Killer:");
    ////myData.add(str(highestMurders().getId()) + " (" + str(highestMurders().getNumberAnimalsMurdered())+ ")");



    popReport.output(myData);
  }
  //Entity highestMurders() {
  //  int currentRecord = 0;
    
  //  Entity serialKiller = null;
  //  for (Entity a : entities) {
  //    if (a.getNumberAnimalsMurdered() >= currentRecord) {
  //      serialKiller = a;
  //      currentRecord = a.getNumberAnimalsMurdered();
  //    }
  //  }

  //  return serialKiller;
  //}

  //Entity biggestMama() {
  //  int currentRecord = 0;
  //  Entity bigMama = null;
  //  for (Entity a : entities) {
  //    if (a.getNumberChildren() >= currentRecord) {
  //      bigMama = a;
  //      currentRecord = a.getNumberChildren();
  //    }
  //  }

  //  return bigMama;
  //}
  
  //int countAnimal(String _type, boolean _adult) {
  //  int i = 0;
  //  for (Animal a : animals) {
  //    if (a.getObjectName() == _type && a.isAdult() == _adult) {
  //      i++;
  //    }
  //  }
  //  return i;
  //}
  //int countAnimal(String _type) {
  //  int i = 0;
  //  for (Animal a : animals) {
  //    if (a.getObjectName() == _type) {
  //      i++;
  //    }
  //  }
  //  return i;
  //}

  //int countAnimal(boolean _adult) {
  //  int i = 0;
  //  for (Animal a : animals) {
  //    if (a.isAdult() == _adult) {
  //      i++;
  //    }
  //  }
  //  return i;
  //}

  void dinner(Entity p) {
    entities.remove(p);  // remove dead bodies
    Console("Carcass Eaten");
  }


  //void execute() {
  //  for (Animal a : animals) {
  //     a.execute(); 
  //  }

  //}
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
      tick();
    } else {

      for (Entity a : entities) {
        if (a.isTagged()) {
          a.getParticle().rotateToMouse();
        }
      }
    }
  }
  void mouseClicked() {
    Entity p = isMouseOver();
    if (p != null) {
      p.mouseClicked();
      setSelected(p);
    }
  }
  void mouseReleased() {
    tick();
  }



  void setSelected(Entity _p) {

    if (selected != null) {  // reset old selected
      selected.setSelected(false);
    }

    if (_p != null) {  // set new animal as selected
      selected = _p;
      selected.setSelected(true);
    }
  }
}
