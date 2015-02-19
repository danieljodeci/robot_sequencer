class Sequencer{
  //SLIDERS
  Slider slider[] = new Slider[16];
  //x and y position for sliders1
  int xsPos1;
  int ysPos1;
  int xsSlide1;
  int ysSlide1;
  //KNOBS
  Knob velKnob[] = new Knob[16];
  int xkPos1;
  int ykPos1;
  //TOGGLES
  Toggle swt[] = new Toggle[16];
  int ytPos1;
  int ptrn;

  //Array for note display
  String notes[] = {
    "A1", "B1", "C2", "D2", "E2", "F2", "F#2", "G2", "A2", "B2", "C3", "D3", 
    "E3", "F3", "F#3", "G3", "A3", "B3", "C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5", 
    "D5", "E5", "F5", "F#5", "G5", "A5", "B5"
  };

  Sequencer(int pattern, int xsP, int ysP, int xsS, int ysS, int xkP, int ykP, int ytP ) {
    ptrn = pattern;
    xsPos1 = xsP;
    ysPos1 = ysP;
    xsSlide1 = xsS;
    ysSlide1 = ysS;
    xkPos1 = xkP;
    ykPos1 = ykP;
    ytPos1 = ytP;
  }

  void create(){
    for (int i=0; i<16; i++) {
      //SLIDERS
      slider[i] = cp5.addSlider(str(i+1)+"                  "+ptrn) //add ptrn to give unique ids for each component
        .setPosition(xsPos1+xsSlide1*(i*2), ysPos1)
          .setSize(xsSlide1, ysSlide1)
            .setRange(0, 32)
              .setNumberOfTickMarks(33)
                .setColorBackground(color(20, 20, 40))
                  .setColorForeground(color(20, 200, 120))
                    .setColorActive(color(250, 80, 80))
                    //.setLabelVisible(false);
                      ;
      //KNOBS
      velKnob[i] = cp5.addKnob("VEL "+i+ptrn) //add ptrn to give unique ids for each component
        .setRange(60, 127)
          .setValue(100)
            .setPosition(xkPos1+xsSlide1*(i*2), ykPos1)
              .setRadius(20)
                .setDragDirection(Knob.VERTICAL)
                  .setColorForeground(color(0))
                    .setColorBackground(color(0, 160, 100))
                      .setColorActive(color(255, 255, 0))
                        .setLabelVisible(false);
      ;
      swt[i] = cp5.addToggle("T" + str(i+1)+ptrn) //add ptrn to give unique ids for each component
        .setPosition(xkPos1+xsSlide1*(i*2)+9, ytPos1)
          .setSize(30, 20)
            .setLabelVisible(false)
              .setWidth(20)
                .setColorBackground(color(20, 20, 40))
                  .setColorActive(color(255, 255, 0))
                    .setColorForeground(color(250, 80, 80))
                      ;
    }
    
  }

  void update(int clock) {
 
    
    //display corresponding note to the slider value display
    for (int i=0; i<16; i++) {
      slider[i].setValueLabel(notes[int(slider[i].getValue())]);
      if (clock == i) {
        swt[i].setColorBackground(color(250, 80, 80));
      }
      else {
        swt[i].setColorBackground(color(20, 20, 40));
      }
      if ((slider[i].getValue() > 0) && (clock == i) && (swt[i].getState() == true)) {
        slider[i].setColorForeground(color(250, 80, 80));
      }
      else {
        slider[i].setColorForeground(color(20, int(map(velKnob[i].getValue(), 0, 127, 20, 220)), 
        int(map(velKnob[i].getValue(), 0, 127, 20, 150))));
      }
    }
  }
  void randomize(){
    for(int i = 0; i < 16; i++){
      slider[i].setValue(random(0,33));
      swt[i].setValue((int)random(2));
      velKnob[i].setValue(random(0,127));
    }
  }
  void clearPattern(){
    for(int i = 0; i < 16; i++){
      slider[i].setValue(0);
      swt[i].setValue(0);
      velKnob[i].setValue(100);
    }
  }
  
  boolean getState(int clock){
    return swt[clock].getState();
  }
  /*
  boolean getPreviousState(int clock){
    if(clock == 0){
      clock = 15;
    }
    else{
      clock = clock - 1;
    }
    return swt[clock].getState();
  }
  */
  int getNote(int clock){
    return int(slider[clock].getValue());
  }
  int getVel(int clock){
    return int(velKnob[clock].getValue());
  }
}

