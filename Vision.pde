class PredatorVision extends Vision {
  
  PredatorVision(ICanSense _self)  {
    super(_self);
    range = 300;
    field = PI/4;
    coneCol = color(255,0,0,100);
  }
  
  
}

class PreyVision extends Vision {
  
  PreyVision(ICanSense _self)  {
    super(_self);
    range = 150;
    field = radians(300);
    coneCol = color(0,255,0,100);
  }
  
  
}


class Vision implements ISenseStrategy {
  float range =  0;
  float field = 0;
  ICanSense self;
  World world;
  String name = "Sensor";
  boolean showSightCone = true;
  color coneCol;



  ArrayList<ISensable> sensed;

  Vision(ICanSense _self) {
    self = _self;
    world = self.getWorld();
    sensed = new ArrayList<ISensable>();
  }

  ArrayList<ISensable> sense() {
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
            if (bprint) {
              bprint = !bprint;
            println("("+ self.getId() + ") BearingTo (" + sensedBody.getId() + "): " + degrees(bTo) + " deg, " + dist);
            }
            
            sensed.add(sensedBody);
            sensedBody.addSensedBy(self);
          }
        }
      }
    }

    return sensed;
  }




  void drawSenseCone() {
 

    pushStyle();
    stroke(210);
    if (showSightCone) {
      if (sensed.size() > 0) {
        fill(coneCol);  // green cone if can see
      } else {
        fill(210, 100);  // otherwise gray
      }
      arc(0, 0, range*2, range*2, -field/2, field/2);  // assumes translated to 0,0 BRITTLE
    }
    popStyle();
  }
}
