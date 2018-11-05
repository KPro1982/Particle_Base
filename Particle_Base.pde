import controlP5.*; //<>//
CPanel myPanel;
World swamp; 

boolean rotateMouse = false;
boolean rotateSelected = false;
boolean rotateDrag = false;

void setup() {
  size(2000, 2000);
  swamp = new World(width, height, width, height);
  swamp.createParticle(0, 0, -PI/2);
  swamp.createParticle(0, 100, PI);
  //swamp.createParticle();
  myPanel = new CPanel(this);
  myPanel.setButtonSize(100, 75);
  String[] toggles = {"Mouse", "Sel", "Drag", "Add"};
  myPanel.addToggle(toggles);




  swamp.setup();
 
}


void draw() {

  swamp.run();
  swamp.draw();
}

void mouseClicked() {
  Particle p = swamp.isMouseOver();
  if (p == null) {
    swamp.setSelected(null);
  } else {

    swamp.setSelected(p);
  }
}

void mouseDragged() {
  Particle p = swamp.isMouseOver();
  if (p != null) {
    if (rotateDrag) {
      for (Particle pp : swamp.particles) {
      pp.rotateTo(p);
      }
    }
    p.mouseDragged();
  }
}

public void Mouse(int theValue) {
  rotateMouse = !rotateMouse;
}
public void Sel(int theValue) {

  rotateSelected = !rotateSelected;
}

public void Drag(int theValue) {

  rotateDrag = !rotateDrag;
}
public void Add(int theValue) {
  swamp.createParticle();
}
