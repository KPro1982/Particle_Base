import controlP5.*; //<>//
import java.util.*;
CPanel myPanel;
World swamp; 

boolean pause = true;
boolean bprint = false;
boolean selected = false;

void setup() {
  size(2000, 2000);
  swamp = new World(width, height, width, height);

  swamp.createParticle(0, 0, 0);
  swamp.createParticle(500, 100, PI);
  swamp.createParticle(100, 200, PI/2);
  swamp.createParticle(700, 700, -PI/2);

  myPanel = new CPanel(this);
  myPanel.setButtonSize(100, 75);
  String[] toggles = {"Pause", "Print", "Select", "Add"};
  myPanel.addToggle(toggles);


  swamp.setup();
  //swamp.print();
}
void draw() {
  if (!pause) swamp.step();
  swamp.draw();
}
