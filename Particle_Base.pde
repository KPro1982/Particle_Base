import controlP5.*; //<>//
import java.util.*;
CPanel myPanel;
World swamp; 
AnimalFactory animalFactory;


boolean pause = false;
boolean bprint = false;
boolean bSelected = false;
boolean bFreeze = false;
boolean bToMouse = false;
boolean bScale = false;

void setup() {
  size(2500, 2000);
  swamp = new World(width, height, width*2, height*2);
  animalFactory = new AnimalFactory(swamp);
  Animal newAnimal;

  for (int i = 0; i < 20; i++) {
    newAnimal = animalFactory.getAnimal("Sheep");
    newAnimal.randomize();
    swamp.addAnimal(newAnimal);
  }
  for (int i = 0; i < 5; i++) {
  newAnimal = animalFactory.getAnimal("Wolf");
  swamp.addAnimal(newAnimal);
  }
  
  myPanel = new CPanel(this);
  myPanel.setButtonSize(100, 75);
  String[] toggles = {"Freeze", "Scale", "Print", "Select"};
  myPanel.addToggle(toggles);


  swamp.setup();
  //swamp.print();
}
void draw() {
  if (!pause) swamp.tick();
  swamp.draw();
}
