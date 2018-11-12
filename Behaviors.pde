class Graze implements IBehavior {
  IHerbavore self;
  boolean grazing = false; 

  Graze(IHerbavore _self) {
    self = _self;
  }
  boolean execute() {
    println(this);
    if (!grazing) {
      if (self.getStomach() < 1) {
        self.feed(.1);
        grazing = true;
        println(this);
        return true;
      }
    } else if (self.getStomach() < self.getStomachFull()) {
      self.feed(2);
      println(this);
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


class Wander implements IBehavior {
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
    println(this);
    return true;
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Wandering ...."; 
    return s;
  }
}

class Track implements IBehavior {
  Animal self;
  ISensable target, targetType;

  int tickCounter = 0;
  float trackStep = .5;

  Track(Animal _self, ISensable _targetType) {
    self = _self;
    targetType = _targetType;
  }

  boolean execute() {
    //println(this);
    tickCounter++;

    if (target == null) {  // attempt to find a target 
      if (self.getObserved().size() > 0) {  // there is a target available
        //self.getObserved().sort(new DistanceComparator(self));
        for (Observation obs : self.getObserved()) {
          if (obs.parent.getName() == targetType.getName()) {
            target = self.getObserved().get(0).parent;  // follow closest of correct type
            break;
          }
        }
        return false;  // none of the correct type
      } else { // no target available
        return false;
      }
    } else if (target != null) {  // there is a target
      self.rotateTo(target);
      self.move(trackStep);
      println(this);
      return true;
    } else {  // still no target
      return false;
    }
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Tracking --> " + targetType.getName(); 
    return s;
  }
}
