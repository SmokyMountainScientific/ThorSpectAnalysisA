// process tab
void setupProcess() {
  cp5trim = new ControlP5(this);

  
   cp5c = new ControlP5(this); 
  cp5c.addButton("disp")
    .setPosition(30, 65)
      .setSize(45, 20)
        //   .setImages(imgs)
        //    .updateSize()
        ; 

         cp5c.addButton("sel_bkgnd_scan")
    .setPosition(720, 95)
      .setSize(65, 20)
 ;
          cp5c.addButton("process")
    .setPosition(700, 65)
      .setSize(65, 20)
 ;
/*         cp5c.addButton("calc_abs")
    .setPosition(780, 95)
      .setSize(65, 20)
 ;*/
   cp5c.addButton("bkgnd_subt")
    .setPosition(800, 95)
      .setSize(65, 20)
 ;
    cp5c.addButton("display")
    .setPosition(700, 215)
      .setSize(65, 20)
 ;

     cp5c.addButton("smooth")
    .setPosition(720, 125)
      .setSize(65, 20)
 ;
 yAvg = cp5c.addTextfield("yAvg")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(800, 125)
            .setSize(30, 20)
              .setText("17");
 
    cp5trim.addButton("trim")
    .setPosition(720, 155)
      .setSize(65, 20)
 ;
 
 slider0 = cp5c.addSlider("slider0")
    .setPosition(190, 465)
      .setSize(460, 10)
      .setRange(0,1)
 //     .setNumberOfTickMarks(20)
      .setValue(0.500)
      
      ;
       
         
}

void disp(){
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
     calculating = true;
     viewVal = 1;
     int av = int(cp5c.get(Textfield.class, "yAvg").getText());
     println("averaging "+av+" points");
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
 //    displayCharts();  // cut 9/9/18
   }
   
void trim(){  // advance trimVal
trimVal = (trimVal+1)%3;
println("trimVal: "+ trimVal);
}
  
