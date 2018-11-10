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
  float bearingTo(IHaveParticle p1, IHaveParticle p2);
  float distanceTo(IHaveParticle _p);
  boolean outOfBounds();
}

interface ISensable extends IHaveParticle {
  void addSensedBy(ICanSense s);
  void removeSensedBy(ICanSense s);
}
interface ISenseStrategy {
  ArrayList<ISensable> sense();
}
