class BaseBehavior implements IBehavior, IReportable {
  Animal self;
  boolean tagged = false;
  int behaviorID;
  String name = "";
  float averageStep = 1;
  float moveStep = averageStep;
  float averageFoodBurned = 1;
  float memoryCounter = 0;

  BaseBehavior(Animal _self) {
    behaviorID = 0;
    self = _self;
  }
  boolean execute() {
    return false;
  }
  void move() {

    if (!bFreeze) {
      self.burnFood(averageFoodBurned);
      if (self.getStomach() > .5) {
        moveStep = averageStep * 1.3;
      } else if (self.isHungry()) {
        moveStep = averageStep * .7;
      }
      self.move(moveStep);
    }
  }
  void setId(int newId) {
    behaviorID = newId;
  }

  int getId() {
    return behaviorID;
  }
  String getObjectName() {
    return name;
  }
  String toString() {
    String s = ""; 
    return s;
  }
  void toggleTagged() {
    tagged = !tagged;
  }
  void selfReport() {
    if (tagged) {
      Report(this);
    }
  }
  void  drawTrackLine() {
    // do nothing because it is abstract
  }

  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    sArray.add("Behavior Report: ");
    sArray.add("No behaviors reporting...");
    return sArray;
  }
}




class Graze extends BaseBehavior {
  boolean grazing = false; 

  Graze(Animal _self) {
    super(_self);
    name = "Graze";
  }
  boolean execute() {
    Console(this);
    if (!grazing && self.isHungry()) {
      self.feed(1);
      grazing = true;
      return true;
    } else if (grazing && self.getStomach() < 1) {
      self.feed(1);
      return true;
    }
    grazing = false;
    return false;
  }
  String toString() {
    String s = self.getObjectName() + " [" + self.getId() + "] Grazing ...."; 
    return s;
  }
}


class Wander extends BaseBehavior {
  float wanderMin = 100;
  float wanderMax = 300;
  float wanderRate = random(wanderMin, wanderMax);



  Wander(Animal _self) {
    super(_self);
    memoryCounter = wanderRate;
    name = "Wander";
  }
  boolean execute() {

    if (memoryCounter-- <= 0) {
      self.setRotation(random(0, 2*PI));
      memoryCounter = wanderRate;  // reset counter
      wanderRate = int(random(wanderMin, wanderMax));
    }
    move();

    Console(this);
    selfReport();
    return true;
  }
  String toString() {
    String s = self.getObjectName() + " [" + self.getId() + "] Wandering ...."; 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    String buf = "";
    sArray.add("Name: ");
    sArray.add(self.getObjectName());
    sArray.add("Id: ");
    sArray.add(str(getId()));
    sArray.add("Wandering: ");
    sArray.add("..." );
    for (Observation o : self.getObserved()) {
      buf = buf + o.parent.getId() + " ";
    }
    sArray.add("Observed: ");
    sArray.add(buf);
    return sArray;
  }
}

class Avoid extends Track {

  Avoid(Animal _self, StringList _targetTypes) {
    super(_self, _targetTypes);
    name = "Avoid";
  }
  boolean execute() {

    if (super.execute()) {
      selfReport();
      return true;
    }
    return false;
  }
  void turn() {
    super.turn();
    self.setRotation(self.getRotation()+PI);
  }
  void move() {
    self.burnFood(averageFoodBurned);
    if (self.getStomach() > .5) {
      moveStep = averageStep * 1.3;
    } else if (self.isHungry()) {
      moveStep = averageStep * .7;
    }
    self.move(moveStep);
  }
  String toString() {
    String s = self.getObjectName() + " [" + self.getId() + "] Avoiding ..." + targetTypes.get(0); 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    sArray.add("Name: ");
    sArray.add(self.getObjectName());
    sArray.add("Id: ");
    sArray.add(str(getId()));
    sArray.add("Avoiding: ");
    sArray.add("..." + str(memoryCounter));
    return sArray;
  }
}

class Mate extends Track {


  Mate(Animal _self) {
    super(_self, new StringList(_self.getObjectName()));  
    name = "Mate";
  }

  boolean execute() {
    Animal animal = null;
    ICanMate targetMate = null;

    if (!self.isHungry() && self.isReadyToMate()) {
      if (!super.execute()) {  // super couldnt find a target
        return false;
      }
      targetMate = (ICanMate)target;  

      if (distanceToTarget() < 10) {  // close enough to mate
        if (!self.isHungry() && self.isAdult()) {
          if (targetMate.isAdult() && targetMate.isReadyToMate()) {
            self.spawn();
          }
        }
      }
      return true;
    } else {
      target = null;
      return false;
    }
  }
}



class Cannibalize extends Hunt {

  Cannibalize(ICarnivore _self) {
    super(_self, new StringList(_self.getObjectName()));  
    name = "Cannibalize";
  }

  boolean execute() {
    if (self.isAdult() && self.getStomach() < .1) { // only if starving
      if (acquire(self.getPreyTypes())) {   // check to see if there are regular prey
        return false;  // fail if regular prey exists
      } else {
        return super.execute();
      }
    }
    return false;
  }
}

class Hunt extends Track {

