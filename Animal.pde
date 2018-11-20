class Wolf extends Animal implements ICarnivore {

  Wolf(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "Wolf";
    config();

    //setSkin("wolf.png");
  }
  Wolf(World _world) {
    super(_world);
    name = "Wolf";
    config();
  }

  void config() {
    stomachFull = 1000;
    stomach = 1000;
    setMemory(1000);
    setVisibility(100);
    iconType = "Square";

    addSense(new PredatorVision(this));
    addBehavior(new Hunt(this, "Sheep"));
    //addBehavior(new Hunt(this, "Wolf"));
    addBehavior(new Wander(this));
  }
  void executeBehaviors() {
    IBehavior aHunt = behaviors.get(0);
    IBehavior aWander = behaviors.get(1);

    if (aHunt.execute() == false) { // no target
      if (aWander.execute() == true) {
        activeBehavior = "Wander";
      }
    } else {
      activeBehavior = "Hunt";  //  hunting
    }
    determineColor();
  }



  boolean isCarnivore() {
    return true;
  }

  void drawSenseCone() {
    if (hasTarget()) {
      super.drawSenseCone(color(255, 0, 0, 100));
    } else {
      super.drawSenseCone(color(100, 100));
    }
  }
}

class Sheep extends Animal implements IHerbivore {

  Sheep(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "Sheep";
    //setSkin("cow.png");
    config();
  }
  Sheep(World _world) {
    super(_world);
    name = "Sheep";
    config();
  }

  void config() {
    addSense(new PreyVision(this));
    //addBehavior(new Avoid(this, "Wolf"));
    addBehavior(new Graze(this));
    //addBehavior(new Mate(this, "Sheep"));
    addBehavior(new Wander(this));
    setVisibility(100);
    iconType = "Circle";
  }
  boolean isHerbavore() {
    return true;
  }
}


class Animal implements ICanMove, ICanMate, ICanTrack, IHaveParticle, ISensable, ICanSense, IClickable, ICanDie, IReportable {
  // -----------------------------------------------------------------------------
  // Variables
  // -----------------------------------------------------------------------------

  World world;
  Particle particle;
  ICanMate mate;
  Animal target = null;

  String name = "Animal";
  String iconType = "Circle";
  String activeBehavior = null;
  String skinFn;
  PImage skin;

  ArrayList<ISenseStrategy> senses;
  ArrayList<ICanSense> iSensedBy;
  ArrayList<Observation> iObserved;
  ArrayList<IBehavior> behaviors;

  boolean showSightLine = true;
  boolean showSenseCone = false;
  boolean sensed;
  boolean dead = false;
  boolean tagged = false;
  boolean hasSkin = false;

  int iconColor = 0;
  int children = 0;
  int ticksSinceLastChild = 0;
  int behaviorCounter = 1;
  int skinSize = 100;
  int col;

  float stomachFull = 300;
  float stomach = stomachFull;
  float memory = 0;
  float visibility = 100;
  float maxpSize = 50;
  float pSize = maxpSize;


  // ----------------------------------------------------------------------------------
  // Constructors and Initializers
  // ----------------------------------------------------------------------------------

  Animal(int _id, World _world, float _ex, float _ey, float _rot) {
    world = _world;
    particle = new Particle(_world, _ex, _ey, _rot);
    
    senses = new ArrayList<ISenseStrategy>();
    iSensedBy = new ArrayList<ICanSense>();
    iObserved = new ArrayList<Observation>();
    behaviors = new ArrayList<IBehavior>();

    getParticle().setId(_id);
    setupAnimal();
  }

  Animal(World _world) {
    world = _world;
    particle = new Particle(_world, 0, 0, 0);
    
    senses = new ArrayList<ISenseStrategy>();
    iSensedBy = new ArrayList<ICanSense>();
    iObserved = new ArrayList<Observation>();
    behaviors = new ArrayList<IBehavior>();

    getParticle().setId(-1);

    randomize();
    setupAnimal();
    
    
    
  }

