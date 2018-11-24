float startX, startY;
void mouseDragged() {
  if (bScale) {

    if (startX == 0) {
      startX = mouseX;
      startY = mouseY;
    }
    float xOffset = startX - mouseX;
    float yOffset = startY - mouseY;
    println("Mouse(" + mouseX + "," + mouseY + "); Offset(" + xOffset + "," + yOffset + ")");
    swamp.addOffset(new PVector(xOffset, -yOffset));
    startX = mouseX;
    startY = mouseY;
    
  } else {

    swamp.mouseDragged();
  }
}

void mouseClicked()
{
  if (bScale) {
    //startX = mouseX;
    //startY = mouseY;
  } else {
    swamp.mouseClicked();
  }
}

void mouseReleased() {
  swamp.mouseReleased();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  println(e);
  if (bScale) {
    swamp.addScale(e);
    println(e + "," + swamp.getScale());
  }
}
