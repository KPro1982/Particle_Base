class Vision implements SenseStrategy { //<>//
  float range = 1000;
  float field = PI/4;
  ICanSense body;
  World world;
  String name = "Sensor";
  boolean showSightCone = true;
  boolean canSee = false;


  ArrayList<ISensable> sensed;

  Vision(ICanSense _e, float _range, float _field) {
    range = _range;
    field = _field;

    body = _e;
    world = _e.getWorld();
    sensed = new ArrayList<ISensable>();
  }

//  ArrayList<ISensable> sense() {
//    sensed.clear();

//    for (IHaveParticle p : world.entities) {
//      if (p != body) {
//        float bTo =  body.getParticle().bearingTo(body,p); //<>//
//        println("P1:");
//        body.printPhysics();
//        println("P2:");
//        p.printPhysics();
//        println("Bearingto: " + degrees(bTo) + " rot: " + degrees(body.rot));

//        if (abs(body.rot - bTo) <= field) {
//          if (body.distanceTo(p) <= range) { 
//            canSeeParticles.add(p);
//          }
//        }
//      }
//    }
//    if (canSeeParticles.size() == 0) {
//      canSee = false;
//    } else {
//      canSee = true;
//    }
//    return canSeeParticles;
//  }
//  //void draw() {


//  //  pushStyle();
//  //  pushMatrix();
//  //  translate(body.px(), body.py());
//  //  rotate(body.rot);
//  //  noStroke();
//  //  drawSightCone();
//  //  popMatrix();
//  //  popStyle();
//  //}


////  void drawSightCone() {
////    float v1x, v1y, v2x, v2y;

////    v1x = range*cos(-field/2);
////    v1y = range*sin(-field/2);
////    v2x = range*cos(field/2);
////    v2y = range*sin(field/2);

////    if (showSightCone) {
////      if (canSee) {
////        fill(0, 255, 0, 100);  // green cone if can see
////      } else {
////        fill(210, 100);  // otherwise gray
////      }
////      triangle(0, 0, v1x, v1y, v2x, v2y);
////    }
////  }
////}
