// process tab
void setupProcess() {
   cp5c = new ControlP5(this); 
  cp5c.addButton("display")
    .setPosition(30, 65)
      .setSize(45, 20)
        //   .setImages(imgs)
        //    .updateSize()
        ; 
 cp5c.addButton("Cursor")
    .setPosition(700, 285)
      .setSize(65, 20)
        //   .setImages(imgs)
        //    .updateSize()
        ; 
         cp5c.addButton("sel_bkgnd_scan")
    .setPosition(700, 65)
      .setSize(65, 20)
 ;
          cp5c.addButton("sel_ref_scan")
    .setPosition(700, 95)
      .setSize(65, 20)
 ;
         cp5c.addButton("calc_abs")
    .setPosition(780, 95)
      .setSize(65, 20)
 ;
   cp5c.addButton("bkgnd_subt")
    .setPosition(780, 65)
      .setSize(65, 20)
 ;
    cp5c.addButton("view")
    .setPosition(750, 215)
      .setSize(65, 20)
 ;
     cp5c.addButton("smooth")
    .setPosition(700, 125)
      .setSize(65, 20)
 ;
 yAvg = cp5c.addTextfield("yAvg")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(780, 125)
            .setSize(30, 20)
              .setText("7");
 
    cp5c.addButton("trim")
    .setPosition(750, 245)
      .setSize(65, 20)
 ;
 
 slider0 = cp5c.addSlider("slider0")
    .setPosition(265, 465)
      .setSize(400, 5)
      .setRange(0,1)
 //     .setNumberOfTickMarks(20)
      .setValue(0.500)
      
      ;
       
         
}

void display(){
 for(int y = 0; y<spectra; y++){
   selectBox[y] = true;
 }
  selTxt = "None selected";
  selected = false;
}

void Cursor(){
  /// calculate indexing
 cursorShow =! cursorShow;
 slider0(0.5);

}

   void smooth(){
     int av = int(cp5c.get(Textfield.class, "yAvg").getText());
     
     av /=2 ;
     for (int u = 0; u<spectra; u++){
       for(int y = av; y<nPixels-av-3; y++){  // changed from nPiels-av-1
         float j = 0;
       for (int p = -av;p<av+1;p++){
         j = j+ yCalc[u][y+p];
     if(y == 200){
       
         println("spectrum: "+u+", value: "+j/7+"yCalc: "+yCalc[u][y]);  // problem: gives value of NaN
       }  
     }
       yCalc[u][y] = j/(2*av+1);
       
       }
     }
     displayCharts();
   }
   
   
   
   void trim(){
     firstPixel=0;
     lastPixel=0;
     zoom();
     setZero();
     trimmed = true;
     trimXMin = zoomXMin;
     trimXMax = zoomXMax;
    for (int u=0; u<spectra; u++){
      for (int y=1; y<nPixels-3; y++){  // changed y min to 1 from 0
        if(xVal[y]<zoomXMin){
        yCalc[u][y] = 0;
         if (firstPixel ==0){
        firstPixel = y;
         }
        }
        if(xVal[y]>zoomXMax ){
          yCalc[u][y] = 0;
          if(lastPixel == 0){
        lastPixel = y-1;
      }
      }  // end of max
     } // lend of y loop
//     println("spectra trimmed");
       shortenFile(u);
    }// lend of u loop
    // calculate Y limits
    float maxY;
    float minY;
    trimYMax = 0;
    trimYMin = 0;
    for (int p = 0; p<spectra; p++){
     minY = min(yCalc[p]);
      maxY = max(yCalc[p]);
     trimYMax = max(trimYMax, maxY);
     trimYMin = min(trimYMin, minY);
    }
    displayCharts();  // not sure this is needed
   }   //end of void trim
   
   void setZero(){    // xVal[1] changed to xVal[2]
   println("in setZero loop");
   println("last X value: "+xVal[nPixels-3]);
   waveSlope = (xVal[nPixels-3]-xVal[2])/(nPixels-3);
     println("waveSlope: "+waveSlope);
     println("first wavelength: " + xVal[2]);
     // subtract value at 700 nm
     waveIndex = int((700-xVal[2])/waveSlope);  // changed
     println("wave index: "+waveIndex);
     for(int p=0; p< spectra; p++){
      if(p!=bkground_scan && p != ref_scan){
        Const = yCalc[p][waveIndex];
       for(int w=0; w<nPixels-3; w++){       // problem here?
        yCalc[p][w] = yCalc[p][w]-Const; 
       }
      }
     }
     
   }
   
   void shortenFile(int f){
     for (int g = 0; g< lastPixel-firstPixel; g++){
       yCalc[f][g]=yCalc[f][g+firstPixel];
     }
     for (int h = lastPixel - firstPixel; h<nPixels-2; h++){
      yCalc[f][h]=0; 
     }
   }
