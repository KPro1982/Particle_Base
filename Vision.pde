class PredatorVision extends Vision {

  PredatorVision(ICanSense _self) {
    super(_self);
    acuity = 100;
    range = 450;
    field = PI/6;
    coneCol = color(255, 0, 0, 100);
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
  boolean showSightCone = true;
  color coneCol;



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

    for (ISensable sensedBody : world.entities) {
      if (self != sensedBody) {
        float dist = self.distanceTo(sensedBody);  // within vision range
        if (dist < range) {
          float bTo = self.getRotation()  - self.bearingTo(self, sensedBody);
          if (bTo <= +field/2 && bTo >= -field/2) {  // within angle of vision
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

  boolean isVisible(ISensable b) {
    //if (!b.isDead()) {
    //  float chance = b.getVisibility() * acuity;
    //  return random(0, 10000) <= chance;
    //} else {
    //  return false;
    //}
    return true;  // temporarily disable acuity mechanic for testing
  }

    void drawSenseCone() {


      pushStyle();
      stroke(210);
      if (showSightCone) {
        if (observations.size() > 0) {
          fill(coneCol);  // colored cone cone if can see
        } else {
          fill(210, 100);  // otherwise gray
        }
        arc(0, 0, range*2, range*2, -field/2, field/2);  // assumes translated to 0,0 BRITTLE
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
