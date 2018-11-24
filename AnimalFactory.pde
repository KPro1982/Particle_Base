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

class Wolf extends Animal implements ICarnivore, ICannibal {

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

    setPreyTypes(new StringList("Sheep"));
    addSense(new PredatorVision(this));
    addBehavior(new Mate(this));
    addBehavior(new Hunt(this, getPreyTypes()));
    addBehavior(new Cannibalize(this));
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
  boolean canSeePrey() {
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
    setPredatorTypes(new StringList("Wolf"));
    addBehavior(new Avoid(this, getPredatorTypes()));
    addBehavior(new Graze(this));
    addBehavior(new Mate(this));
    addBehavior(new Wander(this));
    setMateRate(500);
    setVisibility(100);
    iconType = "Circle";
  }
  boolean isHerbavore() {
    return true;
  }
}
