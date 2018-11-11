class Graze implements IBehavior {
  IHerbavore self;
  int tickCount = 0;
  boolean grazing = false; 

  Graze(IHerbavore _self) {
    self = _self;
  }
  boolean execute() {

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
    return true;
  }
}
