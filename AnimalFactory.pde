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
// -----------------------------------------------------------------------------
// WOLF
// -----------------------------------------------------------------------------

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
    setMateRate(250);
    setVisibility(100);
    iconType = "Square";


    addSense(new PredatorVision(this));
    addBehavior(new Hunt(this, "Sheep"));

    addBehavior(new Mate(this, "Wolf"));
    addBehavior(new Hunt(this, "Wolf"));
    addBehavior(new Wander(this));
  }
  //void executeBehaviors() {
  //  IBehavior aHunt = behaviors.get(0);
  //  IBehavior aWander = behaviors.get(1);
  //  activeBehavior = "";

  //  if (aHunt.execute() == false) { // no target
  //    if (aWander.execute() == true) {
  //      activeBehavior = "Wander";
  //    }
  //  } else {
  //    activeBehavior = "Hunt";  //  hunting
  //  }
  //  determineColor();
  //}

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
// -----------------------------------------------------------------------------
// SHEEP
// -----------------------------------------------------------------------------

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
    addBehavior(new Avoid(this, "Wolf"));
    addBehavior(new Graze(this));
    addBehavior(new Mate(this, "Sheep"));
    addBehavior(new Wander(this));
    setMateRate(500);
    setVisibility(100);
    iconType = "Circle";
  }
  boolean isHerbavore() {
    return true;
  }
}
