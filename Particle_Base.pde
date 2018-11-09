import controlP5.*; //<>//
CPanel myPanel;
World swamp; 


void setup() {
  size(2000, 2000);
  swamp = new World(width, height, width, height);
  swamp.createParticle(0, 0, 0);
  swamp.createParticle(0, 100, PI);
  //swamp.createParticle();
  myPanel = new CPanel(this);
  myPanel.setButtonSize(100, 75);
  String[] toggles = {"Mouse", "Sel", "Drag", "Add"};
  myPanel.addToggle(toggles);

  println(swamp.entities.get(0));


  swamp.setup();
  
}
void draw() {
  swamp.draw();
}
