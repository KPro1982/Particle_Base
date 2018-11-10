class Particle { //<>// //<>//

  // -------------------------------------------------------------------------
  // DECLARATIONS
  // -------------------------------------------------------------------------


  // IDENTITY

  World world;


  // PHYSICS

  float px, py, ex, ey;
  float bearing;  
  float rot;





  // ***************** END DECLARATIONS **************************************

  // -------------------------------------------------------------------------
  // CONTRUCTORS
  // -------------------------------------------------------------------------
  Particle(World _world) {
    world = _world;

    ex = random(-world.worldWidth/4, +world.worldWidth/4);
    ey = random(-world.worldHeight/4, +world.worldHeight/4);
    px = px();
    py = py();
    bearing = random(-PI, PI);
  }

  Particle(World _world, float _ex, float  _ey, float _rot) {
    world = _world;

    ex = _ex;
    ey = _ey;
    rot = _rot;
    px = px();
    py = py();
  }

  //  -------------------------------------------------------------------------
  //    Getters and Setters 
  //  -------------------------------------------------------------------------
  float getBearing() {
    return bearing;
  }
  void setBearing(float _bearing) {
    bearing = _bearing;
  }
    float getRotation() {
    return rot;
  }
  void setRotation(float _rot) {
    rot = _rot;
  }
  
  float px() {
    px = map(ex, -world.worldWidth/2, +world.worldWidth/2, 0, world.screenWidth);
    return px;
  }

  float py() {
    py = map(ey, +world.worldHeight/2, -world.worldHeight/2, 0, world.screenHeight);
    return py;
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

    rot += angleTo(pVect, targetVect);
    //println("heading:" + pVect.heading2D());
  }

  void rotateTo(Particle _p) {

    PVector targetVect = new PVector(_p.px(), _p.py());  // this should be based of of ex, ey but doesn't work for some reason
    PVector pVect = new PVector(px(), py());             // this may break if the environment > screen

    rot += angleTo(pVect, targetVect);
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
    PVector oVect = PVector.fromAngle(-bearing);
    float h1 = oVect.heading();
    float h2 = vDiff.heading();
    println(degrees(h1) + ", " + degrees(h2));
    angle2 = h1 + h2;
    return angle2;
  }

  float rotateTo(Particle p1, Particle p2) {
    PVector px1 = new PVector(p1.px(), p1.py());
    PVector px2 = new PVector(p2.px(), p2.py());
    return rotateTo(px1, px2);
  }

  float rotateTo(PVector v1, PVector v2) {
    PVector vDiff = PVector.sub(v2, v1);
    vDiff.normalize();
    return vDiff.heading();
  }
  
  //PVector distanceOnBearing(float dist) {
  //}

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
