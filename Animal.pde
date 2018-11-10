class Animal extends Entity {
  
  Animal(World _world, float _ex, float _ey, float _rot) {
    super(_world, _ex, _ey, _rot);
    if (random(0,2) > .5) {
      addSense(new PreyVision(this));
    } else {
      addSense(new PredatorVision(this));
    }
    
  }
  
  void step() {
    sense();
    
  }
 
  
}
