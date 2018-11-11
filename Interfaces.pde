interface ICanSense extends IHaveParticle {
  World getWorld();
}

interface IClickable {
  boolean mouseOver();
  void mouseDragged();
  void mouseClicked();
}

interface IHaveParticle {
  Particle getParticle();
  float px();
  float py();
  float ex();
  float ey();
  void ex(float _ex);
  void ey(float _ey);
  float getRotation();
  void setRotation(float _rot);
  float getBearing();
  void setBearing(float _rot);
  float bearingTo(IHaveParticle p1, IHaveParticle p2);
  void rotateTo(IHaveParticle _p);
  float distanceTo(IHaveParticle _p);
  boolean outOfBounds();
  void moveOnBearing(float dist);
  int getId();
}

interface ISensable extends IHaveParticle {
  void addSensedBy(ICanSense s);
  void removeSensedBy(ICanSense s);
}
interface ISenseStrategy {
  ArrayList<ISensable> sense();
  void drawSenseCone();
}

interface ICanMove {
}

interface ICanMate {
}

interface ICarnivore extends ICanEat{
  
}

interface IHerbavore extends ICanEat {
}
interface ICanEat {
  void feed(float _food);
  float getStomach();
  float getStomachFull();
  void burnFood(float _food);
}

interface IBehavior {
  boolean execute();
}
