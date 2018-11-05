class LadyBug extends Particle {
  Sensor eyes;
  Particle mate = this;

  LadyBug(World _sandbox) {
    super(_sandbox);
    name = "LadyBug";
    pSize = 40;
    eyes = new Sensor(this, 500, PI/8);
    super.setSkin("Bug.png");
  }

  LadyBug(World _sandbox, float _ex, float _ey, float _rot) {

    super(_sandbox, _ex, _ey, _rot);
    name = "LadyBug";
    pSize = 40;
    eyes = new Sensor(this, 500, PI/8);
    super.setSkin("Bug.png");
  }

  void run() {

    if (rotateMouse) {
      rotateToMouse();
    } else if (rotateSelected) {
      rotateTo(sandbox.selected);
    }
    eyes.sense();
    for (Particle aP : sandbox.particles) {
      aP.isObserved = false;  // reset to white
    }
    for (Particle p : eyes.canSeeParticles) {
      p.isObserved = true;
      mate = p;
    }
    rotateTo(mate);
    move(2);
  }



  void draw() {
    eyes.draw();
    pushStyle(); //<>//
    if (isSelected) {
      col = color(255, 0, 0);
    } else if (isObserved) {
      col = color(0, 255, 0);
    } else {
      col = color (255);
    }
    fill(col);
    ellipse(px(),py(),50,50);
    popStyle();
    super.draw();
  }
}
