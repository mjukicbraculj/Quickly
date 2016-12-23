import controlP5.*;    //library for adding controls
import geomerative.*;    //library used in HittingObjects game
Drawer drawer;        // class for drawing text
ControlP5 controls;    //for adding controls
Button forwardBtn, backBtn;    
Textfield numberOfPlayersTF;
Textfield[] playersNamesAndKeys;    
PImage[] headingImg;
PShape[] Btns;
int[] correspondingBtn;    //red, green or blue button
float[] pressBtnPositionsX;
float pressBtnPositionY;
float pressBtnWidth;
float pressBtnHeight;
Player[] players;
boolean wellcomeScreen;
boolean setupScreen;
boolean playGameScreen;
int maxPlayersNum = 10;
int minPlayersNum = 1;    //1 or 2?
int numberOfPlayers;    
String error;
Game[] games;
int currentGame;
void setup()
{
  fullScreen();
  frameRate(60);
  //size(1500, 1000);
  drawer = new Drawer();
  controls = new ControlP5(this);
  wellcomeScreen = true;
  setupScreen = false;
  playGameScreen = false;
  headingImg = new PImage[7];
  loadImages();
  addControls();
  wellcomeScreenControls(true);
  addTextfields();
  Btns = new PShape[3];
  Btns[0] = loadShape("images/pressButton1.svg");
  Btns[1] = loadShape("images/hitButton1.svg");
  Btns[2] = loadShape("images/failureButton1.svg");
  games = new Game[3];
  currentGame = 0;
  error = "";
  
  //for HittingObject game
  RG.init(this);
 
}


void draw()
{
  background(150, 150, 150);
  if(wellcomeScreen)
  {
    drawHeading();
    drawer.drawText("Please, enter number of players...", 25, color(0, 0, 0), width*0.95/2, height/2);
    drawer.drawText(error, 25, color(255, 0, 0), width*0.95/2, height*6/7);
  }
  else if(setupScreen)
  {
    drawer.drawText("Please, enter players names and key controls...", 25, color(0, 0, 0), width*0.95/2, height/6);
    drawer.drawText(error, 25, color(255, 0, 0), width*0.95/2, height*6/7);
  }
  else if(playGameScreen)
  {
    for(int i = 0; i < numberOfPlayers; ++i)
    {
      shape(Btns[correspondingBtn[i]], pressBtnPositionsX[i], pressBtnPositionY, pressBtnWidth, 100);
      drawer.drawText(players[i].name, 20, color(255, 255, 255), pressBtnPositionsX[i]+pressBtnWidth/2, pressBtnPositionY+50);
      drawer.drawText(Integer.toString(players[i].score), 20, color(255, 255, 255), pressBtnPositionsX[i]+pressBtnWidth/2, pressBtnPositionY+80);
    } 
    /*for(int i = 0; i < numberOfPlayers; ++i)
      if (correspondingBtn[i] == 1)
        delay(500);*/
        
    games[currentGame].drawState();
    if(games[currentGame].endOfGame())
    {
      ++currentGame;
      if(currentGame > games.length - 1)
        exit();
    }
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
                               .setVisible(false)
                               .setColorCursor(color(255, 255, 255));
                               
  numberOfPlayersTF.getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  wellcomeScreenControls(true);                             
  
}

//adds textfields for entering players names and keys
void addTextfields()
{
  playersNamesAndKeys = new Textfield[maxPlayersNum*2];
  float pomak = (height/1.4 -height/5)/10;
  for(int i = 0; i < maxPlayersNum*2; i+=2)
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

//draws images for creating heading
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

//initialisation of games
//called when number of players is known
public void createGames()
{
  games[0] = new HittingObjects(5, numberOfPlayers, false);
  games[1] = new Equation(5, numberOfPlayers);
  games[2] = new WhiteScreen(5, numberOfPlayers);
}

//method hides first screen and drows second(setup)
//or hides second and drows third(playing)
public void forwardBtnClick()
{
  if(wellcomeScreen)
  {
    try
    {
      numberOfPlayers = Integer.parseInt(numberOfPlayersTF.getText());
      if(numberOfPlayers < 0 || numberOfPlayers > 10)
      {
        numberOfPlayers = 0;
        error = "Number of players must be between 1 and 10";
        return;
      }
      createGames();
      error = "";
      wellcomeScreen = false;
      wellcomeScreenControls(false);
      setupScreen = true;
      players = new Player[numberOfPlayers];
      setPressBtnPositions();
      setupScreenControls(true);
    }
    catch(Exception e)
    {
      error = "Have to write number of players first!";
    }
    
  }
  else
  {
    for(int i = 0; i < numberOfPlayers; ++i)
      if(playersNamesAndKeys[i*2+1].getText().equals(""))
       {
         error = "All players have to select key for playing...!";
         return;
       }
    error = "";
    setupScreen = false;
    setupScreenControls(false);
    playGameScreen = true;
    for(int i = 0; i < numberOfPlayers; i++)
      players[i] = new Player(playersNamesAndKeys[i*2].getText(), 
                Integer.parseInt(playersNamesAndKeys[i*2+1].getText()));
    correspondingBtn = new int[numberOfPlayers];
    for(int i = 0; i < numberOfPlayers; ++i)
      correspondingBtn[i] = 0;
  }
}

//called when number of players is known
//calculates positions of player's buttons
public void setPressBtnPositions()
{
  pressBtnPositionsX = new float[numberOfPlayers];
  int diff = 50;
  pressBtnHeight = height/30;
  pressBtnWidth = (width*0.95 - (numberOfPlayers+1)*diff)/numberOfPlayers;
  for(int i = 0; i < numberOfPlayers; ++i)
    pressBtnPositionsX[i] = (i+1)*diff+i*pressBtnWidth;
  pressBtnPositionY = 6*height/7;
}

//if on the second screen goes to first
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

//returns which text filed is in focus
int textFiledInFocus() 
{
    for (int i = 1; i < numberOfPlayers*2; i+=2)
      if (playersNamesAndKeys[i].isFocus())
        return i;
    return -1;
}

//for entering key controls in  setupScreen
//for refreshing player's buttons to blue while playing
void keyReleased() 
{
  if(setupScreen)
  {
    int index = textFiledInFocus();
    if (index >= 0) {
      //playersNamesAndKeys[index].setText(playersNamesAndKeys[index].getText() + " (" +
      //                                            Integer.toString(keyCode) + ")");
      playersNamesAndKeys[index].setText(Integer.toString(keyCode));                                 
    }
  }
  else if(playGameScreen)
  {
    for(int i = 0; i < numberOfPlayers; ++i)
    {
      if(players[i].myKey == keyCode)
        correspondingBtn[i] = 0;
    }
  }
}

/**changes player's button color 
 *if game score is 1 then it's green
 *else if is -1 it's red
 *else stays blue
 */
void keyPressed()
{
  if(playGameScreen)
  {
    for(int i = 0; i < numberOfPlayers; ++i)
    {
      if(players[i].myKey == keyCode)
      {
        int tmp = games[currentGame].score(i);
        if(tmp == -1)
        {
          correspondingBtn[i] = 2;
          players[i].score -= 1;
        }
        else if(tmp == 1)
        {
          correspondingBtn[i] = 1;
          players[i].score += 1;
        }
        else
          correspondingBtn[i] = 0;
      }
    }
  }
  else if(keyCode == ENTER && (wellcomeScreen || setupScreen))
    forwardBtnClick();
}