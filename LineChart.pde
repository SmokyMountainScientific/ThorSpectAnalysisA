/* LineChart tab, SpectralAnalysis2 GUI sketch
 chartsSetup() -- initiallizes charts
 --called in setup loop
 displayCharts() -- sets up and displays charts
 -- called in draw loop
 setLimits() -- sets limits on x and y displays
 */

void chartsSetup() {
  //println("spectra: "+spectra);
  for (int y = 0; y<spectra; y++) {
    lineChart[y] = new XYChart(this);
    int p = y%10;
    lineChart[y].setPointColour(color(red[p], green[p], blue[p]));
    lineChart[y].setPointSize(1);
    lineChart[y].setLineWidth(2);
  }
  int[] lWidth = {1, 4};
  int[] lColor = {0, #E59615};
  for (int y = 0; y<2; y++) {
    fitChart[y] = new XYChart(this);

    fitChart[y].setPointSize(1);
    fitChart[y].setLineWidth(lWidth[y]);
    fitChart[y].setLineColour(lColor[y]);
  }
}    // end of charts setup


void displayCharts() {
  float xValMin = min(xVal);
  float xValMax = max(xVal);
  chartXMax = xValMax;  
  chartXMin = xValMin;
  chartYMax = 0;
  chartYMin = 0;
  
  float deltaY; 
  firstChartSetup();  // make background box and set up axes labels
  float[][] yDisplay = new float [20][nPixels];  // different for processed and raw data

  if (viewVal == 1) {      // viewVal = 0 for raw data, 1 for processed data
    yDisplay = yCalc;  // display processed data
//    println("display yCalc");
         ///////// do not show background or reference scans for processed data /////
    if (bkground_scan != 999) {  // background not selected
      selectBox[bkground_scan]= false;
    }
    if (ref_scan != 999) {       // reference scan not selected
      selectBox[ref_scan] = false;
    }
  } else {
    yDisplay = yVal; // if viewVal = 0, display raw y data
  }

// set data ///////////////
  for (int q = 0; q<spectra; q++) {
    lineChart[q].setData(xVal, yDisplay[q]);                    // data set for all charts
    if (selectBox[q]== true) {
      float yValMin = min(yDisplay[q]);
      float yValMax = max(yDisplay[q]);
      chartYMax = max(chartYMax, yValMax);  //yVal[q]);
      chartYMin = min(chartYMin, yValMin);  //yVal[q]);  was chartYMax?
    }
/*    if(viewVal == 1){
    chartYMax = 3;
    chartYMin =-0.1;
  }*/
    deltaY = (chartYMax-chartYMin)*0.01;
 //   println("delta Y: "+deltaY);  // why is deltaY so big?
    chartYMax += deltaY;
    chartYMin -= deltaY;
  }
  println("Chart Y Max: "+chartYMax);  // get infinity
/*  if (displayFlag == true) {
    displayLines();
  }*/

  for (int p = 0; p<spectra; p++) {   // determine data limits set graph limits
    if (selectBox[p]== true) {
      setLimits(lineChart[p]);
      /*     if(firstChart == true){
       lineChart[p].showXAxis(true);
       lineChart[p].showYAxis(true);
       lineChart[p].draw(250, 70, 430, 420);
       firstChart = false;
       }else{ */
      //   if(p !=0){
      lineChart[p].draw(c0, c2-c3, c1, c3);  //old values: 270, 80, 400, 400

      //  }else{

      // }
    }
  }  // end of for int p loop
  axes();
}
//}
void setLimits(XYChart thing) {
  if (zoomed == false && trimmed == false) {
    thing.setMaxX(chartXMax);  // chart x and y max and min determined for entire data set
    thing.setMaxY(chartYMax);
    thing.setMinX(chartXMin);
    thing.setMinY(chartYMin);
  } else if (trimmed == true && zoomed == false) {
    thing.setMaxX(trimXMax);
//    thing.setMaxY(trimYMax);
    thing.setMinX(trimXMin);
 //   thing.setMinY(trimYMin);
  } else if (zoomed == true) {
    thing.setMaxX(zoomXMax);
    thing.setMaxY(zoomYMax);
    thing.setMinX(zoomXMin);
    thing.setMinY(zoomYMin);
  }
}


void firstChartSetup() {
  // background
  fill(#EADFC9);               // background color
  int chartPosX = 200;        // position of background rectangle
  int chartPosY = 70;
  int chartSzX = 475;         // size of background rectangle
  int chartSzY = 450;
  translate(chartPosX, chartPosY);
  rect(0, 0, chartSzX, chartSzY);    // chart background 
  fill(0, 0, 0);
  // rectangle for orientation
  translate(-chartPosX, -chartPosY);
  noFill();
  stroke(0);
  rect(c0,c2-2-c3,c1,c3);
  translate(chartPosX, chartPosY);
  // axes labels
  int posX = 20; //220;  // x position for center of y axis label
  int posY = chartSzY/2; //260;  // y position for center of y axis
  translate(posX, posY);
  rotate(3.14159*3/2);
  textAlign(CENTER);
  text("Amplitude", 0, 0);
  rotate(3.14159/2);        // return orientation and location
  translate(-posX, -posY);
  translate(-chartPosX, -chartPosY);  

 
  xChartLabel = "wavelength (nm)";
  posX = 475;
  posY = 515;
  translate(posX, posY);
  textAlign(CENTER);
  text(xChartLabel, 0, 0);
  translate(-posX, -posY);
}
///////////////// end of chart setup //////////////////

void displayLines() {
  //    cursorWavelength = slider0 

  //   float[] xFit = {{chartXMin,xVal[selVal][points[0]],xVal[points[1]], chartXMax},{x_peak, x_peak}};
  // float[][] yFit = {{y_zero, yDisplay[selVal][points[0]],iCalcAtPeak, y_end} ,{iCalcAtPeak, y_peak}};


  /*    for(int j = 0; j<2; j++){
   setLimits(fitChart[j]);
   fitChart[j].setData(xFit[j],yFit[j]);
   fitChart[j].draw(c0, c2-c3, c1, c3);
   }
   */
}

void axes() {
  int chartX0;
  int firstX;   // position of first tick mark
  float chartY0;
  float firstY=0;
  int deltaX;
  float deltaY;
  if (zoomed == false && trimmed == false) {
    deltaX = int(chartXMax - chartXMin);  // total chart width
    deltaY = chartYMax - chartYMin;  // total chart height
    chartX0 = int(chartXMin);
    chartY0 = chartYMin;
  } else if (zoomed == true && trimmed == false) {
    deltaX = int(zoomXMax - zoomXMin);  // total chart width
    deltaY = int(zoomYMax - zoomYMin);  // total chart height
    chartX0 = int(zoomXMin);
    chartY0 = zoomYMin;
  } else {
    deltaX = int(zoomXMax - zoomXMin);  // total chart width
    deltaY = trimYMax - trimYMin;  // total chart height
    chartX0 = int(zoomXMin);
    chartY0 = zoomYMin;
  }
  int ticksX;                           // number of ticks
  int ticksY = 5;
  int diffX = 2;                            // mV between ticks
  float diffY = 4;                           // distance between y ticks
  int[] compX = {1000, 500, 200, 100, 50, 20, 0};
  int[] deX   = {100, 50, 20, 10, 5, 2};
  float[] compY = {100, 50, 20, 10, 5, 2, 1, .5, .1};
  float[] deY = {20, 10, 5, 2, 1, .5, .2, .1};
  /// calculate diffY
  for (int r = 0; r<8; r++) {
    if (deltaY > 100) {
      float p = deltaY/5;
      int u = int(log(p)/2.303);  // calculate base 10 log
      diffY = pow(10,u);                                        
  //    println("deltaY: "+deltaY+" log deltaY: "+u+", diffY: "+diffY);
    }
    if (deltaY >= compY[r+1] && deltaY < compY[r]) {
      diffY = deY[r];
    }
  }
  ///// calculate diffX
  for (int j = 0; j<6; j++) {
    if (deltaX > 1000) {
      diffX = 200;
    }
    if (deltaX > compX[j+1] && deltaX <= compX[j]) {
      diffX = deX[j];  // distance between x axis ticks
    }
  }
  
//  calculate firstX and firstY tick positions
firstX = int(chartX0/diffX)+1;
firstX *= diffX;
//println("first x tick at "+firstX);
//int ifirstY = int(chartY0/diffY)+1;
firstY *=diffY;
//println("first y tick at "+firstY);
  //   println("diffX = "+diffX);
  int xInit = c0;  //285;
  int xTotal = c1;  //400;
  int yTotal = c3; //400;
  int yInit = c2; //-c3;   //490;
  ticksX = deltaX/diffX+1;    // took +1 off here
  ticksY = int(deltaY/diffY)+1;
  for (int p = 0; p<ticksX; p++) {
    int xValue = p*diffX + firstX;  //int(chartX0);  value in nm
    float j = (xValue-chartX0);
    j /= deltaX;
    int xPos = int(j*xTotal) + xInit; //xTotal/ticksX + xInit;  // should this be chartX0?
 //   println("j: "+j+" tick value: "+xValue+ ", position: "+xPos);
    fill(0);
    stroke(0);
    text( xValue, xPos, yInit);
    line(xPos, yInit-30, xPos, yInit-20);
    fill(255);
    stroke(255);
  }
  pushMatrix();
  translate(xInit-40, yInit-50);
  rotate(3*PI/2);
  float yValue =0;
  float yPos=0;
  for (int e = 0; e<ticksY; e++) {
    yValue = e*diffY + firstY;  //chartYMin;
    yPos = yTotal-yInit+30 +((yValue - chartY0)/deltaY*yTotal);
    fill(0);
    stroke(0);
    if(yValue >10){
    text(int(yValue), yPos, 30);
    }else{
      text(yValue, yPos, 30);
    }
    line(yPos, +50, yPos, +40);
    fill(255);
    stroke(255);
  }
//  println("chartY0: "+chartY0+" tick value: "+yValue+ ", position: "+yPos);
  popMatrix();
}
