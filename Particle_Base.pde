import controlP5.*; //<>//
import java.util.*;
CPanel myPanel;
World swamp; 


void setup() {
  size(2000, 2000);
  swamp = new World(width, height, width, height);

  swamp.createParticle(0, 100, 1);
    swamp.createParticle(500, 100, 2);
    swamp.createParticle(100,200,3);
    
  myPanel = new CPanel(this);
  myPanel.setButtonSize(100, 75);
  String[] toggles = {"Mouse", "Sel", "Drag", "Add"};
  myPanel.addToggle(toggles);


  swamp.setup();
  swamp.sortByDistance(new Entity(swamp,0,0,0));
  swamp.print();
  
}
void draw() {
  swamp.draw();
}
