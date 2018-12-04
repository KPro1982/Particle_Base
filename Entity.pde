abstract class Entity implements ISensable {
  Particle particle;
  
  Entity() {
    particle = new Particle(null,0,0,0);
  }
  Entity(World _world) {
    particle = new Particle(_world, 0,0,0);
  }
   Entity(World _world, float _ex, float _ey, float _rot) {
    particle = new Particle(_world, _ex,_ey,_rot);
  }
  
  abstract void execute();
  abstract void draw();
  abstract void setId(int i);   
  abstract void tick(int _t);
  abstract boolean mouseOver();
  abstract void mouseDragged();
  abstract boolean isTagged();
  abstract void mouseClicked();
  abstract void setSelected(boolean _flag);
  abstract Animal getSelf();
  
}
