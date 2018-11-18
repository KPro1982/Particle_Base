import controlP5.*; //<>//
import java.util.*;
CPanel myPanel;
World swamp; 
AnimalFactory animalFactory;

boolean pause = false;
boolean bprint = false;
boolean selected = false;

void setup() {
  size(2500, 1500);
  swamp = new World(width, height, width, height);
  animalFactory = new AnimalFactory(swamp);
  Animal newAnimal;

  for (int i = 0; i < 10; i++) {
    if (random(0, 2) > 1.5) {

      newAnimal = animalFactory.getAnimal("Wolf");
    } else {
      newAnimal = animalFactory.getAnimal("Cow");
    }
    newAnimal.randomize();
    swamp.addAnimal(newAnimal);
  }

  myPanel = new CPanel(this);
  myPanel.setButtonSize(100, 75);
  String[] toggles = {"Pause", "Print", "Willtron", "Narwhal"};
  myPanel.addToggle(toggles);


  swamp.setup();
  //swamp.print();
}
void draw() {
  if (!pause) swamp.tick();
  swamp.draw();
}
