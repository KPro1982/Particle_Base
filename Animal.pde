class Animal extends Entity {
  
  Animal(World _world, float _ex, float _ey, float _rot) {
    super(_world, _ex, _ey, _rot);
    addSense(new Vision(this));
    
  }
  
  void step() {
    sense();
    
  }
 
  
}
