class Animal extends Entity implements ICanMove, ICanMate {
  float stomach = 0;
  float hungerThresh = 5;
  int children = 0;
  ICanMate mate;
  int ticksSinceLastChild = 0;


  Animal(World _world, float _ex, float _ey, float _rot) {
    super(_world, _ex, _ey, _rot);
    if (random(0, 2) > .5) {
      addSense(new PreyVision(this));
    } else {
      addSense(new PredatorVision(this));
    }
  }

  void step() {
    tick();
    sense();
    execute();
  }
  boolean isHungry() {
    return stomach < hungerThresh;
  }
  boolean hasMate() {
    return mate != null;
  
  }
  void tick() {
    stomach -= .1;
    ticksSinceLastChild++;
  }
  
  void execute() {
    turnTo(10);
    
  }
  
  void turnTo(float bTo) {
    rotateTo(world.entities.get(0));
  }
  
  void move(float dist) {
  }
}
