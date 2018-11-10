class Vision implements ISenseStrategy {
  float range =  100;
  float field = 2*PI;
  ICanSense body;
  World world;
  String name = "Sensor";
  boolean showSightCone = true;



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




  void drawSenseCone() {
    float v1x, v1y, v2x, v2y;

    v1x = range*cos(-field/2);
    v1y = range*sin(-field/2);
    v2x = range*cos(field/2);
    v2y = range*sin(field/2);

    pushStyle();
    stroke(210);
    if (showSightCone) {
      if (sensed.size() > 0) {
        fill(0, 255, 0, 100);  // green cone if can see
      } else {
        fill(210, 100);  // otherwise gray
      }
      arc(0, 0, range, range, -field/2, field/2);  // assumes translated to 0,0 BRITTLE
    }
    popStyle();
  }
}
