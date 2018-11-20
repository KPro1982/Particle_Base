class PredatorVision extends Vision {

  PredatorVision(ICanSense _self) {
    super(_self);
    acuity = 100;
    range = 650;
    field = PI/2;
    coneCol = color(255, 0, 0, 100);
    //showSightCone = true;
  }
}

class PreyVision extends Vision {

  PreyVision(ICanSense _self) {
    super(_self);
    acuity = 100;
    range = 200;
    field = radians(300);
    coneCol = color(0, 255, 0, 100);
  }
}


class Vision implements ISenseStrategy {
  float acuity;
  float range =  0;
  float field = 0;
  ICanSense self;
  World world;
  String name = "Sensor";
  color coneCol;
  float dist, bTo;  



  ArrayList<ISensable> sensed;
  ArrayList<Observation> observations;

  Vision(ICanSense _self) {
    self = _self;
    world = self.getWorld();
    sensed = new ArrayList<ISensable>();
    observations = new ArrayList<Observation>();
  }

  ArrayList<Observation> sense() {
    for (ISensable pp : sensed) {  
      pp.removeSensedBy(self);  // clear sensedBy flags in other objects
    }
    sensed.clear();

    for (ISensable sensedBody : world.animals) {
      if (self != sensedBody) {
        dist = self.distanceTo(sensedBody);  // within vision range
        bTo = self.bearingTo(self, sensedBody);
        float rot = self.getRotation();
        if (dist < range) {

          if (bTo <= rot + field/2 && bTo >= rot -field/2) {  // within angle of vision
            sensed.add(sensedBody);  // it is sensed but not necessarily observed;
            if (isVisible(sensedBody)) {       // can sense it
              addObservation(sensedBody.getObservation());
              sensedBody.addSensedBy(self);
            }
          }
        }
      }
    }

    return observations;
  }

  ArrayList<String> getReport() {
    ArrayList<String> report = new ArrayList<String>();
    report.add("Distance:");
    report.add(str(dist));
    report.add("AngleTo:");
    report.add(str(degrees(bTo)));
    report.add("Field:");
    String ss = str(degrees(-field/2)) + "," + str(degrees(+field/2));
    report.add(ss);
    report.add("In Sight: ");
    String oo = "";
    for (ISensable o : sensed) {
      oo += o.getId() + ",";
    }
    report.add(oo);
    return report;
  }

  boolean isVisible(ISensable b) {
    //if (!b.isDead()) {
    //  float chance = b.getVisibility() * acuity;
    //  return random(0, 10000) <= chance;
    //} else {
    //  return false;
    //}
    return true;  // temporarily disable acuity mechanic for testing
  }

  void drawSenseCone(int _color) {

    float rot = self.getRotation();
    pushStyle();
    stroke(210);
    if (true) {
      fill(_color);  // colored cone cone if can see
      arc(0, 0, range*2, range*2, rot-field/2, rot+field/2);  // assumes translated to 0,0 but not rotated
      stroke(color(255, 0, 0));
      line(0,0,250, 0);
    }
    popStyle();
  }
  void addObservation(Observation _obs) {
    // is it already in observations
    for (int i = 0; i < observations.size(); i++) {
      Observation o = observations.get(i);
      if (_obs.parent == o.parent) {
        observations.remove(i);  // remove old duplicates
      }
    }
    observations.add(_obs);  // add now that all duplicates have been removed
  }
}
