
//  SpectralAnalysisThorKinetics4 in laptop1
//  uses grafica to make plots
//  
//
//  User interface Spectral analysis
//  need to work on modeling data.
// working on saving file-Feb18, 2018

///// imports for graphica ////////
import grafica.GPlot;
import java.awt.*;
import java.awt.Toolkit;
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.DisplayMode;
import grafica.*;

//////// older imports ///////////
import org.gicentre.utils.stat.*;    // For chart classes.
import controlP5.*;
import processing.serial.*;
import java.io.*;                        // this is needed for BufferedWriter
import java.util.*;


/////// new stuff, Sept 2018 ////////////
boolean refFlag = false;  // has reference been selected
boolean dataLoad = false; // has data been loaded?
boolean[] gotLims = {false, false, false};
int trimVal = 0;
String[] trimText = {"400 - 700 nm","box", "none"};
boolean kinAnal;  // has kinetic analysis been conducted
float[] xMax = {750,750,10};
float[] xMin = {350,350,0};
float[] yMax = {20000,1.5,1.5};
float[] yMin = {0,0,0};
float[] limitMemory = {0,0,0,0,0};  // xMin, xMax, yMin, yMax, viewVal when zoomed
int[] pointSz = {2,2,6};
/////  global variables for kinetic analysis //////////
float halfT = 0;   // half life
float[] Azero = new float[5];    // calculated A at time zero
float[] Afinal = new float[5];   // calculated A at final time
float RSq = 0;       // sum of squares of residual

//// graphica stuff //////
public GPlot plot1, plot;
GPointsArray data = new GPointsArray(4000);
       // Arraylists of GPointsArrays for raw, processed and kinetic data
ArrayList<GPointsArray> RawSpecList = new ArrayList<GPointsArray>();
ArrayList<GPointsArray> ProcessedSpecList = new ArrayList<GPointsArray>();
ArrayList<GPointsArray> KineticList = new ArrayList<GPointsArray>();
ArrayList<GPointsArray> TrendList = new ArrayList<GPointsArray>();
ArrayList<GPlot> RawPlots = new ArrayList<GPlot>();
ArrayList<GPlot> ProcessedPlots = new ArrayList<GPlot>();
ArrayList<GPlot> KineticPlots = new ArrayList<GPlot>();
ArrayList<GPlot> TrendPlots = new ArrayList<GPlot>();
 boolean reading = false;
 boolean calculating = false;
 boolean dataRefined = false;
 boolean lsPlots = false;  // true when plotting least squares lines
 float[][] kinAcalc = new float[5][20];   // 5 wavelengths, 20 spectra max

//////// classes ///////////
ControlP5 cp5, cp5b, cp5c, cp5d, cp5trim, cp5kinetic;
XYChart[] lineChart = new XYChart[20];
//XYChart[] fitChart = new XYChart[2];
//Button loadFile, saveFile, runButton, setText, set_Time;
Slider slider0;
Textfield nm_0, nm_1, nm_2, nm_3, nm_4, add_Text, time, yAvg;
String file2; // save file path
String[] file1 = new String[0];  // array to put data to be saved
String calcHeaders = "wavelength";
String[] viewTxt = {"raw data","abs","kinetics"};
String[] cHeader = new String[20];  // headers for calculated spectra
float[][] yDisplay; 
boolean analyze = false;
PFont font18, font16, font14, font12;

int viewVal = 0;  // 0-raw, 1 is processed data, 2 is kinetic data
int nPixels;   // number of pixels per spectrum
int bkground_scan = 999; // spectrum number for background subtraction 
int ref_scan = 999;

int[] red = {  255, 0, 0, 85, 0, 170, 0, 170, 85, 85}; //color parameters for data
int[] green = {  0, 0, 255, 0, 85, 85, 170, 0, 170, 85};
int[] blue = {  0, 255, 0, 170, 170, 0, 85, 85, 0, 85};

ArrayList xDataL = new ArrayList();
ArrayList yDataL = new ArrayList();
//float[] xRecover = new float[0];  
float[][] yCalc = new float[20][0];
float[] xVal = new float[0];  
float[][] yVal = new float[20][0];

float[] wavelengths = new float[20];  // wavelengths for twenty kinetic plots
int[] pixelData = new int[20];        // which pixel goes with specific wavelengths
float[] timeData;  // = new float[10];         // times for twenty spectra
float[][] kData; // = new float[4][10];  // twenty spectra, twenty time points
float[][] kModel; // array of floats to model kinetic data
int nAnW = 4;                         // number of analytical wavelengths
String[] sFileName = new String[20];
int runCount = 0;  // experiment count
String[] headers;
int spectra = 0;  // number of spectra

