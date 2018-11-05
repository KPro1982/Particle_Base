//  Create a panel of toggles
class CPanel {
  ControlP5 panel;
  int nextId;
  int h, w, xPos, yPos;
  PFont myFont;

  CPanel(processing.core.PApplet theParent) {

    myFont = createFont("Arial", 18, true); // use true/false for smooth/no-smooth
    panel = new ControlP5(theParent);
    nextId = 0;
    h = 75;
    w = 75;
    xPos = 0;
    yPos = 0;
    
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
  
    void addToggle(String tnames[]) {
    for (String s : tnames) {
      addToggle(s);
    }
      

  }

  void setPosition(int _x, int _y) {
    xPos = _x;
    yPos = _y;
  }
  void testLabel() {
    Controller c = panel.getController("ADD");

    println("LEFT: " + c.LEFT_OUTSIDE);
  }
}
