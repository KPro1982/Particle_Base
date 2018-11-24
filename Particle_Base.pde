import controlP5.*; //<>//
import java.util.*;
CPanel myPanel;
World swamp; 
AnimalFactory animalFactory;
PApplet thisApp; 

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
  thisApp = this;

  //for (int i = 0; i < 50; i++) {
  //  newAnimal = animalFactory.getAnimal("Sheep");
  //  newAnimal.randomize();
  //  swamp.addAnimal(newAnimal);
  //}
  //for (int i = 0; i < 10; i++) {
  //  newAnimal = animalFactory.getAnimal("Wolf");
  //  swamp.addAnimal(newAnimal);
  //}
  for (int i = 0; i < 5; i++) {
    newAnimal = animalFactory.getAnimal("Bear");
    swamp.addAnimal(newAnimal);
  }


  myPanel = new CPanel(this);
  myPanel.setPosition("TOPCENTER");
  myPanel.setButtonSize(100, 75);
  myPanel.addToggle(new StringList("Freeze", "Scale", "Print", "Select"));



  swamp.setup();
  //swamp.print();
}
void draw() {
  swamp.tick();
  swamp.draw();
}
