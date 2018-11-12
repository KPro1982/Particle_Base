class Observation implements IHaveParticle {
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

  // -----------------------------------------------------------------------------
  // IHaveParticle Interface Prereqs
  // -----------------------------------------------------------------------------

  Particle getParticle() {
    return image;
  }
  int getId() {
    return getParticle().getId();
  }
  void setId(int _id) {
    getParticle().setId(_id);
  }
  float px() {
    return getParticle().px();
  }

  float py() {
    return getParticle().py();
  }

  float ex() {
    return getParticle().ex();
  }
  float ey() {
    return getParticle().ey();
  }
  void ex(float _ex) {
    getParticle().ex(_ex);
  }
  void ey(float _ey) {
    getParticle().ey(_ey);
  }

  World getWorld() {
    return getParticle().world;
  }

  float getRotation() {
    return getParticle().getRotation();
  }
  void setRotation(float _rot) {
    getParticle().setRotation(_rot);
  }
  float getBearing() {
    return getParticle().getBearing();
  }
  void setBearing(float _bearing) {
    getParticle().setBearing(_bearing);
  }

  float bearingTo(IHaveParticle p1, IHaveParticle p2) {
    return getParticle().bearingTo(p1.getParticle(), p2.getParticle());
  }
  float distanceTo(IHaveParticle _p) {
    return getParticle().distanceTo(_p.getParticle()) ;
  }

  boolean outOfBounds() {
    return getParticle().outOfBounds();
  }

  void rotateTo(IHaveParticle _p) {
    getParticle().rotateTo(_p.getParticle());
  }

  void moveOnBearing(float _dist) {
    getParticle().moveOnBearing(_dist);
  }

  int getTick() {
    return getParticle().getTick();
  }

  void addTick() {
    getParticle().addTick();
  }
 
}
