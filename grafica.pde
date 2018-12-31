void initiateBckgnd(){
  plot1 = new GPlot(this);
  plot1.setPos(120,70);
    plot1.setDim(460,370); 
    
  for(int i = 0; i<20; i++){
  RawSpecList.add(new GPointsArray());
  RawPlots.add(new GPlot(this));
  ProcessedSpecList.add(new GPointsArray()); 
  ProcessedPlots.add(new GPlot(this));
  GPlot plot2 = RawPlots.get(i);
        plot2.setPos(120,70);
        plot2.setDim(460, 370); 
  GPlot plot3 = ProcessedPlots.get(i);
        plot3.setPos(120,70);
        plot3.setDim(460, 370); 
  
  }
  
}

//void setupBackground(){
void setAxes(){
plot1.getXAxis().getAxisLabel().setText(xLabel[viewVal]);
plot1.getYAxis().getAxisLabel().setText(yLabel[viewVal]);
plot1.getTitle().setText(title[viewVal]);
plot1.setXLim(xMin[viewVal],xMax[viewVal]);
plot1.setYLim(yMin[viewVal],yMax[viewVal]);
}

void setupRawPlots(){
//  thinking = true;  // stops plots
  setAxes();
 
      for(int t = 0; t< spectra; t++){
        // set up data array
//        RawSpecList.add(new GPointsArray());
        GPointsArray array = RawSpecList.get(t);
        // put wavelength, intensity data into array (look for definitions in buttons tab)
        for (int p = 0; p<nPixels-3; p++){         // for each pixel
          array.add(xVal[p],yVal[t][p]);   // for raw y values
        }
        
        // add plots to Plots array list
//        RawPlots.add(new GPlot(this));
        GPlot plot2 = RawPlots.get(t);
        plot2.setPos(120,70);
        plot2.setXLim(xMin[viewVal],xMax[viewVal]);
        plot2.setYLim(yMin[viewVal],yMax[viewVal]);
        plot2.setPoints(array);
      }
      int u = RawPlots.size();
      println("grafica tab, raw plots: "+u);   // adds another set of plots
      thinking = false;
    }
    
void setupCalcPlots(){
//  yMax[1] = 0;
//  yMin[1] = 0;
  setAxes();

    if(firstProcess == true){  // if this is first call, create plots and arrays for spectra
  for (int k = 0; k<spectra; k++){
//      ProcessedSpecList.add(new GPointsArray()); 
  //    ProcessedPlots.add(new GPlot(this));
//      println("plot added: "+k);
      putData(k, false);
         }  // end of k loop
         firstProcess = false;
    }     // end of if size is zero loop 
    else{           // empty the gPointsArray
      for (int j = 0; j<spectra; j++){        // set up data array
        putData(j, true);
      }
    }  // end of else loop
     
        // add plots to Plots array list
//        ProcessedPlots.add(new GPlot(this));
/*        GPlot plot = ProcessedPlots.get(j);
        plot.setXLim(xMin[viewVal],xMax[viewVal]);
        plot.setYLim(yMin[viewVal],yMax[viewVal]);
        plot.setPoints(array);  */
            println(" data added");
          }
      
void setupKineticPlots(){
  setAxes();
  println("setting up kinetic plots");
      if(KineticList.size() == 0){  // if this is first call, create plots and arrays for spectra
  for (int k = 0; k<nAnW; k++){     // for each analytical wavelength
      KineticList.add(new GPointsArray()); 
      KineticPlots.add(new GPlot(this));
      GPlot plot4 = KineticPlots.get(k);
        plot4.setPos(120,70);
        plot4.setDim(460, 370);
      println("plot added: "+k);
      /// add data ///////////////
      putKData(k, false);
         }  // end of k loop
    }     // end of if size is zero loop 
    else {  // remove
    for (int k = 0; k<nAnW; k++){
      putKData(k,true);
    }
    }  // end of else loop
}

void setupLSPlots(){
        if(TrendList.size() == 0){  // if this is first call, create plots and arrays for spectra
  for (int k = 0; k<nAnW; k++){     // for each analytical wavelength
     TrendList.add(new GPointsArray()); 
      TrendPlots.add(new GPlot(this));
      GPlot plot5 = TrendPlots.get(k);
        plot5.setPos(120,70);
        plot5.setDim(460, 370);
      println("plot added: "+k);
      /// add data ///////////////
      putLSData(k, false);
         }  // end of k loop
    }     // end of if size is zero loop 
}


void putData(int j, boolean cut){
  println("in putData: "+j);
      GPointsArray array = ProcessedSpecList.get(j);
      if(cut == true){
       
           for (int p = nPixels-4; p>=0; p--){         // for each pixel
           array.remove(p);  // for caluclated y values
           }
      }
           for (int p = 0; p<nPixels-3; p++){         // for each pixel
           array.add(xVal[p],yCalc[j][p]);  // for caluclated y values
        } 
                GPlot plot = ProcessedPlots.get(j);
            /////// calculate maximum y value for plot /////////
//        yMax[1] = max(yMax[1],max(yCalc[j]));
 //       yMin[1] = min(yMin[1],min(yCalc[j]));
        plot.setPos(120,70);
                
        plot.setXLim(xMin[viewVal],xMax[viewVal]);
        plot.setYLim(yMin[viewVal],yMax[viewVal]);
        plot.setPoints(array);
 }
 
 void putKData(int j, boolean cut){
    GPointsArray array = KineticList.get(j);
      if(cut == true){
           for (int p = nAnW-1; p>=0; p--){         // for each pixel
           array.remove(p);  // for caluclated y values
           }
      }
      for (int p = 0; p<spectra-1; p++){         // for each time point
           array.add(timeData[p],kData[j][p]);  // add time, Absorbance
        } 
                GPlot plot = KineticPlots.get(j);
                plot.setPos(120,70);
 //       plot.setXLim(xMin[viewVal],xMax[viewVal]);  //  set time limits
   //     plot.setYLim(yMin[viewVal],yMax[viewVal]);
   println("setting kinetic plot limits");
        plot.setXLim(xMin[2],xMax[2]);  //  set time limits
        plot.setYLim(yMin[2],yMax[2]);
        plot.setPoints(array);
   
 }
 
 void putLSData(int j, boolean cut){
    GPointsArray array = TrendList.get(j);
      if(cut == true){
           for (int p = nAnW-1; p>=0; p--){         // for each pixel
           array.remove(p);  // for caluclated y values
           }
      }
      for (int p = 0; p<spectra-1; p++){         // for each time point
           array.add(timeData[p],kinAcalc[j][p]);  // add time, Absorbance
        } 
                GPlot plot = TrendPlots.get(j);
        plot.setPos(120,70);
        plot.setXLim(xMin[viewVal],xMax[viewVal]);  //  set time limits
        plot.setYLim(yMin[viewVal],yMax[viewVal]);
        plot.setPoints(array);
   
 }
