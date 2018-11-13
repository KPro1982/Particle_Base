class BaseBehavior implements IBehavior, IReportable {
  IHaveParticle self;
  
  BaseBehavior() {
    
  }
  boolean execute() {
    return false;
  }
  String toString() {
    String s = ""; 
    return s;
  }
  ArrayList<String> getReport() {

    return null;
  }
}


class Graze extends BaseBehavior  {
  IHerbivore self;
  boolean grazing = false; 

  Graze(IHerbivore _self) {
    super();
    self = _self;
  }
  boolean execute() {
    Console(this);
    if (!grazing) {
      if (self.getStomach() < 1) {
        self.feed(.1);
        grazing = true;
        return true;
      }
    } else if (self.getStomach() < self.getStomachFull()) {
      self.feed(2);
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
  float wanderStep = 1;
  float foodBurned = .2;

  Wander(Animal _self) {
    self = _self;
  }
  boolean execute() {
    tickCounter++;

    if (tickCounter % int(random(75, 125)) == 0) {
      self.setRotation(random(0, 2*PI));
    }
    self.move(wanderStep);
    self.burnFood(foodBurned);
    Console(this);
    return true;
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Wandering ...."; 
    return s;
  }
}

class Avoid extends Track {

  Avoid(Animal _self, ISensable _targetType) {
    super(_self, _targetType);
    trackStep = 2;
  }
  void turn() {
    super.turn();
    self.setRotation(self.getRotation()+PI);
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Avoiding ..." + targetType.getName(); 
    return s;
  }
}

class Hunt extends Track {

  Hunt(Animal _self, ISensable _targetType) {
    super(_self, _targetType);
    trackStep = 2;
  }
  boolean execute() {
    if (!super.execute()) {  // super couldnt find a target
      return false;
    }
    if (distanceToTarget() < 50) {  // close enough to eat
      target.kill();
      self.getObserved().clear();
      target = null;
    }
    return true;
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] hunting ..." + targetType.getName(); 
    return s;
  }
}

class Track extends BaseBehavior  {
  Animal self;
  ISensable target, targetType;

  int tickCounter = 0;
  int maxTickTracked = 50;
  float trackStep = .5;

  Track(Animal _self, ISensable _targetType) {
    self = _self;
    targetType = _targetType;
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
        if (obs.parent.getName() == targetType.getName()) {
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
    String s = self.getName() + " [" + self.getId() + "] Tracking ..." + targetType.getName(); 
    return s;
  }
}