void trimMeth(){
     // initiallize arrays for holding kinetic data
     viewVal = 1;
     timeData = new float[spectra];
     kData = new float[nAnW][spectra];  // two dimensional array, 
                           //number of analytial wavelengths versus number of spectra

     println("into trim loop");
     firstPixel=0;
     lastPixel=0;
     if(trimVal == 1){
     zoom();
     }
     setZero();
     println("done with setZero");
     
     trimmed = true;
//     trimXMin = zoomXMin;
//     trimXMax = zoomXMax;
if(trimVal == 0){
  xMax[1] = 700;
  xMin[1] = 400;
//  setAxes();
pixelF0 = findPixel(400);
pixelF1 = findPixel(700);
wavelengthF0 = 400;
wavelengthF1 = 700;
}
    for (int u=0; u<spectra; u++){
      for (int y=0; y<nPixels-3; y++){  // changed y min to 1 from 0
       // if(xVal[y]<zoomXMin){
          if(y<pixelF0){
        yCalc[u][y] = 0;
         if (firstPixel ==0){
        firstPixel = y;
         }
        }
        if(y>pixelF1){
          //if(xVal[y]>zoomXMax ){
          yCalc[u][y] = 0;
          if(lastPixel == 0){
        lastPixel = y-1;
      }
      }  // end of max
     } // lend of y loop
//     println("spectra trimmed");

//       shortenFile(u);

//       println("through shorten file loop");
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
    yMin[1] = trimYMin;
    yMax[1] = trimYMax;
    xMin[1] = wavelengthF0;
    xMax[1] = wavelengthF1;
    for (int j = 0; j<spectra; j++){
      println("wavelength at pixel 2500: "+ xVal[3000]);
     println("spectrum: "+j+", Abs(pixel 2500): "+yCalc[j][3000]); 
    }
setupCalcPlots();
   }   //end of void trim
   
   void setZero(){    
   println("in setZero loop, line 151");
 //  println("last X value: "+xVal[nPixels-4]);
   waveSlope = (xVal[nPixels-4]-xVal[0])/(nPixels-4);
   println("slope: "+waveSlope);
  //   println("waveSlope: "+waveSlope);
  //   println("first wavelength: " + xVal[0]);
     // subtract value at 700 nm
     //  println("trimXMax: "+trimXMax);
  //   waveIndex = int((zoomXMax-xVal[0])/waveSlope);  // changed
  //        waveIndex = int((xMax[1] -xVal[0])/waveSlope);  // changed
            // waveIndex = int((wavelengthF1 -xVal[0])/waveSlope);  // changed
            if(trimVal == 1){
            waveIndex = pixelF1;
            }
            else{
              waveIndex = findPixel(700);
            }
            println("pixel: "+waveIndex);
          println("largest x value: "+xVal[nPixels-4]);
  //        println("xMax[1]: " +xMax[1]+ ", xVal[0]: "+xVal[0]);
 //    println("wave index: "+waveIndex);
     for(int p=0; p< spectra; p++){           // loop p
      if(p!=bkground_scan && p != ref_scan){
        Const = yCalc[p][waveIndex];
        println("value for spectrum "+p+": "+Const);
       for(int w=0; w<nPixels-4; w++){       // loop w
        yCalc[p][w] = yCalc[p][w]-Const; 
       }
      }
     }
     
   }
   
   void shortenFile(int f){
     for (int g = 0; g< lastPixel-firstPixel-1; g++){
       yCalc[f][g]=yCalc[f][g+firstPixel];
     }
 //    println("in shorten file loop, line 170");
     for (int h = lastPixel - firstPixel-1; h<nPixels-3; h++){
      yCalc[f][h]=0; 
     }
   }
void display(){
  int views;
  calculating = true;   // added 9/9/18
//  dataLoad = true; // run charts setup once
  if(kinAnal == true){  // if kinetic data available
    views = 3;
  }else {
    views = 2;
  }
viewVal = (viewVal+1)%views; // 0: raw data, 1: calc data, 2: kinetic data

   if(viewVal ==0){
     setAxes();
   }
//displayCharts();  // cut 9/9/18
println("view value: "+viewVal);
}

void kinetics(){
  println("kinetic button pressed");
  calculating = true;
/*  if(viewVal == 1){
    kinAnal = true;
  }*/
//  if(viewVal == 1){
  viewVal = 2;
  analyze = true;
  kineticAnal(4);
  setupKineticPlots();
  kinAnal = true;
 // setAxes();  // try this?
//  display();
//   } else {}
  Fit();
}

void sel_bkgnd_scan(){
bkground_scan = selVal;
println("background scan number: "+bkground_scan);
}
void process(){
  if(selVal == 999){
    refFlag = true;
    
  } else {
ref_scan = selVal;
cHeader[selVal] = "ref scan";
calc_abs();
smooth();
if(trimVal!=2){
trimMeth();
}
//println("ref scan number: "+ref_scan);
  refFlag = false;
}
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
  disp();
}

void calc_abs(){  
  calculating = true; // new 9/18
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
       if(yCalc[q][t] < 0.001){yCalc[q][t] = 0.001;}
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
  disp();
 // println("displayed");
//  println("wavelengths, y values");
//  print(xVal.length+", ");
/*  for (int y = 0; y<spectra; y++){
  print(yCalc[y].length+", ");  // gives the correct number of values
  }
  println("");  */
 // displayCharts();  // cut 9/9/18
}

void slider0(float fraction){
  fract = fraction;
//  find cursor wavelength
// cursorWavelength = fract*(zoomXMax -zoomXMin) +zoomXMin;
    cursorWavelength = fract*(xMax[1] -xMin[1]) +xMin[1];
  cursorGPixel = int(fract*465) + 190;
 cursorPixel = findPixel(cursorWavelength);
/*  boolean pixPick = false;
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
  }*/
  if(xVal.length>2){
  println("fraction: "+ fract+", cursor: "+xVal[cursorPixel]); //cursorWavelength);
  }
  if(cursorShow == true){
   //cursorView(); 
  }
}