void view(){
viewVal = (viewVal+1)%2;
displayCharts();
println("view value: "+viewVal);
}

void sel_bkgnd_scan(){
bkground_scan = selVal;
println("background scan number: "+bkground_scan);
}
void sel_ref_scan(){
ref_scan = selVal;
cHeader[selVal] = "ref scan";
//println("ref scan number: "+ref_scan);
}

void bkgnd_subt(){   // error in here somewhere
viewVal = 1;  //display background subtracted spectra 
bkgndCor = true;

  if (bkground_scan != 999){
    println("subtracting backgound scan number "+bkground_scan);
    for (int q = 0; q< spectra; q++){
      println("spectrum: "+q);

     for(int t = 0; t< nPixels-3; t++){
       yCalc[q][t] = yVal[q][t]-yVal[bkground_scan][t];
     }
    }
// get background int, subtract background from each spectrum 

  }
  display();
}

void calc_abs(){   
viewVal = 1;  //display background subtracted spectra 
  if(bkgndCor == false){
    if(bkground_scan != 999){
      bkgnd_subt();
    }else{
      println("no background scan used");  // this looks ok
    }
  }
  if (ref_scan != 999){
    println("reference scan number "+ref_scan); // looks ok
    for (int q = 0; q< spectra; q++){
      if(q!= bkground_scan){
      println("spectrum: "+q);

     for(int t = 0; t< nPixels-3; t++){

       yCalc[q][t] = yVal[q][t]/yVal[ref_scan][t];
       if(yCalc[q][t] > 1){yCalc[q][t] =1;}
       if(yCalc[q][t] < 0.00001){yCalc[q][t] = 0.00001;}
       yCalc[q][t] = -log(yCalc[q][t])/log(10);
      if(t%1000==0){      // looks good
         print(yCalc[q][t]+", ");
       }
     }
         println("");
      }
    }

// get background int, subtract background from each spectrum 

  }
  display();
  println("displayed");
  println("wavelengths, y values");
  print(xVal.length+", ");
  for (int y = 0; y<spectra; y++){
  print(yCalc[y].length+", ");  // gives the correct number of values
  }
  println("");
 // displayCharts();
}

void slider0(float fraction){
  fract = fraction;
//  find cursor wavelength
  cursorWavelength = fract*(zoomXMax -zoomXMin) +zoomXMin;
  cursorGPixel = int(fract*400) + 265;
 
  boolean pixPick = false;
  int j = 0;
  // find pixel number associated with cursor wavelength
  while(j<nPixels && pixPick == false){
  if(xVal[j] < cursorWavelength){
  j++;
  }else{
    // set cursor pixel, flip boolean
    cursorPixel = j;
    pixPick = true;
  }
  }
  if(xVal.length>2){
  println("fraction: "+ fract+", cursor: "+xVal[cursorPixel]); //cursorWavelength);
  }
  if(cursorShow == true){
   //cursorView(); 
  }
}
