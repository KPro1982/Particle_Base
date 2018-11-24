
class ReportWindow {
  ControlP5 reportCP5;
  World world;
  Textarea tOutput;
  String dataText = "";
  int firstId;
  int x, y;

  int tWidth = 500;
  int tHeight = 1000;
  int tLineHeight  = 30;

  ReportWindow(World _world, String _location, int _tWidth, int _tHeight) {


    tWidth = _tWidth;
    tHeight = _tHeight;
    world = _world;

    setLocation(_location);

    reportCP5 = new ControlP5(thisApp);
    tOutput = reportCP5.addTextarea("output")
      .setPosition(x, y)
      .setSize(tWidth, tHeight)
      .setFont(createFont("arial", tLineHeight))
      .setLineHeight(tLineHeight)
      .setColor(color(128))
      .setColorBackground(color(255, 100))
      .setColorForeground(color(255, 100));
    ;
  }
  void setLocation(String _location) {
    switch(_location) {
    case "TOPLEFT":
      x = 0;
      y = 0;
      break;
    case "TOPRIGHT":
      x = int(swamp.screenWidth-tWidth);
      y = 0;
      break;
    default:
      x = 0;
      y = 0;
      break;
    }
  }

  void output(ArrayList<String> data) {

    tOutput.clear();
    dataText = "";
    for (int i = 0; i < data.size()-1; i += 2) {
      dataText += data.get(i) + " " + data.get(i+1) + "\n";
    }
    tOutput.setText(dataText);
  }

  void output(IReportable rObj) {
    output(rObj.getReport());
  }
}

  void Console(IReportable s) {
    if (bprint) {
      println(s);
    }
  }
  void Console(String s) {
    if (bprint) {
      println(s);
    }
  }
