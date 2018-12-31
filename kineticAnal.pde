// kinetic analysis tab
void Fit(){
  println("fit button pushed");
  halfT = estHalfLife();
  for(int y = 0; y<nAnW; y++){  // find initial and final absorbances at each wavelength
         // values defined in 
      print("wavelength "+y);
//  Azero[y] = kData[y][0];
  print(", A zero: "+Azero[y]);
//  Afinal[y] = kData[y][spectra-1];
  println(", A final: "+Afinal[y]);
}
  println("estimated t1/2: "+halfT);
   for(int h = 0; h<nAnW; h++){
     println("refining Azero and Afinal for wavelength "+h);
     println("initial values: "+Azero[h]+", "+Afinal[h]);
     for (int p = 0; p<3; p++){   // three refinement cycles
  refineAf(h);
  dataRefined = true;
     }
     println("final values: "+Azero[h]+", "+Afinal[h]);
   }
   lsPlots = true; // data is available
   setupLSPlots();
}

void refineAf(int h){
  boolean refined = false;
  int param = 0;  // refining Afinal is zero, Azero is one, t1/2 is two
  boolean decrement = true;
//  println("calculate sum of squares of residuals");
 RSq = calcLS();
// println("intial R squared: "+RSq);
// float aVar;  // local value for variable A

 while(refined == false){
   // refine final A values
    shiftVal(h, param, decrement);    // increment or decrement parameter value
   float Rtemp = calcLS();            // calculate Rsq temp value
 if(Rtemp > RSq){              // going the wrong way
   decrement =! decrement;          // reverse direction
   shiftVal(h, param, decrement);    // increment param value
   if(decrement == true){            // if it has changed direction before
     param++;                        // refine the next parameter
     if(param == 3){                 // if three parameters already refined
       refined = true;               // exit loop, you are done.
     }
    }
  }  // end of temp loop
    else{
      RSq = Rtemp;
    }
 }  // end of while refined is false loop  
}  // end of refine Af

void shiftVal(int n, int param, boolean dir){
  float delta;
  if (dir == true){
    delta = -0.001;
  } else {
    delta = .001;
  }
  switch(param){
  case(0):
  Afinal[n] += delta;
  break;
  case(1):
  Azero[n] += delta;
  break;
  case(2):
  halfT += delta;
  break;
  } 
}  // end of shiftVal

float calcLS(){
 float aRSq = 0;
  for(int a = 0; a<spectra-1; a++){
  for(int b = 0; b<nAnW; b++){
//    print("time: "+timeData[a]);
   kinAcalc[b][a] = Azero[b]*exp(-0.693/halfT*timeData[a])+Afinal[b];
 //  println(", calculated A: "+Acalc);
   float resid = kinAcalc[b][a]-kData[b][a];
//   println("residual: "+resid);
   aRSq += sq(resid);
//     println("through loop "+b);
  }

  }
//  println("calculated RSq: "+aRSq);
  return aRSq;
}

void kineticAnal(int nWav){    // nWav is the number of wavelengths
//nWav = 4;  // get this later
//timeData = new float[10];  //spectra];
//kData = new float[4][10];  //nWav][spectra]; //[nWav];
if(analyze == true){

if(nWav ==0){
  println("enter wavelengths");
} else{
  String[] boxes = {"nm_0","nm_1","nm_2","nm_3","nm_4","nm_5","nm_6","nm_7","nm_8","nm_9","nm_10"};
  // convert time data to float

  int finalTime = int(headers[spectra-1]);
  if(finalTime > 5000){
    secondsChart = true;
    println("chart x in seconds");
  }
    print("time: ");
    yMax[2] = 0;
    yMin[2] = 0;
  for(int j = 0; j<spectra; j++){
    timeData[j] = float(headers[j+1]);
    if(secondsChart == true){timeData[j] /=1000;}
    print(timeData[j]+", Abs: ");
   // get analytical wavelengths
  for(int p = 0; p<nWav; p++){
  // find pixel numbers
  
  float value = float(cp5kinetic.get(Textfield.class, boxes[p]).getText());
  
  int Pixel = findPixel(value);
  // set pixel data to kData
  kData[p][j] = yCalc[j][Pixel];
//    Azero[y] = kData[y][0];
  print(kData[p][j]+", ");
  yMax[2] = max(yMax[2],kData[p][j]);
  yMin[2] = min(yMin[2],kData[p][j]);
  }   
   println(""); 
  }
  // set x Data to time values
//chartXMax = timeData[spectra-1];
xMax[2] = timeData[spectra-2];
xMin[2] = timeData[0];
println("chart max = "+chartXMax);  // got past here
      for(int p = 0; p<nWav; p++){
        Azero[p] = kData[p][0];
        Afinal[p] = kData[p][spectra-1];
        print("data for wavelength "+p+", line , A zero: "+Azero[p]);
        println("line 103, A final: "+Afinal[p]);
    }
}
analyze = false;
}
//void setKData(){
//  float yMax = 0;
//  float yMin = 0;
//  chartYMax = 0;
/*for(int r = 0; r<spectra; r++){
  for (int q = 0; q<nAnW; q++){    // for each wavelength
    //lineChart[q].setData(timeData,kData[q]);
    yMin[2] = min(kData[r][q],yMin[2]);
    yMax[2] = max(kData[r][q], yMax[2]);
//    chartYMax = max(chartYMax,yMax);
//    chartYMin = min(chartYMin,yMin);
println("limits pass: "+r+", "yMin[2]
  }
}*/
//yMin[2] = yMin[1];
//yMax[2] = yMax[1];
      println("kinetic data set displayed, line 61 of anal tab");
/*  for (int p = 0; p<nAnW; p++){
        setLimits(lineChart[p]);
    lineChart[p].draw(c0, c2-c3, c1, c3);
  }
  axes();*/
//}
}

int findPixel(float wvL){   // copied from page 6, process tab
//println("seeking pixel for wavelength: "+wvL);
 boolean pixPick = false;
 int j = 0;
 while (pixPick == false && j<nPixels){
   if(wvL > xVal[j]){
    j++ ;
   }else{ pixPick = true;}
 }
  return j;
}

// least squares analysis method
float estHalfLife(){   // estimates t1/2
int nWav = 4;
float tHalfEst = 0;
float tHalfMax = 0;
for(int r=0; r<nWav; r++){
float halfAbs = 0.5*(kData[r][0]+kData[r][spectra-1]); // half way between initial and final abs
// determine first time past t1/2
boolean t = false;
int j = 0;
while (t == false){
  j++;
   if(kData[r][j]< halfAbs){
   t = true;
   tHalfMax = timeData[j];
 }
  if(j == spectra-1){
   t = true; 
  }
} // end of while t is false
tHalfEst += tHalfMax;

}
tHalfEst /= nWav;
return tHalfEst;
}

/*
boolean kCheck = false;
float kobs = 0;
float kInc = 100;  // increment for kobs
while(kCheck == false){ 
for(int t = 0; t<spectra-1; t++){ 
AbsCalc = Abs0(exp(-kobs*timeData[t]);
rSq += square(Abs-AbsCalc);
}
}
*/
