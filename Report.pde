void Report(IReportable rObj) {

  ArrayList<String> data = rObj.getReport();

  println("-----------------------------------");
  for (int i = 0; i < data.size(); i += 2) {
    print(data.get(i) + " " + data.get(i+1));
    println("");
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