boolean[] showChart = new boolean[20];
//boolean[] hideChart = new boolean[20];
//boolean[] selectBox = new boolean[20];
//boolean zoomed = false;
float chartXMax, chartXMin, chartYMax,chartYMin;
float zoomXMax,zoomXMin,zoomYMax, zoomYMin;
float trimXMin, trimYMin, trimYMax,trimXMax;  // cut these?
boolean trimmed = false;

boolean firstChart = true;
int c0= 00;  // x position for chart
int c1= 700;   // x size of chart
int c2 = 600;
int c3 = 400;

int[] xZoom = {190, 650};  // c0,c0+c1,200,400};
int[] yZoom = {480, 110};   //c2,c2-c3,100,400};
 int[] xZoomLim = {190,640,200,650};  //270,670,270,670};
 int[] yZoomLim = {480,110,480,110};
 int[] xBox = {190,650};
 int[] yBox = {480,110};
 float[] fBox = {1.0,1.0,1.0,1.0};
 boolean zoomed = false;
 float[] oldChartLim = {0,1,0,1};
 

boolean[] selectBox = {false,false,false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,false,false};
//int chartMode;  // 0 is ramp, 1 is cv, 2 is diff pulse, 3 is cyclic pulse, 4 is CA
String   xChartLabel[] = {"wavelength (nm)","time (ms)","time (s)"};
boolean secondsChart = false;  //when true, time measured in seconds
String yChartLabel[] = {"Amplitude","Absorbance"};
int bkgnd = #AF844E;
  int deltaY = 20;
  int yOff = 100;
  int xOff = 50;
int sel = #E59615;
int selVal = 999;     // which spectrum to process?
String selTxt = "None selected";
//float[] linearX = {0,0,0};      // positions for model
//float[] linearY = {0,0,0};
boolean selected =false;
boolean mouse0 = false;  // is box zero being dragged?
//boolean[] peakSel = new boolean[20];
boolean errorFlag;
String errorTxt;
int[] points = {0,0};  // indices for baseline and peak points
float fract;  // output from slider
    float slope;   // slope and intercept for baseline
    float interc;
    boolean displayFlag = false;
/*  float x_base;   // baseline x and y values
  float y_base;
  float x_peak;   // peak x and y values
  float y_peak;
  float x_end; 
    float y_end;     // y values for baseline at two ends of chart
    float y_zero;
    float iPeak;
    boolean currentTxt = false;
    float iCalcAtPeak;   // calculated value of baseline at peak voltage
 */   
    float waveSlope;
    int waveIndex;
    float Const;
    boolean bkgndCor=false;  // has background been corrected
    int firstPixel=0;  // used to shorten processed spectra files
     int lastPixel=0;
boolean cursorShow = false;
float cursorWavelength;
int cursorPixel=1;
int cursorGPixel;
 int pixelF0;   // used in zooom and trim, assigned in mouse tab
 int pixelF1;
 float wavelengthF0;
 float wavelengthF1;

    float tHalf;  // half life
        String[] xLabel = {"Wavelength (nm)","Wavelength (nm)","time (s)"};
    String[] yLabel = {"Intensity","Absorbance","Absorbance"};
    String[] title ={"Raw data","Absorbance data","Kinetic data"};
    boolean thinking = false;
      boolean firstProcess = true;  // data has not been processed yet
      
void setup(){
    size(900, 550); 
    font18 = createFont("ArialMT-48.vlw",18);
    font16 = createFont("ArialMT-48.vlw",16);
  setupZoom();    // in mouse tab
//    chartsSetup();
    setupButtons();  // button tab
    setupProcess();  // process tab
    textBoxSetup();  // textBox tab
/*    for(int o = 0; o<20; o++){
     peakSel[o] = false; 
    }*/
    initiateBckgnd();  // grafica tab
    setAxes();
}