  Hunt(ICarnivore _self, StringList _targetTypes) {
    super((Animal)_self, _targetTypes);
    name = "Hunt";
    averageStep = 2;
    //println("memory in Hunt :" + _self.getMemory());
  }
  boolean execute() {

    if (self.isAdult() && self.isHungry()) {

      if (super.execute() == false) {  // super couldnt find a target

        return false;
      }

      if (distanceToTarget() < 10) {  // close enough to eat
        target.kill();
        self.feed(self.stomachFull);
        target = null;
        closestPrey = null;
        prey.clear();
      }
      //selfReport();
      return true;
    } else {
      return false;
    }
  }



  String toString() {
    String s = self.getObjectName() + " [" + self.getId() + "] hunting ..." + targetTypes.get(0); 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    String buf = "";
    if (target != null) {
      sArray.add("[" + str(self.getId()) + "] is hunting [" + str(target.getId()) + "] ..." + str(memoryCounter));
    }
    for (ISensable o : prey) {
      buf = buf + o.getId() + " [" + self.distanceTo(o) + "] \n" ;
    }
    sArray.add("\nPrey: ");
    sArray.add(buf);
    if (closestPrey != null) {
      //sArray.add("closest Prey: " + str(closestPrey.getId()));
      sArray.add("Target: " + str(target.getId()));
    }
    return sArray;
  }
}

class Track extends BaseBehavior {
  ISensable target;
  StringList targetTypes;
  ArrayList<ISensable> prey = null;
  ISensable closestPrey = null;



  Track(ICanTrack _self, StringList _targetTypes) {
    super((Animal)_self);
    targetTypes = _targetTypes;
    name = "Track";
    prey = new ArrayList<ISensable>();
    memoryCounter = self.getMemory();
  }

  boolean execute() {
    if (!acquire()) {
      return false; // lost scent
    }

    turn();
    move();
    //Console(this);
    return true;
  }

  boolean acquire() {
    return acquire(targetTypes);
  }

  boolean acquire(StringList _preyTypes) {
    //println("tracking..." + self.getTick());
    prey.clear();
    target = null;
    closestPrey = null;

    if (self.getObserved().size() > 0) {  // I see something
      filterPrey(_preyTypes);  // choose only prey of target type
      return closestAnimal();  // chose the closest prey
    }

    return false;  // I don't see anything at all
  }



  void filterPrey(StringList _preyTypes) {
    for (Observation obs : self.getObserved()) {   // add all sheep to list of prey
      if (_preyTypes.hasValue(obs.parent.getObjectName())) {
        if (!obs.parent.isDead()) {  // only consider living animals prey
          prey.add(obs.parent);
          if (self.isTagged()) {
            //println("Adding prey:" + prey.size());
          }
        }
      }
    }
  }
  void filterPrey(String _targetType) {
    for (Observation obs : self.getObserved()) {   // add all sheep to list of prey
      if (obs.parent.getObjectName() == _targetType) {
        if (!obs.parent.isDead()) {  // only consider living animals prey
          prey.add(obs.parent);
          if (self.isTagged()) {
            //println("Adding prey:" + prey.size());
          }
        }
      }
    }
  }
  boolean closestAnimal() {
    // compare distance to each prey and hunt closest
    if (prey.size() == 1) {
      if (!prey.get(0).isDead() ) {   // this should always be true because dead animals are not added to prey in code above
        target = prey.get(0);
        closestPrey = target;  // by definition because its the ONLY prey
        return true;
      } else {
        target = null;  // should never reach this
        return false;
      }
    } else if (prey.size() > 1) {  // there more than 1 in the list so choose closest
      //println(self.getId() + "] choosing closest prey of of " + prey.size());
      for (ISensable obs : prey) {
        if (closestPrey == null) {
          closestPrey = obs;
        } else {
          float distanceObs = self.distanceTo(obs);
          float distancePrey = self.distanceTo(closestPrey);
          //println(obs.getId() + ": " + distanceObs + " / " + closestPrey.getId() + ": " + distancePrey);
          if (distanceObs < distancePrey) {
            closestPrey = obs;
            //println(self.getId() + "] " + closestPrey.getId() + " is the new Closest.");
          } else {
            //println(self.getId() + "] " + closestPrey.getId() + " remains the Closest.");
          }
        }
      }
      target = closestPrey;
      return true;
    } else if (prey.size() == 0) {  
      //println(self.getId() + "] Only wolves in sight");
      return false; // only wolves  in sight
    }
    return true;
  }
  void turn() {
    self.rotateTo(target);
  }

  float distanceToTarget() {
    return self.distanceTo(target);
  }
  void drawTrackLine() {

    pushStyle();
    strokeWeight(5);
    
    if (target != null) { 
      
      float x1 = 0;
      float y1 = 0;
      float x2 = target.getParticle().px() - self.getParticle().px();
      float y2 = target.getParticle().py() - self.getParticle().py();
      
      for (int i = 0; i <= 10; i++) {
        float x = lerp(x1, x2, i/10.0) ;
        float y = lerp(y1, y2, i/10.0);
        point(x, y);
      }
    }
    popStyle();
  }

  boolean forget() {
    //if (memoryCounter-- <= 0) {
    //  memoryCounter = self.getMemory(); // reset memory counter
    //  target = null;
    //  if(self != null) {
    //    self.setTarget(null);  // How can self be null?
    //  }
    //  return true;
    //} else {
    //  return false;
    //}
    return false;
  }



  String toString() {
    String s = self.getObjectName() + " [" + self.getId() + "] Tracking ..." + targetTypes.get(0); 
    return s;
  }
}
