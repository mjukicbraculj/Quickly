import controlP5.*;
Drawer drawer;
ControlP5 controls;
Button forwardBtn, backBtn;
Textfield numberOfPlayersTF;
Textfield[] playersNamesAndKeys;
PImage[] headingImg;

boolean wellcomeScreen;
boolean setupScreen;
int maxPlayersNum = 10;
int minPlayersNum = 1;
int numberOfPlayers;

void setup()
{
  fullScreen();
  //size(1500, 1000);
  drawer = new Drawer();
  controls = new ControlP5(this);
  wellcomeScreen = true;
  setupScreen = false;
  headingImg = new PImage[7];
  loadImages();
  addControls();
  wellcomeScreenControls(true);
}

void draw()
{
  background(100, 100, 100);
  if(wellcomeScreen)
  {
    drawHeading();
    drawer.drawText("Please, enter number of players...", 25, color(0, 0, 0), width*0.95/2, height/2);
  }
  else if(setupScreen)
  {
    drawer.drawText("Please, enter players names and key controls...", 25, color(0, 0, 0), width*0.95/2, height/6);
  }
    
}

//adds buttons, textFields and all other controls...
void addControls()
{
  forwardBtn = controls.addButton("forward")
                    .setSize(width/15, height/15)
                    .setPosition(width*0.95/2 + 400, height/1.3)
                    .setImage(loadImage("images/forward.png"), Controller.DEFAULT)
                    .setVisible(false);
  backBtn = controls.addButton("back")
                    .setSize(width/15, height/15)
                    .setPosition(width*0.95/2 - 500, height/1.3)
                    .setImage(loadImage("images/back.png"), Controller.DEFAULT)
                    .setVisible(false);                 
  numberOfPlayersTF = controls.addTextfield("")
                               .setSize(width/15, height/20)
                               .setPosition(width*0.95/2 - width/30, height/1.8)
                               .setColorBackground(color(255, 255, 255))
                               .setFont(drawer.getControlFont(30))
                               .setColorValueLabel(color(0, 0, 0))
                               .setVisible(false);
                               
  numberOfPlayersTF.getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  wellcomeScreenControls(true);                             
  
}

void addDynamicTextfields()
{
  playersNamesAndKeys = new Textfield[numberOfPlayers*2];
  float pomak = (height/1.4 -height/5)/10;
  for(int i = 0; i < numberOfPlayers*2; i+=2)
  {
    playersNamesAndKeys[i] = controls.addTextfield("Player"+i/2)
                                     .setSize(width/10, height/30)
                                     .setPosition(width*0.95/2 - width/10-50, height/5 + pomak * i / 2)
                                     .setColorBackground(color(255, 255, 255))
                                     .setFont(drawer.getControlFont(20))
                                     .setColorValueLabel(color(0, 0, 0))
                                     .setVisible(false)
                                     .setText("Name"+i/2);
    playersNamesAndKeys[i].getCaptionLabel()
                           .setFont(drawer.getButtonFont(15)).setColor(color(0, 0, 0))
                           .align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER)
                           .getStyle().setPaddingLeft(-30);
    playersNamesAndKeys[i].getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    playersNamesAndKeys[i+1] = controls.addTextfield("Key"+i)
                                       .setSize(width/10, height/30)
                                       .setPosition(width*0.95/2 + 50, height/5 + pomak * i / 2)
                                       .setColorBackground(color(255, 255, 255))
                                       .setFont(drawer.getControlFont(20))
                                       .setColorValueLabel(color(0, 0, 0))
                                       .setVisible(false);
    playersNamesAndKeys[i+1].getCaptionLabel().setFont(drawer.getButtonFont(10)).setVisible(false);
    playersNamesAndKeys[i+1].getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  }
}
void drawHeading()
{
  /////!!0.95 FIX!!why!
  float startPosition = (width*0.95 - 6 * headingImg[0].width / 1.5 - headingImg[0].width) / 2;
  for(int i = 0; i < 7; ++i)
    image(headingImg[i], startPosition + i*headingImg[i].width/1.5, height/5);
}


//loads images for heading
void loadImages()
{
  for(int i = 0; i < 7; ++i)
  {
    headingImg[i] = loadImage("images/" + i + ".png");
    headingImg[i].resize(width/12, width/12);
  }
}

//what to do when back button is pressed
//what to do whan forward button is pressed
void controlEvent(ControlEvent theEvent)
{
  if(theEvent.getName().equals("forward"))
    forwardBtnClick();
  else if(theEvent.getName().equals("back"))
    backBtnClick();
  
}

public void wellcomeScreenControls(boolean visible)
{
  forwardBtn.setVisible(visible);
  backBtn.setVisible(visible);
  numberOfPlayersTF.setVisible(visible);
  if(!visible)
  {
    forwardBtn.hide();
    backBtn.hide();
  }
}

public void setupScreenControls(boolean visible)
{
  for(int i = 0; i < numberOfPlayers*2; ++i)
    playersNamesAndKeys[i].setVisible(visible);
  forwardBtn.setVisible(visible);
  backBtn.setVisible(visible);  
  if(!visible)
  {
    forwardBtn.hide();
    backBtn.hide();
  }
}

//method hides first screen and drows second(setup)
//or hides second and drows third(playing)
public void forwardBtnClick()
{
  if(wellcomeScreen)
  {
    wellcomeScreen = false;
    wellcomeScreenControls(false);
    setupScreen = true;
    numberOfPlayers = Integer.parseInt(numberOfPlayersTF.getText());
    addDynamicTextfields();
    setupScreenControls(true);
  }
  else
  {
    //kada odemo na play
  }
}

//if on the cesond screen goes to first
//that's only possiblity
public void backBtnClick()
{
  if(setupScreen)
  {
    wellcomeScreen = true;
    setupScreen = false;
    setupScreenControls(false);
    wellcomeScreenControls(true);
  }
}

//check if some textfiled is in focus
//and remoce placeholder if it is
void mousePressed()
{
  for(int i = 0; i < numberOfPlayers * 2; i+=2)
      if(playersNamesAndKeys[i].isFocus() && playersNamesAndKeys[i].getText().equals("Name"+i/2))
         playersNamesAndKeys[i].setText("");
}