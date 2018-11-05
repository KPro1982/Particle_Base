class Particle { //<>// //<>//

  // -------------------------------------------------------------------------
  // DECLARATIONS
  // -------------------------------------------------------------------------


  // IDENTITY
  String name = "Particle";
  World sandbox;


  // PHYSICS

  float px, py, ex, ey;
  float rot;
  int pSize = 1;

  // APPEARANCE
  PImage skin;
  String skinFn;
  private float initialOrientation = -PI/2;  // rotation of image so that forward is up
  boolean hasSkin = false;
  color col;

  // BEHAVIOR
  boolean isSelected = false;
  boolean isObserved = false;
  boolean showSightLine = false;
  boolean mouseOver = false;

  // ***************** END DECLARATIONS **************************************

  // -------------------------------------------------------------------------
  // CONTRUCTORS
  // -------------------------------------------------------------------------
  Particle(World _sandbox) {
    sandbox = _sandbox;

    ex = random(-sandbox.worldWidth/4, +sandbox.worldWidth/4);
    ey = random(-sandbox.worldHeight/4, +sandbox.worldHeight/4);
    px = px();
    py = py();
    col = color(255);
    rot = random(-PI, PI);
  }

  Particle(World _sandbox, float _ex, float  _ey, float _rot) {
    sandbox = _sandbox;

    ex = _ex;
    ey = _ey;
    rot = _rot;
    px = px();
    py = py();
    col = color(255);
  }

  // ********************** END CONSTRUCTORS **************************************

  void draw() {
    //println("Exy: " + ex + ", " + ey + ", " + "Pxy: " + px + ", " + py);

    imageMode(CENTER);



    pushMatrix();
    pushStyle();
    translate(px(), py());
    rotate(rot);
    fill(col);
    if (hasSkin) {
      image(skin, 0, 0);
    } else {
      ellipse(0, 0, 50, 50);
    }
    if (showSightLine) line(0, 0, 0, -500);
    popMatrix();
    popStyle();
  }


  void move(float dist) {
    if (outOfBounds()) {
      rot += PI ;
    }
    ex += dist*cos(rot);
    ey -= dist*sin(rot);
  }



  void loadSkin() {
    if (hasSkin) {
      skin = loadImage(skinFn);
      skin.resize(pSize, pSize);
    }
  }
  void setSkin(String _fn) {
    skinFn = _fn;
    hasSkin = true;
  }

  // ------------------------------------------------------------------------------------
  // ABSTRACT FUNCTIONS
  // ------------------------------------------------------------------------------------
  void run() {
    // blank function to override
  }

  // ********************** END ABSTRACT FUNCTIONS **************************************
  // ------------------------------------------------------------------------------------
  // HELPER FUNCTIONS
  // ------------------------------------------------------------------------------------


  float px() {
    px = map(ex, -sandbox.worldWidth/2, +sandbox.worldWidth/2, 0, sandbox.screenWidth);
    return px;
  }

  float py() {
    py = map(ey, +sandbox.worldHeight/2, -sandbox.worldHeight/2, 0, sandbox.screenHeight);
    return py;
  }

  PVector getPVector() {
    return new PVector(ex, ey);
  }

  void printPhysics() {
    println("environ: (" + ex + "," + ey + ")");
    println("pixel: (" + px + "," + ey + ")");
    println("rotation: radians (" + rot + ") degrees (" + degrees(rot) + ")");
  }
  float distanceTo(Particle _p) {
    float dx = ex - _p.ex;
    float dy = ey - _p.ey;
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
    PVector oVect = PVector.fromAngle(-rot);
    float h1 = oVect.heading();
    float h2 = vDiff.heading();
    println(degrees(h1) + ", " + degrees(h2));
    angle2 = h1 + h2;
    return angle2;
  }
  
  float bearingTo(Particle p1, Particle p2) {
    PVector px1 = new PVector(p1.px(),p1.py());
    PVector px2 = new PVector(p2.px(),p2.py());
    return bearingTo(px1,px2);
  }
  
  float bearingTo(PVector v1, PVector v2) {
    PVector vDiff = PVector.sub(v2, v1);
    vDiff.normalize();
    return vDiff.heading();
    
  }

  boolean outOfBounds() {
    if (abs(ex) > sandbox.worldWidth/2-50) {
      return true;
    } else if (abs(ey) > sandbox.worldHeight/2-50) {
      return true;
    } else {
      return false;
    }
  }

  // ********************** END HELPER FUNCTIONS ******************************************

  // --------------------------------------------------------------------------------------
  // MOUSE CONTROL HANDLERS
  //  -------------------------------------------------------------------------------------
  boolean mouseOver() {
    float dx = abs(mouseX - px());
    float dy = abs(mouseY - py());
    float dist = sqrt(dx*dx+dy*dy);
    if (dist <= pSize) {  // mouse is over
      mouseOver = true;
    } else {
      mouseOver =false;
    }
    return mouseOver;
  }

  void mouseDragged() {

    float xOffset = px() - mouseX;
    float yOffset = py() - mouseY;
    //println("xOffset:" + xOffset + ", yOffset:" + yOffset);
    ex -= xOffset;
    ey += yOffset;


  }
  // ********************** END MOUSE CONTROL HANDLERS ************************************
}