  void setupAnimal() {
    stomach = int(random(stomachFull/2, stomachFull));
    behaviors = new ArrayList<IBehavior>();
  }

  void addBehavior(IBehavior newB) {
    int newId = getId()*1000 + behaviorCounter++;
    newB.setId(newId);
    behaviors.add(newB);
  }
  void addSense(ISenseStrategy _senseStrategy) {
    senses.add(_senseStrategy);
  }

  void loadSkin() {
    //if (hasSkin) {
    //  skin = loadImage(skinFn);
    //  skin.resize(skinSize, skinSize);  // assume square image
    //}
  }
  void setSkin(String _fn) {
    //skinFn = _fn;
    //hasSkin = true;
  }
  // ----------------------------------------------------------------------------------
  // getters and setters
  // ----------------------------------------------------------------------------------
  float getStomach() {
    return stomach/stomachFull;
  }
  Animal getTarget() {
    return target;
  }
  void setTarget(ISensable _target) {
    target = (Animal)_target;
  }

  float getStomachFull() {
    return stomachFull;
  }

  String getObjectName() {
    return name;
  }

  void setChild(boolean flag) {
    if (flag) {
      setTick(0);
    } else {
      setTick(1000);
    }
  }
  float getMemory() {
    return memory;
  }
  void setMemory(float _mem) {
    memory = _mem;
  }
  // -----------------------------------------------------------------------------
  float getVisibility() {
    return visibility;
  }
  void setVisibility(float _v) {
    visibility = _v;
  }
  Observation getObservation() {
    return new Observation(this);
  }

  ArrayList<Observation> getObserved() {
    return iObserved;
  }
  void toggleTagged() {
    tagged = !tagged;
    if (tagged) {
      showSenseCone = true;
    }
  }


  // -----------------------------------------------------------------------------
  // REPORTING
  // -----------------------------------------------------------------------------

  ArrayList<String> getReport() {
    ArrayList<String> myData = new ArrayList<String>();
    myData.add("Name:");
    myData.add(getObjectName());
    myData.add("Id:");
    myData.add(str(getId()));
    myData.add("Stomach:");
    myData.add(str(stomach));
    myData.add("Memory:");
    myData.add(str(getMemory()));
    myData.add("Active Behavior: ");
    myData.add(activeBehavior);

    myData.addAll(senses.get(0).getReport());

    String obsList = "";
    int i = 0;
    for (Observation obs : iObserved) {
      obsList += str(obs.parent.getId());
      if (i++ < iObserved.size() - 1) {
        obsList += ", ";
      }
    }

    myData.add("Objects in Memory:");
    myData.add(obsList);

    for (IBehavior b : behaviors) {
      if (b.getObjectName() == "Hunt" && tagged == true ) {
        myData.addAll(b.getReport());
        break;
      }
    }

    return myData;
  }


  void selfReport() {
    if (tagged) {
      Report(this);
    }
  }


  // ----------------------------------------------------------------------------------
  // state getters
  // ----------------------------------------------------------------------------------

  boolean isHungry() {
    return stomach < .2*stomachFull;
  }
  boolean isFull() {
    return stomach > .7*stomachFull;
  }

  boolean hasMate() {
    return mate != null;
  }
  boolean hasTarget() {
    return target != null;
  }

  boolean isAdult() {
    return getTick() > 1000;
  }

  boolean isTagged() {
    return tagged;
  }

  // -----------------------------------------------------------------------------
  // IHaveParticle Interface Prereqs
  // -----------------------------------------------------------------------------

  Particle getParticle() {
    return particle;
  }
  int getId() {
    return getParticle().getId();
  }
  void setId(int _id) {
    getParticle().setId(_id);
  }

  float px() {
    return getParticle().px();
  }

  float py() {
    return getParticle().py();
  }

  float ex() {
    return getParticle().ex();
  }
  float ey() {
    return getParticle().ey();
  }
  void ex(float _ex) {
    getParticle().ex(_ex);
  }
  void ey(float _ey) {
    getParticle().ey(_ey);
  }