void draw(){
  background(bkgnd);
  //////////  new grafica stuff ////////////

  plot1.beginDraw();
  plot1.drawBackground();
  plot1.drawBox();
  plot1.drawXAxis();
  plot1.drawYAxis();
  plot1.drawTitle();
  plot1.endDraw();
  
  if(viewVal == 0){
   text(trimText[trimVal],800,170); 
  }
  if(refFlag == true){  // display error text
   text("Select background scan to calculate Abs", 220,40);  
}
  ////////  display kinetic results (from 3A) ////////
  
    if(dataRefined == true && viewVal == 2){
    int valA = int(693/halfT);

     String StB = str(float(valA)/1000);
 //        println("halfT: "+halfT+", StB: "+StB);
//   String kineticText = "k obs: "+str(0.693/halfT) +" s-1";
   String kineticText = "k observed: "+StB +" s";
  //    String kineticText = "k observed: "+nf(0.693/halfT,4) +" s";
   //   String kineticText = "k observed: "+StB +" s";
   fill(0);
  text(kineticText, 740, 290);
  }
  //////////// end new grafica stuff ///////
  textFont(font16);
    text(selTxt,140,80);
  text(viewTxt[viewVal],820,230);
  if(viewVal != 0){   // show fit button
    cp5kinetic.show();
  }else{
    cp5kinetic.hide();
  }
  
  ///////////////////////// plotting ////////////////////////////
  if(spectra!=0){
      while (reading == true){  // || calculating == true){
      println("reading");
    }
    if (viewVal == 0 && dataLoad == true){
        setupRawPlots();
        dataLoad = false;
        
/*      } else if (viewVal == 0){
      setAxes();
      //}*/
       } else if (viewVal == 1 && calculating == true){
         setupCalcPlots();
         calculating = false;
       } else {
         int nPlots;
         if(viewVal == 2){
           nPlots = nAnW;
       //    println("plotting kinetic data");
         } else {
           nPlots = spectra;
         }
         if(thinking == false){
    for (int i = 0; i< nPlots; i++){        // plot the number required 
        plotSpecData(i); 
    }
         }
    if(viewVal == 2){

        for (int i = 0; i< nPlots; i++){        
        plotSpecData(i); 
        
    }

        //  chartsSetup();                   // setup charts
       }
    }  
//  displayCharts();                 // display charts
  if(viewVal !=2){  // hide cursor button for kinetics
    cp5d.show();
  //  cp5kinetic.show();
  } else {
    cp5d.hide();
  //  cp5kinetic.hide();
  }
if(trimmed == false){
  cp5trim.show();
} else {
  cp5trim.hide();
}
//  Cursor stuff
 if(cursorShow == true && viewVal != 2){
   slider0.show();
  fill(0);
  stroke(0);
   line(cursorGPixel,110,cursorGPixel,480);
//   text(int(cursorWavelength), cursorGPixel+50,300);
text("Cursor: ",200,140);
text(int(cursorWavelength)+" nm", 200,160);
 }else{
   slider0.hide();
 }  // end of cursor stuff
 // spectra labels
  for(int u = 0; u<spectra; u++){
    if(selectBox[u] == true){  // is spectrum selected?
      fill(sel);
    } else{
      fill(0);
    }
        String text1;
    if(viewVal== 0){
      text1 = sFileName[u];
    }else{
      text1 = cHeader[u];
    }
  text(text1,xOff,u*deltaY+yOff);
    }  // end of spectra labels
    // zoom box
    if(zoomed == false){
    stroke(0);
   // xZoom[0] = 0;
  line(xZoom[0],yZoom[0],xZoom[0],yZoom[1]);
  line(xZoom[0],yZoom[0],xZoom[1],yZoom[0]);
  line(xZoom[1],yZoom[1],xZoom[1],yZoom[0]);
  line(xZoom[1],yZoom[1],xZoom[0],yZoom[1]);
  
  noFill();
  rectMode(CENTER);
  rect(xZoom[0],yZoom[0],10,-10);
  fill(229,120,21,100);              // semi-transparent yellow box
    rect(xZoom[1],yZoom[1],-10,10);
  fill(255);
  rectMode(CORNER);
  stroke(255);
  }
  //////// end of zoom box
  }  // end of if spectra !=0 loop
  else{slider0.hide();}

  if(errorFlag == true){
      text(errorTxt,800,110);
    }
 
}

void plotSpecData(int n){

  if(viewVal == 0){
     plot = RawPlots.get(n);
     drawPlot(n, true, true);
// int p = RawPlots.size();
  } else if (viewVal == 1){
     plot = ProcessedPlots.get(n);
     drawPlot(n, true, true);
  } else if (viewVal == 2){

    plot = KineticPlots.get(n);
    drawPlot(n, false, true);
    if(lsPlots == true){
    plot = TrendPlots.get(n);
    drawPlot(n, true, false);
    }
  } 
}
  void drawPlot(int n, boolean l, boolean p){
//  plot.setPos(120,70);   // different than what Ben wrote
//  plot.setDim(460, 370); 
    plot.beginDraw();


  
  if(l == true){
    plot.drawLines();
  }
  plot.setPointSize(pointSz[viewVal]);
  if(p == true){
  plot.setPointColor(color(red[n],green[n],blue[n]));
  plot.drawPoints();
  }
  plot.endDraw();
//  println("end of plot "+n);
  
}
  
  
