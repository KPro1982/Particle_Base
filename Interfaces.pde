
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
  int getTick();
  void addTick();
}
interface ICanDie {
  void kill();
  boolean isDead();
}

interface ISenseStrategy {
  ArrayList<Observation> sense();
  void drawSenseCone();
}

interface ICanSense extends IHaveParticle {
  World getWorld();
  ArrayList<Observation> sense();
}

interface ISensable extends IHaveParticle {
  void addSensedBy(ICanSense s);
  void removeSensedBy(ICanSense s);
  float getVisibility();
  Observation getObservation();
  String getName();
  void kill();
  boolean isDead();
}


interface ICanMove {
}

interface ICanMate {
}

interface ICarnivore extends ICanEat {
  boolean isCarnivore();
}

interface IHerbivore extends ICanEat {
  boolean isHerbavore();
}
interface ICanEat {
  void feed(float _food);
  float getStomach();
  float getStomachFull();
  void burnFood(float _food);
  String getName();
  int getId();
}
interface ICanTrack {
  ArrayList<Observation> getObserved();
}
interface IBehavior {
  boolean execute();
}

interface IReportable {
  ArrayList<String> getReport();
  String toString();
  
}
