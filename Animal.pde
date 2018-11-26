class Animal implements ICanMove, ICanMate, ICanTrack, IHaveParticle, ISensable, ICanSense, IClickable, ICanDie, IReportable{
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
  String animalsMurdered = "";
  PImage skin;

  ArrayList<ISenseStrategy> senses;
  ArrayList<ICanSense> iSensedBy;
  ArrayList<Observation> iObserved;
  ArrayList<IBehavior> behaviors;

  StringList preyTypes, predatorTypes;


  boolean showSightLine = false;
  boolean showSenseCone = false;
  boolean showAngleMarks = false;
  boolean showTrackLine = true;
  boolean sensed;
  boolean dead = false;
  boolean tagged = false;
  boolean iAmSelected = false;
  boolean hasSkin = false;

  int iconColor = 0;
  int animalTextColor = 0;
  int children = 0;
  int lastChildTick = 0;
  int behaviorCounter = 1;
  int skinSize = 100;
  int col;
  int numberMurdered = 0;


  float stomachFull = 300;
  float stomach = stomachFull;
  float memory = 0;
  float visibility = 100;
  float maxpSize = 50;
  float pSize = maxpSize;
  float mateRate = 0;
  float walkStep = 1;
  float runStep = 2;


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
    animalsMurdered = "";


    getParticle().setId(_id);
    setupAnimal();
  }
  Animal(Animal _a) {
     setId(_a.getId());
     world = _a.world;
     ex(_a.ex());
     ey(_a.ey());
     setRotation(_a.getRotation());
    
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

  void randomize() {
    ex(random(-world.screenWidth/2, +world.screenWidth/2));
    ey(random(-world.screenHeight/2, +world.screenHeight/2));
    getParticle().tickCounter = int(random(0, 2000));
  }

  void setupAnimal() {
    stomach = int(random(stomachFull/2, stomachFull));
    behaviors = new ArrayList<IBehavior>();
    preyTypes = new StringList();
    predatorTypes = new StringList();
  }

  void setPreyTypes(StringList args) {
    preyTypes.append(args);
  }
  StringList getPreyTypes() {

    return preyTypes;
  }
  void setPredatorTypes(StringList args) {
    predatorTypes.append(args);
  }
  StringList getPredatorTypes() {

    return predatorTypes;
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
  void setStomach(float _stomach) {
    stomach = _stomach;
  }
  float getMateRate() {
    return mateRate;
  }
  void setMateRate(float _rate) {
    mateRate = _rate;
  }
  boolean isReadyToMate() {
    return getTick() - getLastChildTick() > getMateRate();
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
  int getNumberChildren() {
    return children;
  }
  String getAnimalsMurdered() {

    return animalsMurdered;
  }
  int getNumberAnimalsMurdered() {
    return numberMurdered;
  }
  void addAnimalsMurdered(int a) {
    numberMurdered++;
    if (animalsMurdered == "") {
      animalsMurdered = str(a);
    } else {
      animalsMurdered += ", " + str(a);
    }
  }
  float getMemory() {
    return memory;
  }
  void setMemory(float _mem) {
    memory = _mem;
  }
  float getWalkRate() {
    return walkStep;
  }
  void setWalkRate(float _walk) {
    walkStep = _walk;
  }
  float getRunRate() {
    return (getStomach() > .2) ? runStep : walkStep;
  }
  void setRunRate(float _run) {
    runStep = _run;
  }
  int getLastChildTick() {
    return lastChildTick;
  }
  void setLastChildTick(int _tick) {
    lastChildTick = _tick;
  }

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

  void setSelected(boolean _flag) {
    iAmSelected = _flag;
    toggleTagged(_flag);
  }
  boolean isSelected() {
    return iAmSelected;
  }
  void toggleTagged(boolean _flag) {
    tagged = _flag;
    if (tagged) {
      showSenseCone = true;
      animalTextColor = color(0, 0, 255);
    } else {
      showSenseCone = false;
      animalTextColor = 0;
    }
  }
  void toggleTagged() {
    toggleTagged(!isTagged());
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
    myData.add("Children:");
    myData.add(str(children));
    myData.add("Animals Murdered:");
    myData.add(getAnimalsMurdered());
    myData.add("Stomach:");
    myData.add(str(stomach));
    myData.add("Run Rate:");
    myData.add(str(getRunRate()));
    myData.add("Memory:");
    myData.add(str(getMemory()));
    myData.add("Active Behavior: ");
    myData.add(activeBehavior);

    myData.addAll(senses.get(0).getReport());  // assumes only one sense = vision

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
      world.animalReport.output(this);
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

  void die() {
    dead = true;
    if (dead == true) {
      world.addMurdered();
    }
  }
  boolean isDead() {
    return dead;
  }



  // ----------------------------------------------------------------------------------
  // main methods
  // ---------------------------------------------------------------------------------- 


  void tick(int _tick) {
    if (!bFreeze) {
      addTick();
      if (!isAdult()) {
        pSize = maxpSize *.5;
      } else {
        pSize = maxpSize;
      }
    }

    execute();
  }
  void clone(Animal animal) {
    ex(animal.ex());
    ey(animal.ey());
  }

  Animal spawn() {
    Animal childAnimal = animalFactory.getAnimal(getObjectName());
    childAnimal.clone(this);
    children++;
    feed(childAnimal.getStomachFull());  // child starts full
    childAnimal.setChild(true);
    setStomach(getStomach()/2); // parent loses half stomach
    world.addAnimal(childAnimal);
    setLastChildTick(getTick());
    return childAnimal;
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
      setColor(color(209, 62, 62));
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
    case "Cannibalize":
      setColor(color(255, 0, 0));
      break;
    default:
      setColor(0);
      break;
    }
  }
  void setIconColor() {
    iconColor = lerpColor(color(255, 0, 0), color(0, 255, 0), getStomach());
  }
  void move(float dist) {
    if (!bFreeze) {
      if (outOfBounds()) {
        if (px()> swamp.worldWidth-10) {
          getParticle().ex(-swamp.worldWidth/2+20);
        } else if (px() < 10) {
          getParticle().ex(swamp.worldWidth/2-20);
        }
        if (py() > swamp.worldHeight-10) {  // bottom
          getParticle().ey(swamp.worldHeight/2-20);  // top
        } else if (py() < 10) { // top
          getParticle().ey(-swamp.worldHeight+20);  // bottom
        }
      }
      setBearing(getRotation());
      moveOnBearing(dist);
    }
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

      if (showAngleMarks) {
        line(-250, 0, 250, 0);  // center X
        line(0, -250, 0, 250);
      }
      fill(animalTextColor);
      textAlign(CENTER, CENTER);
      textSize(30);
      text(getId(), 0, 0);
      pushStyle();

      if (showSenseCone) {
        drawSenseCone();
      }
      if (showSightLine) {
        line(0, 0, pSize/2, 0);
      }
      if (showTrackLine) {
        drawTrackLine();
      }

      rotate(getRotation());
      fill(col);
      if (hasSkin) {
        image(skin, 0, 0);
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
  void drawTrackLine() {
    for (IBehavior b : behaviors) {
      b.drawTrackLine();
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
    case "Triangle":
      triangle(0, -pSize/2, pSize/2, pSize/2, -pSize/2, pSize/2);
      break;
    case "Square":
      rect(-pSize/2, -pSize/2, pSize, pSize);
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
    if (bToMouse) {
      getParticle().rotateToMouse();
    }
  }
}
