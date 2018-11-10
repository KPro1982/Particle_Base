class Vision implements ISenseStrategy {
  float range =  200;
  float field = PI/4;
  ICanSense body;
  World world;
  String name = "Sensor";
  boolean showSightCone = true;
  boolean canSee = false;


  ArrayList<ISensable> sensed;

  Vision(ICanSense _body) {
    body = _body;
    world = body.getWorld();
    sensed = new ArrayList<ISensable>();
  }

  ArrayList<ISensable> sense() {
    for (ISensable pp : sensed) {  
      pp.removeSensedBy(body);  // clear sensedBy flags in other objects
    }
    sensed.clear();
    
    for (ISensable ss : world.entities) {
      if (body != ss) {
        float dist = body.distanceTo(ss);
        //ss.setSensed(false);
        if (dist < range) {
          float bTo = body.bearingTo(body, ss);
          if (abs(body.getRotation()  - bTo) <= field) {
            sensed.add(ss);
            ss.addSensedBy(body);
          }
        }
      }
    }

    return sensed;
  }
}



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
