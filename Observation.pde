class Observation  {
   ISensable parent;
   Particle image;
   float visibility;
   
   Observation(ISensable _p) {
     parent = _p;
     image = parent.getParticle().clone();  // image is a snapshot at t = tick
     visibility = parent.getVisibility();
   }
   
   int getAge() {
    return parent.getTick() - image.getTick(); 
   }
   
  
  
}
