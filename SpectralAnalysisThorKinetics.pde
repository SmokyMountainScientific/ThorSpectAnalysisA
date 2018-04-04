//  SpectralAnalysis2
//  User interface Spectral analysis
//  having issues with laptop.
// working on saving file-Feb18, 2018

import org.gicentre.utils.stat.*;    // For chart classes.
import controlP5.*;
import processing.serial.*;
import java.io.*;                        // this is needed for BufferedWriter
import java.util.*;


//////// classes ///////////
ControlP5 cp5, cp5b, cp5c, cp5d;
XYChart[] lineChart = new XYChart[20];
XYChart[] fitChart = new XYChart[2];
Button loadFile, saveFile, runButton, setText, set_Time;
Slider slider0;
Textfield nm_0, nm_1, nm_2, nm_3, nm_4, add_Text, time, yAvg;
String file2; // save file path
String[] file1 = new String[0];  // array to put data to be saved
String calcHeaders = "wavelength";
String[] cHeader = new String[20];  // headers for calculated spectra

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
float[] timeData = new float[20];         // times for twenty spectra
float[] wavelengths = new float[20];  // wavelengths for twenty kinetic plots
int[] pixelData = new int[20];        // which pixel goes with specific wavelengths
float[][] kData = new float[20][20];  // twenty spectra, twenty time points
String[] sFileName = new String[20];
int runCount = 0;  // experiment count
String[] headers;
int spectra = 0;  // number of spectra

boolean[] showChart = new boolean[20];
boolean[] hideChart = new boolean[20];
//boolean[] selectBox = new boolean[20];
//boolean zoomed = false;
float chartXMax;
float chartXMin;
float chartYMax;
float chartYMin;
float zoomXMax;
float zoomXMin;
float zoomYMax;
float zoomYMin;
float trimXMin;
float trimXMax;
boolean trimmed = false;

boolean firstChart = true;
int c0= 265;  // x position for chart
int c1= 400;   // x size of chart
int c2 = 466;
int c3 = 382;

int[] xZoom = {c0,c0+c1,200,400};
int[] yZoom = {c2,c2-c3,100,400};
 int[] xZoomLim = {270,670,270,670};
 int[] yZoomLim = {473,75,473,75};
 int[] xBox = {270,670};
 int[] yBox = {473,75};
 float[] fBox = {1.0,1.0,1.0,1.0};
 boolean zoomed = false;
 float[] oldChartLim = {0,1,0,1};
 float trimYMin;
 float trimYMax;

boolean[] selectBox = {false,false,false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,false,false};
int chartMode;  // 0 is ramp, 1 is cv, 2 is diff pulse, 3 is cyclic pulse, 4 is CA
String xChartLabel;
String yChartLabel;
int bkgnd = #AF844E;
  int deltaY = 20;
  int yOff = 100;
  int xOff = 50;
int sel = #E59615;
int selVal = 0;     // which voltammagram to process
String selTxt = "None selected";
float[] linearX = {0,0,0};      // positions for model
float[] linearY = {0,0,0};
boolean selected =false;
boolean mouse0 = false;  // is box zero being dragged?
boolean[] peakSel = new boolean[20];
boolean errorFlag;
String errorTxt;
int[] points = {0,0};  // indices for baseline and peak points
float fract;  // output from slider
    float slope;   // slope and intercept for baseline
    float interc;
    boolean displayFlag = false;
  float x_base;   // baseline x and y values
  float y_base;
  float x_peak;   // peak x and y values
  float y_peak;
  float x_end; 
    float y_end;     // y values for baseline at two ends of chart
    float y_zero;
    float iPeak;
    boolean currentTxt = false;
    float iCalcAtPeak;   // calculated value of baseline at peak voltage
    
    float waveSlope;
    int waveIndex;
    float Const;
    boolean bkgndCor=false;  // has background been corrected
    int firstPixel=0;  // used to shorten processed spectra files
     int lastPixel=0;
boolean cursorShow = false;
//boolean sliderShow = false;
float cursorWavelength;
int cursorPixel=1;
int cursorGPixel;
    
void setup(){
    size(900, 550); 
    font18 = createFont("ArialMT-48.vlw",18);
    font16 = createFont("ArialMT-48.vlw",16);
  setupZoom();    // in mouse tab
//    chartsSetup();
    setupButtons();
    setupProcess();
    textBoxSetup();
    for(int o = 0; o<20; o++){
     peakSel[o] = false; 
    }
    
    
}

void draw(){
  background(bkgnd);
  textFont(font16);
    text(selTxt,140,80);
  if(spectra!=0){
  chartsSetup();
  displayCharts();
//  slider0.hide();
 if(cursorShow == true){
   slider0.show();
  fill(0);
  stroke(0);
   line(cursorGPixel,100,cursorGPixel,450);
   text(int(cursorWavelength), cursorGPixel+50,300);
 }else{
   slider0.hide();
 }
  for(int u = 0; u<spectra; u++){
    if(selectBox[u] == true){
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
  
  }
    if(zoomed == false){
    stroke(0);
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
  }
  if(errorFlag == true){
      text(errorTxt,800,110);
    }
    if(currentTxt == true){
     text("Peak current: ",800,160);
     text(iPeak+" microAmps",800,185);
    }
}
  
  