import controlP5.*; //<>//
import java.util.*;
CPanel myPanel;
World swamp; 
AnimalFactory animalFactory;

boolean pause = false;
boolean bprint = false;
boolean selected = false;
boolean bFreeze = false;

void setup() {
  size(2500, 1500);
  swamp = new World(width, height, width, height);
  animalFactory = new AnimalFactory(swamp);
  Animal newAnimal;

  for (int i = 0; i < 1; i++) {
    newAnimal = animalFactory.getAnimal("Sheep");
    newAnimal.randomize();
    swamp.addAnimal(newAnimal);
  }
  
  newAnimal = animalFactory.getAnimal("Wolf");
  newAnimal.toggleTagged();
  swamp.addAnimal(newAnimal);
  
  myPanel = new CPanel(this);
  myPanel.setButtonSize(100, 75);
  String[] toggles = {"Pause", "Print", "Freeze", "Narwhal"};
  myPanel.addToggle(toggles);


  swamp.setup();
  //swamp.print();
}
void draw() {
  if (!pause) swamp.tick();
  swamp.draw();
}
