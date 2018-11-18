class BaseBehavior implements IBehavior, IReportable {
  IHaveParticle self;
  boolean tagged = false;
  int behaviorID;
  String name = "";

  BaseBehavior() {
    behaviorID = 0;
  }
  boolean execute() {
    return false;
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
  IHerbivore self;
  boolean grazing = false; 

  Graze(IHerbivore _self) {
    super();
    self = _self;
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
  Animal self;
  int tickCounter = 0;
  int wanderMin = 100;
  int wanderMax = 300;
  int wanderRate = int(random(wanderMin, wanderMax));
  float wanderStep = 2;
  float foodBurned = .2;

  Wander(Animal _self) {
    self = _self;
    name = "Wander";
  }
  boolean execute() {
    tickCounter++;

    if (tickCounter > wanderRate) {
      self.setRotation(random(0, 2*PI));
      tickCounter = 0;
      wanderRate = int(random(wanderMin, wanderMax));
    }
    self.move(wanderStep);
    self.burnFood(foodBurned);
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
    trackStep = 2;
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
  Animal self;

  Mate(Animal _self, String _targetType) {
    super(_self, _targetType);
    self = _self;
    trackStep = 2;
    name = "Mate";
  }

  boolean execute() {
    Animal animal = null;

    if (!super.execute()) {  // super couldnt find a target
      return false;
    }

    if (distanceToTarget() < 10) {  // close enough to mate
      if (!self.isHungry() && self.isAdult())

        animal = animalFactory.getAnimal(self.name);
      if (animal != null) {
        animal.clone(self);
        self.world.addAnimal(animal);
      }
    }
    //self.feed(300);
    //self.getObserved().clear();
    target = null;
    return true;
  }
}




class Hunt extends Track {

  Hunt(Animal _self, String _targetType) {
    super(_self, _targetType);
    trackStep = 2;
    name = "Hunt";
  }
  boolean execute() {

    if (self.isAdult() && self.isHungry()) {
      if (!super.execute()) {  // super couldnt find a target
        return false;
      }

      if (distanceToTarget() < 10) {  // close enough to eat
        target.kill();
        if (self.getStomach() > 200) {
          trackStep *= 1.3;
        }
        //self.feed(300);
        //self.getObserved().clear();
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
  Animal self;
  ISensable target;
  String targetType;

  int tickCounter = 0;
  int maxTickTracked = 150;
  float trackStep = .5;

  Track(Animal _self, String _targetType) {
    self = _self;
    targetType = _targetType;
    name = "Track";
  }

  boolean execute() {
    if (forget() || !acquire()) {
      return false; // lost scent
    } 
    turn();
    self.move(trackStep);
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
