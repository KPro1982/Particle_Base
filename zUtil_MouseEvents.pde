float oldX, oldY;
void mouseDragged() {
  if (bScale) {
    if (oldX == 0) {
      oldX = mouseX;
      oldY = mouseY;
    }
    float xOffset = oldX - mouseX;
    float yOffset = oldY - mouseY;
    swamp.addOffset(new PVector(xOffset, -yOffset));
    oldX = mouseX;
    oldY = mouseY;
  } else {

    swamp.mouseDragged();
  }
}

void mouseClicked()
{
  if (bScale) {
    oldX = 0;
    oldY = 0;
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
