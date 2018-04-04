void textBoxSetup(){
  int wid = 50;
  int hei = 20;
  int x0 = 770;
  int y0 = 310;
  int delta = 30;
  cp5d = new ControlP5(this);
    nm_0 = cp5d.addTextfield("nm_0")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(x0, y0)
            .setSize(wid, hei)
              .setText("500")//;
  ;
      nm_1 = cp5d.addTextfield("nm_1")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(x0, y0+delta)
            .setSize(wid, hei)
              .setText("520")//;
  ;
      nm_2 = cp5d.addTextfield("nm_2")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(x0, y0+2*delta)
            .setSize(wid, hei)
              .setText("540")//;
  ;
      nm_3 = cp5d.addTextfield("nm_3")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(x0, y0+3*delta)
            .setSize(wid, hei)
              .setText("560")//;
  ;
      nm_4 = cp5d.addTextfield("nm_4")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(x0, y0+4*delta)
            .setSize(wid, hei)
              .setText("580")//;
  ;
   add_Text = cp5d.addTextfield("add_Text")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(50, y0)
            .setSize(100, 20)
              .setText("  change spectrum text")//;
  ;
     time = cp5d.addTextfield("time")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
         .setPosition(50, y0+40)
            .setSize(100, 20)
              .setText("  set time")//;
  ;
  setText = cp5d.addButton("set_Text")
      .setPosition(160, y0)
      .setSize(45, 20)
;
set_Time = cp5d.addButton("set_Time")
      .setPosition(160, y0+40)
      .setSize(45, 20)
;
}

void set_Text(){
 boolean doOne = false;
 for (int t = 0; t<spectra; t++){
   if(selectBox[t] == true){
     //change text
     cHeader[t] = cp5d.get(Textfield.class, "add_Text").getText();
     println("header "+t+": "+cHeader[t]);
     println("viewVal: "+viewVal);
     doOne = true;
   }
 }
   if (doOne == false)
   {// error message
   }
  
}