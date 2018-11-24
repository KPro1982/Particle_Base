class Particle { //<>// //<>// //<>//

  // -------------------------------------------------------------------------
  // DECLARATIONS
  // -------------------------------------------------------------------------


  // IDENTITY

  int id;
  World world;


  // PHYSICS

  float px, py, ex, ey;
  float rot, bearing = 0;
  int tickCounter = 0;


  // -------------------------------------------------------------------------
  // CONTRUCTORS AND INITIALIZERS
  // -------------------------------------------------------------------------
  Particle(World _world) {
    world = _world;

    ex = random(-world.worldWidth/4, +world.worldWidth/4);
    ey = random(-world.worldHeight/4, +world.worldHeight/4);
    px = px();
    py = py();
    rot = random(-PI, PI);
  }

  Particle(World _world, float _ex, float  _ey, float _rot) {
    world = _world;

    ex = _ex;
    ey = _ey;
    setRotation(_rot);
    px = px();
    py = py();
  }
  
  Particle clone() {
    Particle p = new Particle(world, ex(),ey(),getRotation());
    p.setTick(getTick());
    p.setBearing(getBearing());
    return p;
  }

  //  -------------------------------------------------------------------------
  //    Getters and Setters 
  //  -------------------------------------------------------------------------
  void setId(int _id) {
    id = _id;
  }
  int getId() {
    return id;
  }
  float getRotation() {
    rot = rot % (2*PI); // make sure that rot does not exceed 2PI
    return rot;
  }
  void setRotation(float _rot) {

    rot = rot % (2*PI);  // make sure that rot does not exceed 2PI
    rot = _rot;
    setBearing(rot);
  }
  float getBearing() {
    return bearing;
  }
  void setBearing(float _bearing) {
    bearing = _bearing;
  }

  float px() {
    px = map(ex, (-world.worldWidth/2+scaleEx(world.getOffset().x))*world.getScaleFactor(), (+world.worldWidth/2+scaleEx(world.getOffset().x))*world.getScaleFactor(), 0, world.screenWidth);
    return px;
  }

  float py() {
    py = map(ey, (+world.worldHeight/2+scaleEy(world.getOffset().y))*world.getScaleFactor(), (-world.worldHeight/2+scaleEy(world.getOffset().y))*world.getScaleFactor(), 0, world.screenHeight);
    return py;
  }
  float scaleEx(float _px) {
    return _px / world.screenWidth * world.worldWidth; 
    
  }
    float scaleEy(float _py) {
    return _py / world.screenHeight * world.worldHeight; 
  }
  float ex() {
    return ex;
  }
  float ey() {
    return ey;
  }
  void ex(float _ex) {
    ex = _ex;
  }
  void ey(float _ey) {
    ey = _ey;
  }
  int getTick() {
    return tickCounter;
  }
  void addTick() {
    tickCounter++;
  }
  void setTick(int _tick) {
    tickCounter = _tick;
  }

  PVector getPVector() {
    return new PVector(ex, ey);
  }

  // ------------------------------------------------------------------------------------
  // HELPER FUNCTIONS 
  // ------------------------------------------------------------------------------------


  void printPhysics() {
    println("environ: (" + ex + "," + ey + ")");
    println("pixel: (" + px + "," + ey + ")");
    println("rotation: radians (" + rot + ") degrees (" + degrees(rot) + ")");
  }

  float distanceTo(Particle _p) {
    float dx = ex() - _p.ex();
    float dy = ey() - _p.ey();
    return sqrt(dx*dx+dy*dy);
  }

  void rotateToMouse() {
    PVector targetVect = new PVector(mouseX, mouseY);
    PVector pVect = new PVector(px(), py());

    setRotation(getRotation() + angleTo(pVect, targetVect));
  }

  void rotateTo(Particle _p) {

    PVector targetVect = new PVector(_p.px(), _p.py());  // this should be based of of ex, ey but doesn't work for some reason
    PVector pVect = new PVector(px(), py());             // this may break if the environment > screen
    setRotation(getRotation() + angleTo(pVect, targetVect));
  }

  float angleTo(Particle _p) {
    PVector targetVect = _p.getPVector();
    PVector pVect = getPVector();

    return angleTo(targetVect, pVect);
  }

  float angleTo(PVector v1, PVector v2) {
    float angle2 = 0;
    PVector vDiff = PVector.sub(v2, v1);
    vDiff.normalize();
    PVector oVect = PVector.fromAngle(-getRotation());
    float h1 = oVect.heading();
    float h2 = vDiff.heading();
    Console(degrees(h1) + ", " + degrees(h2));
    angle2 = h1 + h2;
    return angle2;
  }

  float bearingTo(Particle p1, Particle p2) {
    PVector px1 = new PVector(p1.px(), p1.py());
    PVector px2 = new PVector(p2.px(), p2.py());
    return bearingTo(px1, px2);
  }

  float bearingTo(PVector v1, PVector v2) {
    PVector vDiff = PVector.sub(v2, v1);
    vDiff.normalize();
    return vDiff.heading();
  }

  void moveOnBearing(float dist) {
    ex += dist*cos(bearing);
    ey -= dist*sin(bearing);
  }

  boolean outOfBounds() {
    if (abs(ex) > world.worldWidth/2-50) {
      return true;
    } else if (abs(ey) > world.worldHeight/2-50) {
      return true;
    } else {
      return false;
    }
  }

  // ********************** END HELPER FUNCTIONS ******************************************
}
