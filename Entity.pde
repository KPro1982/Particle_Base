class Entity implements IHaveParticle, ISensable, ICanSense, IClickable {
  String name = "Enity";
  Particle particle;
  PImage skin;
  String skinFn;
  private boolean hasSkin = false;
  private int skinSize;
  color col = 255;
  float pSize = 50;
  boolean showSightLine = true;
  boolean showSenseCone = true;
  boolean sensed;
  ArrayList<ISenseStrategy> senses;
  ArrayList<ICanSense> sensedBy;
  World world;

  Entity(World _world, float _ex, float _ey, float _rot) {
    world = _world;
    particle = new Particle(world, _ex, _ey, _rot);
    senses = new ArrayList<ISenseStrategy>();
    sensedBy = new ArrayList<ICanSense>();
  }

  Particle getParticle() {
    return particle;
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

  void loadSkin() {
    if (hasSkin) {
      skin = loadImage(skinFn);
      skin.resize(skinSize, skinSize);  // assume square image
    }
  }
  void setSkin(String _fn) {
    skinFn = _fn;
    hasSkin = true;
  }
  float getRotation() {
    return getParticle().getRotation();
  }
  void setRotation(float _rot) {
    getParticle().setRotation(_rot);
  }

  void addSense(ISenseStrategy _senseStrategy) {
    senses.add(_senseStrategy);
  }

  float bearingTo(IHaveParticle p1, IHaveParticle p2) {
    return getParticle().bearingTo(p1.getParticle(), p2.getParticle());
  }
  float distanceTo(IHaveParticle _p) {
    return getParticle().distanceTo(_p.getParticle()) ;
  }
  
  boolean outOfBounds()  {
   return getParticle().outOfBounds(); 
  }

  void sense() {
    for (ISenseStrategy iss : senses) {
      iss.sense();
      //println("Objects sensed = " + iss.sense().size());
    }
  }

  void addSensedBy(ICanSense p) { 
    sensed = true;
    col = color(0, 255, 0);
    sensedBy.add(p);
  }
  
  void removeSensedBy(ICanSense s)  {
    sensed = false;
    col = color(255);
    while (sensedBy.remove(s)) {  
      // remove all instances of s in list
    }
  }
  

    

  void draw() {


    imageMode(CENTER);

    pushMatrix();
    pushStyle();
    translate(px(), py());
    rotate(getRotation());
    fill(col);
    if (hasSkin) {
      image(skin, 0, 0);
    } else {
      ellipse(0, 0, pSize, pSize);
    }
    if (showSightLine) line(0, 0, pSize/2, 0);
    if (showSenseCone) {
       for (ISenseStrategy iss : senses) {
         iss.drawSenseCone();
       }
       
      
    }
    popMatrix();
    popStyle();
  }

  String toString() {
    return name + ": e(" + ex() + "," + ey()+ "); p(" + px() +"," + py() + "); Rot: " + getRotation();
  }



  // --------------------------------------------------------------------------------------
  // MOUSE CONTROL HANDLERS
  //  -------------------------------------------------------------------------------------
  boolean mouseOver() {
    float dx = abs(mouseX - px());
    float dy = abs(mouseY - py());
    float dist = sqrt(dx*dx+dy*dy);
    if (dist <= pSize) {  // mouse is over
      return true;
    } else {
      return false;
    }
  }

  void mouseDragged() {

    float xOffset = px() - mouseX;
    float yOffset = py() - mouseY;
    //println("xOffset:" + xOffset + ", yOffset:" + yOffset);
    ex(ex() - xOffset);
    ey(ey() + yOffset);
  }

  void mouseClicked() {
    //if (col == color(255, 0, 0)) {
    //  col = 255;
    //} else {
    //  col = color(255, 0, 0);
    //}
  }
  // ********************** END MOUSE CONTROL HANDLERS ************************************
}
