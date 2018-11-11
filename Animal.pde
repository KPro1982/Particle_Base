class Wolf extends Animal implements ICarnivore {

  Wolf(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "wolf";
    addSense(new PredatorVision(this));
    addBehavior(new Wander(this));
    
  }
  void hunt() {
  }
}

class Cow extends Animal implements IHerbavore {
  Cow(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "cow";
    addSense(new PreyVision(this));
    addBehavior(new Graze(this));
    addBehavior(new Wander(this));
    
  }
}


class Animal extends Entity implements ICanMove, ICanMate {
  float stomach = 5;
  float hungerThresh = 0;
  float stomachFull = 150;
  int children = 0;
  ICanMate mate;
  int ticksSinceLastChild = 0;
  ArrayList<IBehavior> behaviors;


  Animal(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_world, _ex, _ey, _rot);
    getParticle().setId(_id);
    stomach = int(random(0,stomachFull));
    behaviors = new ArrayList<IBehavior>();
  }

  void step() {
    tick();
    sense();
    execute();
    println(this);
  }
  boolean isHungry() {
    return stomach < hungerThresh;
  }
  void feed(float _food) {
    stomach += _food;
  }
  float getStomach() {
    return stomach;
  }
  float getStomachFull() {
    return stomachFull;
  }
  void burnFood(float _food) {
    stomach -= _food;
  }
  boolean hasMate() {
    return mate != null;
  }
  void tick() {

    ticksSinceLastChild++;
  }

  void execute() {
    for (IBehavior b : behaviors) {
      if(b.execute()) {
        break;
      }
    }
  }
  String toString() {

    String s = "[" + getId() + "] " + name + " -- stomach: " + stomach + " children: " + children;
    return s;
  }

  void addBehavior(IBehavior newB) {
    behaviors.add(newB);
  }

  void move(float dist) {
    setBearing(getRotation());
    if (outOfBounds()) {
      setBearing(getBearing()+PI);
    }
    moveOnBearing(dist);
  }
}
