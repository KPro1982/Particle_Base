interface ICanSense {
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
}

interface ISensable {
  
}
