class BaseBehavior implements IBehavior, IReportable {
  Animal self;
  boolean tagged = false;
  int behaviorID;
  String name = "";
  float averageStep = 1;
  float moveStep = averageStep;
  float averageFoodBurned = 1;

  BaseBehavior(Animal _self) {
    behaviorID = 0;
    self = _self;
  }
  boolean execute() {
    return false;
  }
  void move(float _step) {
     self.burnFood(averageFoodBurned);
    if (self.getStomach() > .5) {
      moveStep = averageStep * 1.3;
    } else if (self.isHungry()) {
      moveStep = averageStep * .7;
    }
    self.move(_step);
  }
  void setId(int newId) {
    behaviorID = newId;
  }
  int getId() {
    return behaviorID;
  }
  String getName() {
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
    String s = self.getName() + " [" + self.getId() + "] Grazing ...."; 
    return s;
  }
}


class Wander extends BaseBehavior {
  int tickCounter = 0;
  int wanderMin = 100;
  int wanderMax = 300;
  int wanderRate = int(random(wanderMin, wanderMax));



  Wander(Animal _self) {
    super(_self);

    name = "Wander";
  }
  boolean execute() {
    tickCounter++;

    if (tickCounter > wanderRate) {
      self.setRotation(random(0, 2*PI));
      tickCounter = 0;
      wanderRate = int(random(wanderMin, wanderMax));
    }
    move(averageStep);
   
    Console(this);
    selfReport();
    return true;
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Wandering ...."; 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    String buf = "";
    sArray.add("Name: ");
    sArray.add(self.getName());
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

  Avoid(Animal _self, String _targetType) {
    super(_self, _targetType);
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
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Avoiding ..." + targetType; 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    sArray.add("Name: ");
    sArray.add(self.getName());
    sArray.add("Id: ");
    sArray.add(str(getId()));
    sArray.add("Avoiding: ");
    sArray.add("..." + str(maxTickTracked - tickCounter));
    return sArray;
  }
}

class Mate extends Track {


  Mate(Animal _self, String _targetType) {
    super(_self, _targetType);  
    name = "Mate";
  }

  boolean execute() {
    Animal animal = null;
    ICanMate targetMate = null;

    if (self.isFull()) {
      if (!super.execute()) {  // super couldnt find a target
        return false;
      }
      targetMate = (ICanMate)target;  

      if (distanceToTarget() < 10) {  // close enough to mate
        if (self.isFull() && self.isAdult())
          if (targetMate.isAdult()) {
            animal = animalFactory.getAnimal(self.name);
            if (animal != null) {
              animal.clone(self);
              animal.setChild(true);
              animal.feed(animal.stomachFull);  // kids start full
              self.world.addAnimal(animal);
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




class Hunt extends Track {

  Hunt(Animal _self, String _targetType) {
    super(_self, _targetType);
    name = "Hunt";
  }
  boolean execute() {

    if (self.isAdult() && !self.isFull()) {
      if (!super.execute()) {  // super couldnt find a target
        return false;
      }

      if (distanceToTarget() < 10) {  // close enough to eat
        target.kill();
        self.feed(self.stomachFull);
        target = null;
      }
      selfReport();
      return true;
    } else {
      return false;
    }
  }



  String toString() {
    String s = self.getName() + " [" + self.getId() + "] hunting ..." + targetType; 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    String buf = "";
    sArray.add("Name: ");
    sArray.add(self.getName());
    sArray.add("Id: ");
    sArray.add(str(getId()));
    sArray.add("Hunting: ");
    sArray.add("..." + str(maxTickTracked-tickCounter));
    for (Observation o : self.getObserved()) {
      buf = buf + o.parent.getId() + " ";
    }
    sArray.add("Observed: ");
    sArray.add(buf);
    return sArray;
  }
}

class Track extends BaseBehavior {
  ISensable target;
  String targetType;

  int tickCounter = 0;
  int maxTickTracked = 150;
  float trackStep = .5;

  Track(Animal _self, String _targetType) {
    super(_self);
    
    targetType = _targetType;
    name = "Track";
  }

  boolean execute() {

    if (forget() || !acquire()) {
      return false; // lost scent
    } 
    turn();
    move(trackStep);
    Console(this);
    return true;
  }



  boolean acquire() {
    ArrayList<Observation> prey = new ArrayList<Observation>();
    Observation closestPrey = null;

    if (self.getObserved().size() > 0) {  // I see something

      for (Observation obs : self.getObserved()) {   // add all cows to list of prey
        if (obs.parent.getName() == targetType) {
          prey.add(obs);
        }
      }

      // compare distance to each prey and hunt closest
      if (prey.size() == 1) {
        if (!prey.get(0).parent.isDead() ) {
          target = prey.get(0).parent;
          return true;
        } else {
          target = null;
          return false;
        }
      } else if (prey.size() > 1) {  // there more than 1 in the list so choose closest

        for (Observation obs : prey) {
          if (closestPrey == null) {
            closestPrey = obs;
          } else {
            float distanceObs = self.distanceTo(obs);
            float distancePrey = self.distanceTo(closestPrey);
            if (distanceObs < distancePrey) {
              closestPrey = obs;
            } else {
              // do nothing because closest is still closests
            }
          }
        }
        target = closestPrey.parent;
      } else if (prey.size() == 0) {  
        return false; // only wolves  in sight
      }
    }
    return false;  // I don't see anything at all
  }


  void turn() {
    self.rotateTo(target);
  }

  float distanceToTarget() {
    return self.distanceTo(target);
  }

  boolean forget() {
    if (tickCounter++ > maxTickTracked) {
      tickCounter = 0;
      target = null;
      return true;
    } else {
      return false;
    }
  }



  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Tracking ..." + targetType; 
    return s;
  }
}
