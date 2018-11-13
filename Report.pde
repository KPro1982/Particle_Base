ControlP5 reportCP5;
Textarea output;
String dataText = "";
int firstId;

void Report(IReportable rObj) {
  ArrayList<String> data = rObj.getReport();

  int tWidth = 400;
  int tHeight = 1000;
  int tLineHeight  = 30;


  if (reportCP5 == null) {  // only create the first time
    reportCP5 = new ControlP5(this);
    output = reportCP5.addTextarea("output")
      .setPosition(swamp.screenWidth-tWidth, 0)
      .setSize(tWidth, tHeight)
      .setFont(createFont("arial", tLineHeight))
      .setLineHeight(tLineHeight)
      .setColor(color(128))
      .setColorBackground(color(255, 100))
      .setColorForeground(color(255, 100));
    ;
    firstId = rObj.getId();
  }

  if (firstId == rObj.getId()) {  // if repeating reset console
    output.clear();
    dataText = "";
  } else if (dataText.length() > 200) {
    output.clear();
    dataText = "";
  }

  for (int i = 0; i < data.size()-1; i += 2) {
    dataText += data.get(i) + " " + data.get(i+1) + "\n";
  }
  output.setText(dataText);
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
