void setupButtons() {
  //  PImage[] run_imgs = {loadImage("run_button1.png"),loadImage("run_button2.png"),loadImage("run_button3.png")};
 //   PImage[] stop_imgs = {loadImage("stop_button1.png"),loadImage("stop_button2.png"),loadImage("stop_button3.png")};
 //   PImage[] togs = {loadImage("tog_button1.png"),loadImage("tog_button2.png"),loadImage("tog_button3.png")};
 cp5 = new ControlP5(this);  
 
    loadFile = cp5.addButton("loadFile")
     .setPosition(20,20)
     .setSize(60,20)
                       .setLabel("Load File")
//    .setImages(run_imgs)
   ;
    saveFile = cp5.addButton("saveFile")
     .setPosition(120,20)
     .setSize(60,20)
//    .setImages(run_imgs)
   ;
   
}

void loadFile(){
     selectInput("Select a data file:", "fileToLoad");
}

void fileToLoad(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } 
  else {
   //  xVal = new float[20];  
   //  yVal = new float[20][0];
    String[] file2str = loadStrings(selection.getAbsolutePath());
    headers = split(file2str[0],',');  // split the first line
    println("first header: "+ headers[0]);
    String[] sText = split(file2str[1],','); 
    spectra = sText.length-1;
    println("number of spectra: "+spectra);
    for (int p = 0; p< spectra; p++){
     sFileName[p] = headers[p+1];// assigning names to spectra
     println("File name "+p+": "+sFileName[p]);
     cHeader[p] = sFileName[p];  // file name for processed data, change later
    }
    nPixels = file2str.length;
    println("data size: "+nPixels);  //3651
 //   println("buttons 40");
    for (int j = 0; j<nPixels-3; j++){  // for each wavelength
      // println(file2str[j+2]);
       String[] tokens = split(file2str[j+2],',');

       xVal = append(xVal,Float.parseFloat(tokens[0]));
         for(int m = 0; m<spectra; m++){
         //  int x = 2*m;
           //int y = x+1;
           if(tokens[m] == null){
             println("empty thing");
           }
           else{
  float yValue = float(tokens[m+1]);
      yVal[m] = append(yVal[m],yValue); 
      yCalc[m] = append(yCalc[m],yValue);
           }
//       print("spectrum "+sFileName[m]);
  //    print(", x points: "+xVal.length);
    //   println(", y points: "+yVal[m].length);
      } 
    }
      print("X values: "+xVal.length);
      for (int i=0; i<spectra; i++){
  print(", spectrum "+i+": "+yVal[i].length);
  selectBox[i] = true;
}
println("");
    //}
 
  }

for (int i=0; i<spectra; i++){
//  print("spectrum "+i+": "+yVal[i].length);
  selectBox[i] = true;
}
//println("");

}

void saveFile(){
  println("in Save file");
  generateFile1();  // generate file to save;
  println("File1 begun");
  selectOutput("Select a file to save:", "fileSelected"); 
}

void fileSelected(File selection){
    if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {

    file2 = selection.getAbsolutePath();
    println("User selected " + file2);
    try {
      println("second time arround");
  //    println(file1);
      //  saveStream(file2,file1);
      saveStrings(file2, file1);
    }
    catch(Exception e) {
      println("problem in saveStream");
    }
  }
}

void generateFile1(){
 // println(" line 103");
  genCalcHeaders();

  String line;
 file1 = append(file1,calcHeaders);
 println("headers generated");
 for (int p = 0; p<nPixels-3; p++){
   line =str(xVal[p])+",";
  for(int j = 0; j<spectra; j++){
    line = line+str(yCalc[j][p])+",";
  }
//  println("generated line "+p);
  file1 = append(file1,line);
 }
}

void genCalcHeaders(){
  
  for (int u = 0; u<spectra; u++){
   // if(u!=bkground_scan && u != ref_scan){
     calcHeaders = calcHeaders +","+ cHeader[u]; 
    //}
  }
}
