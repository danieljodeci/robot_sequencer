////////////////////////////
//Created By Daniel Reyes
//2014 || MTIID
//Written for Marimbot
//Using ControlP5 Library
//and OSCP5
///////////////////////////
//ISSUES/TO DO:
//-BPM Knob Adjustment messes with sequence clock
//-Clock timing inaccurate
//-Sequence Clock skips steps
//-Pattern Banks Knob
//-Master Velocity Knob

//CONTROL P5
import controlP5.*;
ControlP5 cp5;

//OSCP5
import oscP5.*;
import netP5.*;
OscP5 oscP5; // Define oscP5 object
NetAddress myRemoteLocation; // Object to send data

//KNOBS
Knob tempo;
Knob ptnSelect;
Knob steps1;
Knob steps2;
Knob steps3;
Knob mVel1;
Knob mVel2;
Knob mVel3;
//BUTTONS
Button play;
Button stop;
Button rSeq1;
Button rSeq2;
Button rSeq3;
Button mute1;
Button mute2;
Button mute3;
Button cSeq1;
Button cSeq2;
Button cSeq3;
Button rNotes;
Button rTogs;
int seqPos = 0;
PFont mono;
PFont mono2;
//Clock Interval
final static int INTERVAL = 1 * 1000;
int lastStored;
//Sequencers
Sequencer[] seq;

int scl[] ={45, 47, 48, 50, 52, 53, 54, 55, 
57, 59, 60, 62, 64, 65, 66, 67, 
69, 71, 72, 74, 76, 77, 78, 79, 
81, 83, 84, 86, 88, 89, 90, 91, 
93, 95, 96};

boolean sketchFullScreen() {
  return true;
}