  void setColor(int _color) {
    col = _color;
  }
  int getColor() {
    return col;
  }
  World getWorld() {
    return getParticle().world;
  }

  float getRotation() {
    return getParticle().getRotation();
  }
  void setRotation(float _rot) {
    getParticle().setRotation(_rot);
  }
  float getBearing() {
    return getParticle().getBearing();
  }
  void setBearing(float _bearing) {
    getParticle().setBearing(_bearing);
  }

  float bearingTo(IHaveParticle p1, IHaveParticle p2) {
    return getParticle().bearingTo(p1.getParticle(), p2.getParticle());
  }
  float distanceTo(IHaveParticle _p) {
    return getParticle().distanceTo(_p.getParticle()) ;
  }

  boolean outOfBounds() {
    return getParticle().outOfBounds();
  }

  void rotateTo(IHaveParticle _p) {
    getParticle().rotateTo(_p.getParticle());
  }

  void moveOnBearing(float _dist) {
    getParticle().moveOnBearing(_dist);
  }

  int getTick() {
    return getParticle().getTick();
  }

  void addTick() {
    getParticle().addTick();
  }
  void setTick(int _tick) {
    getParticle().tickCounter = _tick;
  }

  void kill() {
    dead = true;
    if (dead == true) {
      world.dinner((Animal) this);
    }
    Console(name + " [" + getId() + "] is dead.");
  }
  boolean isDead() {
    return dead;
  }


  // ----------------------------------------------------------------------------------
  // main methods
  // ---------------------------------------------------------------------------------- 

  void randomize() {
    ex(random(-world.worldWidth/2, +world.worldWidth/2));
    ey(random(-world.worldHeight/2, +world.worldHeight/2));
    getParticle().tickCounter = int(random(0, 2000));
  }

  void tick(int _tick) {
    addTick();
    if (!isAdult()) {
      pSize = maxpSize *.5;
    } else {
      pSize = maxpSize;
    }
    //sense();
    execute();
    //Console(this);
  }
  void clone(Animal animal) {
    ex(animal.ex());
    ey(animal.ey());
  }






  void feed(float _food) {
    stomach += _food;
    if (stomach > stomachFull) {
      stomach = stomachFull;
    }
  }

  void burnFood(float _food) {
    stomach -= _food;
    if (stomach < 0) {
      stomach = 0;  // can't starve to death
    }
  }

  void execute() {
    executeBehaviors();
    setIconColor();
    sense();
    selfReport();
  }

  void executeBehaviors() {

    for (int i = 0; i < behaviors.size(); i++) {

      if (behaviors.get(i).execute()) {
        activeBehavior = behaviors.get(i).getObjectName();
        determineColor();
        break;
      }
    }
  }
  void determineColor() {

    switch(activeBehavior) {
    case "Hunt":
      setColor(color(255, 0, 0));
      break;
    case "Avoid":
      setColor(color(255, 255, 0));
      break;
    case "Graze":
      setColor(color(0, 250, 0));
      break;
    case "Wander":
      setColor(color(255, 255, 255));
      break;

    case "Mate":
      setColor(color(254, 58, 145));
      break;
    }
  }
  void setIconColor() {
    iconColor = lerpColor(color(255, 0, 0), color(0, 255, 0), getStomach());
  }
  void move(float dist) {

    if (outOfBounds()) {
      if (px()> swamp.screenWidth-10) {
        getParticle().ex(-swamp.worldWidth/2+20);
      } else if (px() < 10) {
        getParticle().ex(swamp.worldWidth/2-20);
      }
      if (py() > swamp.screenHeight-10) {  // bottom
        getParticle().ey(swamp.worldHeight/2-20);  // top
      } else if (py() < 10) { // top
        getParticle().ey(-swamp.worldHeight+20);  // bottom
      }
    }
    setBearing(getRotation());
    moveOnBearing(dist);
  }
  ArrayList<Observation> sense() {
    iObserved.clear();
    for (ISenseStrategy iss : senses) {
      iObserved.addAll(iss.sense());
    }
    removeDuplicates();
    deleteAgedObservations();
    return iObserved;
  }
  void addSensedBy(ICanSense p) { 
    sensed = true;
    //col = color(0, 255, 0);
    iSensedBy.add(p);
  }

