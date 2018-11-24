//  Create a panel of toggles
class CPanel {
  ControlP5 panel;
  int nextId;
  int x, y, h, w, xPos, yPos, totalWidth, numButtons;
  String location;
  PFont myFont;

  CPanel(processing.core.PApplet theParent) {

    myFont = createFont("Arial", 18, true); // use true/false for smooth/no-smooth
    panel = new ControlP5(theParent);
    nextId = 0;
    h = 75;
    w = 75;

  }

  void calculateLocation() {
    switch(location) {
    case "TOPLEFT":
      xPos = 0;
      yPos = 0;
      break;
    case "TOPRIGHT":
      xPos = int(swamp.screenWidth-totalWidth);
      yPos = 0;
      break;
    case "TOPCENTER":
      xPos = int(swamp.screenWidth/2-totalWidth/2);
      yPos = 0;
      break;
    default:
      xPos = 0;
      yPos = 0;
      break;
    }
    println("Pos(" + xPos + "," + yPos + ")");
  }


  void setButtonSize(int _w, int _h) {
    h = _h;
    w = _w;
  }
  void addToggle(String tName) {
    panel.addToggle(tName)
      .setSize(w, h)
      .setPosition(nextId*w+xPos, yPos)
      .setId(nextId++)
      .setFont(myFont)
      ;
    panel.getController(tName).getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);

  }

  void addToggle(StringList tnames) {
    calcPosition(tnames.size());
    for (String s : tnames) {
      addToggle(s);
    }
  }
  void setPosition(String _location) {
    location = _location;
  }
  void calcPosition(int _numButtons) {
    totalWidth = w*_numButtons;
    println("Buttons: " + numButtons + " " + totalWidth);
    calculateLocation();
  }
  void testLabel() {
    Controller c = panel.getController("ADD");

    println("LEFT: " + c.LEFT_OUTSIDE);
  }
}