void setup() {
  size(displayWidth, displayHeight);
  noStroke();
  //CONTROLP5
  cp5 = new ControlP5(this);
  //OSCP5
  oscP5 = new OscP5(this, 12001); // use port for listening 
  myRemoteLocation = new NetAddress("10.2.35.254", 50000);
  //INITIALIZE SEQUENCER
  seq = new Sequencer[3];
  seq[0] = new Sequencer(0, 70, 720, 50, 200, 75, 960, 930);
  seq[1] = new Sequencer(1, 70, 405, 50, 200, 75, 645, 614);
  seq[2] = new Sequencer(2, 70, 90, 50, 200, 75, 328, 300);
  seq[0].create();
  seq[1].create();
  seq[2].create();

  //SET UP COMPONENTS
  play = cp5.addButton("play")
    .setPosition(13, 5)
      .setWidth(28)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              ;
  tempo = cp5.addKnob("tempo")
    .setRange(20, 250)
      .setValue(126)
        .setPosition(7, 31)
          .setRadius(20)
            .setDragDirection(Knob.VERTICAL)
              .setColorForeground(color(0))
                .setColorBackground(color(160, 0, 100))
                  .setColorActive(color(255, 255, 0))
                    .setNumberOfTickMarks(230)
                      .setTickMarkLength(4)
                        .snapToTickMarks(true)
                          ;
  steps1 = cp5.addKnob("steps")
    .setRange(1, 16)
      .setValue(16)
        .setPosition(7, 130)
          .setRadius(20)
            .setDragDirection(Knob.VERTICAL)
              .setColorForeground(color(0))
                .setColorBackground(color(0, 160, 100))
                  .setColorActive(color(255, 255, 0))
                    .setNumberOfTickMarks(15)
                      .setTickMarkLength(4)
                        .snapToTickMarks(true)
                          ;
  mVel1 = cp5.addKnob("mastur")
    .setRange(0, 1)
      .setValue(1)
        .setPosition(7, 200)
          .setRadius(20)
            .setDragDirection(Knob.VERTICAL)
              .setColorForeground(color(0))
                .setColorBackground(color(0, 100, 160))
                  .setColorActive(color(255, 255, 0))
                    .setNumberOfTickMarks(100)
                      .setTickMarkLength(4)
                        .snapToTickMarks(true)
                          ;
  steps2 = cp5.addKnob("stps")
    .setRange(1, 16)
      .setValue(16)
        .setPosition(7, 450)
          .setRadius(20)
            .setDragDirection(Knob.VERTICAL)
              .setColorForeground(color(0))
                .setColorBackground(color(0, 160, 100))
                  .setColorActive(color(255, 255, 0))
                    .setNumberOfTickMarks(15)
                      .setTickMarkLength(4)
                        .snapToTickMarks(true)
                          ;
  mVel2 = cp5.addKnob("master")
    .setRange(0, 1)
      .setValue(1)
        .setPosition(7, 520)
          .setRadius(20)
            .setDragDirection(Knob.VERTICAL)
              .setColorForeground(color(0))
                .setColorBackground(color(0, 100, 160))
                  .setColorActive(color(255, 255, 0))
                    .setNumberOfTickMarks(100)
                      .setTickMarkLength(4)
                        .snapToTickMarks(true)
                          ;
  steps3 = cp5.addKnob("stpz")
    .setRange(1, 16)
      .setValue(16)
        .setPosition(7, 770)
          .setRadius(20)
            .setDragDirection(Knob.VERTICAL)
              .setColorForeground(color(0))
                .setColorBackground(color(0, 160, 100))
                  .setColorActive(color(255, 255, 0))
                    .setNumberOfTickMarks(15)
                      .setTickMarkLength(4)
                        .snapToTickMarks(true)
                          ;
  mVel3 = cp5.addKnob("maester")
    .setRange(0, 1)
      .setValue(1)
        .setPosition(7, 840)
          .setRadius(20)
            .setDragDirection(Knob.VERTICAL)
              .setColorForeground(color(0))
                .setColorBackground(color(0, 100, 160))
                  .setColorActive(color(255, 255, 0))
                    .setNumberOfTickMarks(100)
                      .setTickMarkLength(4)
                        .snapToTickMarks(true)
                          ;
  rSeq1 = cp5.addButton("rndmize")
    .setPosition(11, 300)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              ;
  rSeq2 = cp5.addButton("rndmze")
    .setPosition(11, 613)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              ;
  rSeq3 = cp5.addButton("rndmz")
    .setPosition(11, 929)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              ;
  cSeq1 = cp5.addButton("clear")
    .setPosition(11, 280)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              ;
  cSeq2 = cp5.addButton("cler")
    .setPosition(11, 593)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              ;
  cSeq3 = cp5.addButton("clr")
    .setPosition(11, 909)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              ;
  mute1 = cp5.addButton("muute")
    .setPosition(11, 320)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              .setSwitch(true)
                ;
  mute2 = cp5.addButton("mute")
    .setPosition(11, 633)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              .setSwitch(true)
                ;
  mute3 = cp5.addButton("mut")
    .setPosition(11, 949)
      .setWidth(40)
        .setColorBackground(color(0))
          .setColorForeground(color(20, 200, 120))
            .setColorActive(color(255, 255, 0))
              .setSwitch(true)
                ;
  /*
   KNOB TO SWITCH THROUGH PATTERNS...FOR FUTURE IMPLEMENTATION
   ptnSelect = cp5.addKnob("pattern select")
   .setRange(0, 8)
   .setValue(0)
   .setPosition(550, 100)
   .setRadius(50)
   .setDragDirection(Knob.VERTICAL)
   .setColorForeground(color(0))
   .setColorBackground(color(0, 160, 100))
   .setColorActive(color(255, 255, 0))
   .setNumberOfTickMarks(8)
   .setTickMarkLength(4)
   .snapToTickMarks(true)
   ;
   */
}
int lastSeqPos;
void draw() {
  background(0);
  //TITLE
  textSize(32);
  text("R  O  B  O  T    S  E  Q  U  E  N  C  E  R", 550, 50); 
  fill(200);
  mono = createFont("basictitlefont", 32);
  textFont(mono);

  textSize(12);
  text("D  A  N  I  E  L    R  E  Y  E  S  ", 750, 75); 
  fill(190);
  mono2 = createFont("basictitlefont", 12);
  textFont(mono2);


  //TEMPO
  float bpm=tempo.getValue();
  ////////////
  //CLOCK - FIX ME
  ///////////
  if (millis() - lastStored < INTERVAL )   return;
  int division = int(7500/bpm);
  lastStored += (INTERVAL/division);

  //initialize sequencer position to 0 every time play or stop
  if (play.isPressed() == true) {
    lastStored = 0;
  }
  //playSTART
  if (play.getBooleanValue() == true) {
    seqPos = int(lastStored/division); //time
  }



  //randomize
  if (rSeq1.isPressed() == true) {
    seq[2].randomize();
  }
  if (rSeq2.isPressed() == true) {
    seq[1].randomize();
  }
  if (rSeq3.isPressed() == true) {
    seq[0].randomize();
  }
  //clear pattern
  if (cSeq1.isPressed() == true) {
    seq[2].clearPattern();
  }
  if (cSeq2.isPressed() == true) {
    seq[1].clearPattern();
  }
  if (cSeq3.isPressed() == true) {
    seq[0].clearPattern();
  }

  ////////////////////////////////////////////////
  //FOLLOWING SHOULD BE IMPLEMENTED IN A FOR LOOP
  ////////////////////////////////////////////////

  //modulo each pattern by number of steps
  int clock0 = seqPos%int(steps3.getValue());
  int clock1 = seqPos%int(steps2.getValue());
  int clock2 = seqPos%int(steps1.getValue());

  /////////////////////////////
  //UPDATE PATTERNS          \\ 
  /////////////////////////////
  seq[0].update(clock0);
  seq[1].update(clock1);
  seq[2].update(clock2);

  //OSC HANDLING
  //retrieve state, note and velocity data from sequencer class
  boolean state0 = seq[0].getState(clock0);
  boolean state1 = seq[1].getState(clock1);
  boolean state2 = seq[2].getState(clock2);
  int note0 = seq[0].getNote(clock0);
  int note1 = seq[1].getNote(clock1);
  int note2 = seq[2].getNote(clock2);
  int vel0 = seq[0].getVel(clock0);
  int vel1 = seq[1].getVel(clock1);
  int vel2 = seq[2].getVel(clock2);

  if (mute1.isOn() == true) {
    state2 = false;
  }
  if (mute2.isOn() == true) {
    state1 = false;
  }
  if (mute3.isOn() == true) {
    state0 = false;
  }

  //THANKS TO DEXTER!!!
  //Debounce osc to send once for every change of seqPos
  if (seqPos != lastSeqPos) {
    //SEND
    if ((state0 == true)) {
      sendOsc(scl[note0], int(vel0*mVel3.getValue()));
    }
    if ((state1 == true)) {
      sendOsc(scl[note1], int(vel1*mVel2.getValue()));
    }
    if ((state2 == true)) {
      sendOsc(scl[note2], int(vel2*mVel1.getValue()));
    }
  }

  //HEADER FRAME DISPLAY
  frame.setTitle("M   T   I   I   D  ");
  lastSeqPos = seqPos;
}

//SEND OSC OUT TO CHUCK
void sendOsc(int note, int velocity) {
  OscMessage myMessage = new OscMessage("/marimba");
  myMessage.add(note);
  myMessage.add(velocity);
  oscP5.send(myMessage, myRemoteLocation);
}