  void removeSensedBy(ICanSense s) {
    sensed = false;

    while (iSensedBy.remove(s)) {  
      // remove all instances of s in list
    }
  }




  void deleteAgedObservations() {
    for (int i = iObserved.size() - 1; i >= 0; i--) {
      if (iObserved.get(i).getAge() > 1 || iObserved.get(i).parent.isDead()) {
        iObserved.remove(i);
      }
    }
  }

  void removeDuplicates() {
    for (int i = 0; i < iObserved.size(); i++) {
      for (int ii = iObserved.size() - 1; ii > i; ii--) {
        if (iObserved.get(i).parent == iObserved.get(ii).parent ) {
          iObserved.remove(ii);
        }
      }
    }
  }
  void deleteObservationById(int _id) {
    for (int i = iObserved.size() - 1; i >= 0; i--) {
      if (iObserved.get(i).getId() == _id) {
        iObserved.remove(i);
      }
    }
  }


  // -----------------------------------------------------------------------------
  // Draw Methods
  // ----------------------------------------------------------------------------- 

  void draw() {

    if (!isDead()) {
      imageMode(CENTER);

      pushMatrix();
      pushStyle();
      translate(px(), py());


      drawIcon();
      //fill(col);
      line(-250, 0, 250, 0);  // center X
      line(0, -250, 0, 250);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(30);
      text(getId(), 0, 0);
      pushStyle();
      rotate(getRotation());
      fill(col);
      if (hasSkin) {
        image(skin, 0, 0);
      } 

      if (showSenseCone) {
        drawSenseCone();
      }
      if (showSightLine) {
        line(0, 0, pSize/2, 0);
      }

      popMatrix();
      popStyle();
      popStyle();
    }
  }
  void drawSenseCone() {

    if (showSenseCone) {
      for (ISenseStrategy iss : senses) {
        iss.drawSenseCone(color(255, 0, 0, 100));
      }
    }
  }
  void drawSenseCone(int _col) {
    for (ISenseStrategy iss : senses) {
      iss.drawSenseCone(_col);
    }
  }
  void drawIcon() {

    pushStyle();
    stroke(iconColor);
    strokeWeight(6);
    fill(col);
    switch(iconType) {

    case "Circle":
      ellipse(0, 0, pSize, pSize);
      break;
    case "Square":
      rect(-pSize/2, -pSize/2, pSize, pSize);
      break;
    case "Triangle":
      triangle(0, -pSize/2, pSize/2, pSize/2, -pSize/2, pSize/2);
      break;
    }
    popStyle();
  }


  String toString() {

    String s = "[" + getId() + "] " + name + " -- observed: " + iObserved.size() + " children: " + children;
    return s;
  }


  // --------------------------------------------------------------------------------------
  // MOUSE CONTROL HANDLERS
  //  -------------------------------------------------------------------------------------
  boolean mouseOver() {
    float dx = abs(mouseX - px());
    float dy = abs(mouseY - py());
    float dist = sqrt(dx*dx+dy*dy);
    if (dist <= pSize) {  // mouse is over
      return true;
    } else {
      return false;
    }
  }

  void mouseDragged() {

    float xOffset = px() - mouseX;
    float yOffset = py() - mouseY;
    //Console("xOffset:" + xOffset + ", yOffset:" + yOffset);
    ex(ex() - xOffset);
    ey(ey() + yOffset);
  }

  void mouseClicked() {
    //if (col == color(255, 0, 0)) {
    //  col = 255;
    //} else {
    //  col = color(255, 0, 0);
    //}
  }
}








class AnimalFactory {
  World world;

  AnimalFactory(World _world) {

    world = _world;
  }

  Animal getAnimal(String _type) {

    switch(_type) {
    case "Wolf":  
      return new Wolf(world);
    case "Sheep":
      return new Sheep(world);
    default:
      return null;
    }
  }
}
