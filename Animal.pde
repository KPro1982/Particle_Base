class Wolf extends Animal implements ICarnivore {

  Wolf(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "Wolf";
    addSense(new PredatorVision(this));
    addBehavior(new Hunt(this, new Cow(world)));
    addBehavior(new Hunt(this, new Wolf(world)));
    addBehavior(new Wander(this));
    setVisibility(100);
    //setSkin("wolf.png");
    iconType = "Triangle";
  }
  Wolf(World _world) {
    super(_world);
    name = "Wolf";
  }
  boolean isCarnivore() {
    return true;
  }
}

class Cow extends Animal implements IHerbivore {

  Cow(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "Cow";
    addSense(new PreyVision(this));

    addBehavior(new Avoid(this, new Wolf(world)));
    addBehavior(new Graze(this));
    addBehavior(new Mate(this, new Cow(world)));
    addBehavior(new Wander(this));

    setVisibility(100);
    //setSkin("cow.png");
    iconType = "Circle";
  }
  Cow(World _world) {
    super(_world);
    name = "Cow";
  }
  boolean isHerbavore() {
    return true;
  }
}


class Animal extends Entity implements ICanMove, ICanMate, ICanTrack, IReportable {
  String name = "Animal";
  String iconType = "Circle";
  float stomach = 5;
  float hungerThresh = 0;
  float stomachFull = 300;
  float memory = 300;
  int children = 0;
  ICanMate mate;
  int ticksSinceLastChild = 0;
  ArrayList<IBehavior> behaviors;
  int behaviorCounter = 1;
  String activeBehavior = null;


  // ----------------------------------------------------------------------------------
  // Constructors and Initializers
  // ----------------------------------------------------------------------------------

  Animal(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_world, _ex, _ey, _rot);
    getParticle().setId(_id);
    stomach = int(random(0, stomachFull));
    behaviors = new ArrayList<IBehavior>();
  }

  Animal(World _world) {
    super(_world, 0, 0, 0);
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
    return stomach;
  }

  float getStomachFull() {
    return stomachFull;
  }

  String getName() {
    return name;
  }

  ArrayList<String> getReport() {
    ArrayList<String> myData = new ArrayList<String>();
    myData.add("Name:");
    myData.add(getName());
    myData.add("Id:");
    myData.add(str(getId()));
    myData.addAll(senses.get(0).getReport());

    String obsList = "";
    int i = 0;
    for (Observation obs : iObserved) {
      obsList += str(obs.parent.getId());
      if (i++ < iObserved.size() - 1) {
        obsList += ", ";
      }
    }

    myData.add("Observed Objects:");
    myData.add(obsList);
    return myData;
  }

  void toggleTagged() {
    super.toggleTagged();
    for (IBehavior b : behaviors) {
      //b.toggleTagged();
    }
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
    return stomach < hungerThresh;
  }

  boolean hasMate() {
    return mate != null;
  }



  // ----------------------------------------------------------------------------------
  // main methods
  // ---------------------------------------------------------------------------------- 



  void tick(int _tick) {
    addTick();
    sense();
    execute();
    //Console(this);
  }





  void feed(float _food) {
    stomach += _food;
  }

  void burnFood(float _food) {
    stomach -= _food;
  }

  void execute() {
    for (int i = 0; i < behaviors.size(); i++) {
     
      if(behaviors.get(i).execute()) {
        activeBehavior = behaviors.get(i).getName();
        setColor();
        break;
      }
      
    }
    sense();
    selfReport();
  }
  void setColor() {

    switch(activeBehavior) {
    case "Hunt":
      entityColor(color(255, 0, 0));
      break;
    case "Avoid":
      entityColor(color(238, 232, 170));
      break;
    case "Graze":
      entityColor(color(0, 250, 0));
      break;
    case "Wander":
      entityColor(color(255, 218, 185));
      break;
    
    case "Mate":
      entityColor(color(150,100,100));
      break;
    }
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
      if (iObserved.get(i).getAge() > memory) {
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

    switch(iconType) {
    case "Circle":
      ellipse(0, 0, pSize, pSize);
      break;
    case "Square":
      rect(-pSize/2, -pSize/2, pSize, pSize);
      break;
    case "Triangle":
      triangle(0, -pSize, pSize, pSize, -pSize, pSize);
      break;
    }
  }


  String toString() {

    String s = "[" + getId() + "] " + name + " -- observed: " + iObserved.size() + " children: " + children;
    return s;
  }
}
