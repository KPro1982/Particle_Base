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
    setColor();
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


class Animal extends Entity implements ICanMove, ICanMate, ICanTrack, IReportable {
  String name = "Animal";
  String iconType = "Circle";
  int iconColor = 0;
  float stomachFull = 300;
  float stomach = stomachFull;
  float memory = 0;
  int children = 0;
  ICanMate mate;
  int ticksSinceLastChild = 0;
  ArrayList<IBehavior> behaviors;
  int behaviorCounter = 1;
  String activeBehavior = null;
  Animal target = null;


  // ----------------------------------------------------------------------------------
  // Constructors and Initializers
  // ----------------------------------------------------------------------------------

  Animal(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_world, _ex, _ey, _rot);
    getParticle().setId(_id);
    setupAnimal();
  }

  Animal(World _world) {
    super(_world, 0, 0, 0);
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

  String getName() {
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

  ArrayList<String> getReport() {
    ArrayList<String> myData = new ArrayList<String>();
    myData.add("Name:");
    myData.add(getName());
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
      if (b.getName() == "Hunt" && tagged == true ) {
        myData.addAll(b.getReport());
        break;
      }
    }

    return myData;
  }

  void toggleTagged() {
    super.toggleTagged();
    //for (IBehavior b : behaviors) {
    //  b.toggleTagged();
    //}
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
        activeBehavior = behaviors.get(i).getName();
        setColor();
        break;
      }
    }
  }
  void setColor() {

    switch(activeBehavior) {
    case "Hunt":
      entityColor(color(255, 0, 0));
      break;
    case "Avoid":
      entityColor(color(255, 255, 0));
      break;
    case "Graze":
      entityColor(color(0, 250, 0));
      break;
    case "Wander":
      entityColor(color(255, 255, 255));
      break;

    case "Mate":
      entityColor(color(254, 58, 145));
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
    iObserved.addAll(super.sense());
    removeDuplicates();
    deleteAgedObservations();
    return iObserved;
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
}

class AnimalFactory {
  World world = null;

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
