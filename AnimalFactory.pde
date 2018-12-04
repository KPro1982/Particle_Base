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
    case "Bear":
      return new Bear(world);
    default:
      return null;
    }
  }
}

// -----------------------------------------------------------------------------
// BEAR
// -----------------------------------------------------------------------------

class Bear extends Animal implements ICarnivore, ICannibal {

  Bear(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "Bear";
    config();

    //setSkin("bear.png");
  }
  Bear(World _world) {
    super(_world);
    name = "Bear";
    config();
  }
  boolean isCarnivore() {
    return true;
  }
  void config() {
    stomachFull = 1000;
    stomach = 1000;
    setRunRate(5);
    setWalkRate(2);
    setMemory(1000);
    setMateRate(500);
    setVisibility(100);
    iconType = "Triangle";

    setPreyTypes(new StringList("Wolf", "Sheep"));
    addSense(new BearVision(this));
    addBehavior(new Mate(this));
    addBehavior(new Hunt(this, getPreyTypes()));
    addBehavior(new Cannibalize(this));
    addBehavior(new Wander(this));
  }

}
// -----------------------------------------------------------------------------
// WOLF
// -----------------------------------------------------------------------------

class Wolf extends Animal implements ICarnivore, ICannibal, IPackAnimal {
  ArrayList<IPackAnimal> pack;
  
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
    stomachFull = 500;
    stomach = 500;
    setRunRate(6);
    setWalkRate(1);
    setMemory(1000);
    setMateRate(500);
    setVisibility(100);
    iconType = "Square";

    pack = new ArrayList<IPackAnimal>();
    
    setPreyTypes(new StringList("Sheep"));
    addSense(new PredatorVision(this));
    setPredatorTypes(new StringList("Bear"));
    addBehavior(new Avoid(this, getPredatorTypes()));
    addBehavior(new PackMate(this));
    addBehavior(new PackHunt(this, getPreyTypes()));
    addBehavior(new Cannibalize(this));
    addBehavior(new Wander(this));
  }
  
  IPackAnimal getAlpha() {
    return pack.get(0);
  }
  IPackAnimal getSelf() {
    return (IPackAnimal) this;
  }
  Animal getSelf() {
    return (Animal) this;
  }
  void packAdd(IPackAnimal _a) {
    pack.add(_a);
  }
  
  void packRemove(IPackAnimal _a) {
    pack.remove(_a);
  }
  
  boolean hasPack() {
    return pack.size() > 0;
  }

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
    setPredatorTypes(new StringList("Wolf", "Bear"));
    addBehavior(new Avoid(this, getPredatorTypes()));
    addBehavior(new Graze(this));
    addBehavior(new Mate(this));
    addBehavior(new Wander(this));
    setMateRate(1000);
    setVisibility(100);
    iconType = "Circle";
  }
  boolean isHerbavore() {
    return true;
  }
}
