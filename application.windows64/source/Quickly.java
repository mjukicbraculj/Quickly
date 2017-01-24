import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import geomerative.*; 
import java.util.ResourceBundle; 
import java.util.PropertyResourceBundle; 
import java.util.Locale; 
import java.util.Enumeration; 
import java.net.URL; 
import processing.core.PApplet; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Quickly extends PApplet {

    //library for adding controls
    //library used in HittingObjects game





Drawer drawer;        // class for drawing text
ControlP5 controls;    //for adding controls
Button forwardBtn, backBtn, homeBtn, newGameBtn;
//RadioButton gameType;
CheckBox gameType;
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
boolean endOfGameScreen;
int maxPlayersNum = 10;
int minPlayersNum = 1;    //1 or 2?
int numberOfPlayers;    
String error;
ArrayList<Game> games;
int currentGame;

static Locale locale;
static ResourceBundle res;
String bundleName = "language";

StringDict specialKeys;

public void setup()
{
  
  frameRate(60);
  //res = ResourceBundle.getBundle(bundleName, Locale.getDefault(), new ProcessingClassLoader(this));
  res = ResourceBundle.getBundle(bundleName, new Locale("hr"), new ProcessingClassLoader(this));
  //size(1500, 1000);
  drawer = new Drawer();
  controls = new ControlP5(this);
  wellcomeScreen = true;
  setupScreen = false;
  playGameScreen = false;
  endOfGameScreen = false;
  headingImg = new PImage[7];
  loadImages();
  addControls();
  wellcomeScreenControls(true);
  addTextfields();
  Btns = new PShape[3];
  Btns[0] = loadShape("images/pressButton1.svg");
  Btns[1] = loadShape("images/hitButton1.svg");
  Btns[2] = loadShape("images/failureButton1.svg");
  games = new ArrayList<Game>();
  error = "";
  //for HittingObject game
  RG.init(this);
  inicialiseSpecialKeysDictionary();

}


private void inicialiseSpecialKeysDictionary()
{
  specialKeys = new StringDict();
  specialKeys.set(Integer.toString(UP), "UP");
  specialKeys.set(Integer.toString(DOWN), "DOWN");
  specialKeys.set(Integer.toString(LEFT), "LEFT");
  specialKeys.set(Integer.toString(RIGHT), "RIGHT");
  specialKeys.set(Integer.toString(ALT), "ALT");
  specialKeys.set(Integer.toString(CONTROL), "CONTROL");
  specialKeys.set(Integer.toString(SHIFT), "SHIFT");
  specialKeys.set(Integer.toString(BACKSPACE), "BACKSPACE");
  specialKeys.set(Integer.toString(TAB), "TAB");
  specialKeys.set(Integer.toString(ENTER), "ENTER");
  specialKeys.set(Integer.toString(RETURN), "RETURN");
  specialKeys.set(Integer.toString(DELETE), "DELETE");
  specialKeys.set(Integer.toString(32), "SPACE");
  println(specialKeys);
}

public static String GetString(String key)
{
  String value = null;
  try
  {
    value = res.getString(key);
  }
  catch (Exception e)
  {
    value = key; // Poor substitute, but hey, might give an information anyway
  }
  return value;
}

//initialisation of games
//called when number of players is known
public void createGames()
{
  java.util.List checkBoxItems = gameType.getItems();
  for(int j = 0; j < checkBoxItems.size(); ++j)
  {
    Toggle t = (Toggle)checkBoxItems.get(j);
    if(t.getState())
    {
      int mode = (int)t.internalValue();
      switch(mode)
      {
        case 0:
          games.add(new Equation(4, numberOfPlayers));
          break;
        case 1:
          games.add(new HittingObjects(4, numberOfPlayers, false));
          break;
        case 2:
          games.add(new MatchCityState(4, numberOfPlayers));
          break;
        case 3:
          games.add(new MatchColorText(4, numberOfPlayers));
          break;
        case 4:
          games.add(new MatchStatesByPopulation(4, numberOfPlayers));
          break;
        case 5:
          games.add(new SadFace(4, numberOfPlayers));
          break;
        case 6:
          games.add(new WhiteScreen(4, numberOfPlayers));
          break;
        case 7:
          games.add(new HitBeaver(4, numberOfPlayers));
          break;
        case 8:
          games.add(new PlusMinus(4, numberOfPlayers));
          break;
        case 9:
          games.add(new FiveDifferent(4, numberOfPlayers));
          break;
      }
    }
  }
}

public void draw()
{
  background(150, 150, 150);
  if(wellcomeScreen)
  {
    drawHeading();
    drawer.drawText(GetString("numberOfPlayers"), 25, color(0, 0, 0), width*0.95f/2, height/2.2f);
    drawer.drawText(error, 25, color(255, 0, 0), width*0.95f/2, height*6/7);
  }
  else if(setupScreen)
  {
    drawer.drawText(GetString("playersName"), 25, color(0, 0, 0), width*0.95f/2 - 350, height/6);
    drawer.drawText(GetString("gameType"), 25, color(0, 0, 0), width*0.95f/2 + 350, height/6);
    drawer.drawText(error, 25, color(255, 0, 0), width*0.95f/2, height*6/7);
  }
  else if(playGameScreen)
  {
    drawer.drawText(games.get(currentGame).helpMessage, 25, color(255, 0, 0), width*0.95f/2, height/7);
    for(int i = 0; i < numberOfPlayers; ++i)
    {
      shapeMode(CORNER);
      shape(Btns[correspondingBtn[i]], pressBtnPositionsX[i], pressBtnPositionY, pressBtnWidth, 100);
      drawer.drawText(players[i].name, 20, color(255, 255, 255), pressBtnPositionsX[i]+pressBtnWidth/2, pressBtnPositionY+50);
      drawer.drawText(Integer.toString(players[i].score), 20, color(255, 255, 255), pressBtnPositionsX[i]+pressBtnWidth/2, pressBtnPositionY+80);
    } 
    /*for(int i = 0; i < numberOfPlayers; ++i)
      if (correspondingBtn[i] == 1)
        delay(500);*/
    if(games.get(currentGame).justStarted)
      games.get(currentGame).printInstructions();
    else
    {
      games.get(currentGame).drawState();
      if(games.get(currentGame).endOfGame())
      {
        ++currentGame;
        if(currentGame > games.size() - 1)
        {
          playGameScreen = false;
          endOfGameScreen = true;
        }
      }
    }
  }
  else if(endOfGameScreen)
  {
    for(int i = 0; i < numberOfPlayers; ++i)
      drawer.drawText(players[i].name + " ----> " + players[i].score, 
                                      20, color(0, 0, 0), width*0.95f/2, (height/1.4f -height/5)/10*i + height/5);
    endOfGameScreenControls(true);
  }
    
}

//adds buttons, textFields and all other controls...
public void addControls()
{
  controls.setFont(drawer.getControlFont(20));
  forwardBtn = controls.addButton("forward")
                    .setSize(width/15, height/15)
                    .setPosition(width*0.95f/2 + 400, height/1.3f)
                    .setImage(loadImage("images/forward.png"), Controller.DEFAULT)
                    .setVisible(false);
  backBtn = controls.addButton("back")
                    .setSize(width/15, height/15)
                    .setPosition(width*0.95f/2 - 500, height/1.3f)
                    .setImage(loadImage("images/back.png"), Controller.DEFAULT)
                    .setVisible(false);  
  //gameType = controls.addRadioButton("gameType", (int)(width*0.95/2)-55, (int)(height/1.4))
  //                   .setSize(30, 30)
  //                   .setVisible(false);
  //gameType.addItem("default", 1);
  //gameType.addItem("custom", 2);
  //gameType.getItem("default").setState(true);
  //gameType.getCaptionLabel().setFont(drawer.getButtonFont(20));
  newGameBtn = controls.addButton(GetString("newGame"))
                       .setSize(width/15, height/15)
                       .setPosition(width*0.95f/2 - 200 - width/15 , 4*height/5)
                       .setVisible(false);
  homeBtn = controls.addButton(GetString("home"))
                       .setSize(width/15, height/15)
                       .setPosition(width*0.95f/2 + 200, 4*height/5)
                       .setVisible(false);
  numberOfPlayersTF = controls.addTextfield("")
                               .setSize(width/15, height/20)
                               .setPosition(width*0.95f/2 - width/30, height/2)
                               .setColorBackground(color(255, 255, 255))
                               .setColorValueLabel(color(0, 0, 0))
                               .setVisible(false)
                               .setColorCursor(color(255, 255, 255));
                               
  numberOfPlayersTF.getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  gameType = controls.addCheckBox("gameType")
                       .setPosition(width*0.95f/2 + 250, height/5)
                       .setSize(30, 30)
                       .addItem(GetString("Equation"), 0)
                       .addItem(GetString("Hitting_objects"), 1)
                       .addItem(GetString("Match_city_state"), 2)
                       .addItem(GetString("Match_color_text"), 3)
                       .addItem(GetString("Match_state_by_population"), 4)
                       .addItem(GetString("Sad_face"), 5)
                       .addItem(GetString("White_screen"), 6)
                       .addItem(GetString("Hit_Beaver"), 7)
                       .addItem(GetString("Plus_and_Minus"), 8)
                       .addItem(GetString("Five_different"), 9)
                       .setVisible(false);
    java.util.List<Toggle> items = gameType.getItems();
    for(int j = 0; j < gameType.getItems().size(); ++j)
      items.get(j).setState(true);
  
  wellcomeScreenControls(true);                             
  
}

//adds textfields for entering players names and keys
public void addTextfields()
{
  playersNamesAndKeys = new Textfield[maxPlayersNum*2];
  float pomak = (height/1.4f -height/5)/10;
  for(int i = 0; i < maxPlayersNum*2; i+=2)
  {
    playersNamesAndKeys[i] = controls.addTextfield(GetString("Player")+i/2)
                                     .setSize(width/10, height/30)
                                     .setPosition(width*0.95f/2 - width/10-400, height/5 + pomak * i / 2)
                                     .setColorBackground(color(255, 255, 255))
                                     .setFont(drawer.getControlFont(20))
                                     .setColorValueLabel(color(0, 0, 0))
                                     .setVisible(false)
                                     .setText(GetString("Name")+i/2);
    playersNamesAndKeys[i].getCaptionLabel()
                           .setFont(drawer.getButtonFont(15)).setColor(color(0, 0, 0))
                           .align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER)
                           .getStyle().setPaddingLeft(-30);
    playersNamesAndKeys[i].getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    playersNamesAndKeys[i+1] = controls.addTextfield("Key"+i)
                                       .setSize(width/10, height/30)
                                       .setPosition(width*0.95f/2 - 300, height/5 + pomak * i / 2)
                                       .setColorBackground(color(255, 255, 255))
                                       .setFont(drawer.getControlFont(20))
                                       .setColorValueLabel(color(0, 0, 0))
                                       .setText(str(parseChar(PApplet.parseInt(random(65, 90)))))
                                       .setVisible(false);
    playersNamesAndKeys[i+1].getCaptionLabel().setFont(drawer.getButtonFont(10)).setVisible(false);
    playersNamesAndKeys[i+1].getValueLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  }
}

//draws images for creating heading
public void drawHeading()
{
  /////!!0.95 FIX!!why!
  float startPosition = (width*0.95f - 6 * headingImg[0].width / 1.5f - headingImg[0].width) / 2;
  for(int i = 0; i < 7; ++i)
    image(headingImg[i], startPosition + i*headingImg[i].width/1.5f, height/5);
}


//loads images for heading
public void loadImages()
{
  for(int i = 0; i < 7; ++i)
  {
    headingImg[i] = loadImage("images/" + i + ".png");
    headingImg[i].resize(width/12, width/12);
  }
}

//what to do when back button is pressed
//what to do whan forward button is pressed
public void controlEvent(ControlEvent theEvent)
{
  if(theEvent.getName().equals("forward"))
    forwardBtnClick();
  else if(theEvent.getName().equals("back"))
    backBtnClick();
  else if(theEvent.getName().equals(GetString("home")))
    homeBtnClick();
  else if(theEvent.getName().equals(GetString("newGame")))
    newGameBtnClick();
}

public void newGameBtnClick()
{
  playGameScreen = true;
  for(int i = 0; i < numberOfPlayers; ++i)
    players[i].score = 0;
  for(int i = 0; i < numberOfPlayers; ++i)
      correspondingBtn[i] = 0;
  createGames(); 
  currentGame = 0;
  endOfGameScreenControls(false);
}

public void homeBtnClick()
{
  wellcomeScreen = true;
  wellcomeScreenControls(true);
  endOfGameScreenControls(false);
}

public void wellcomeScreenControls(boolean visible)
{
  forwardBtn.setVisible(visible);
  backBtn.setVisible(visible);
  numberOfPlayersTF.setVisible(visible);
  //gameType.setVisible(visible);
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
  gameType.setVisible(visible);
  if(!visible)
  {
    forwardBtn.hide();
    backBtn.hide();
  }
}

public void endOfGameScreenControls(boolean visible)
{
  homeBtn.setVisible(visible);
  newGameBtn.setVisible(visible);
  if(!visible)
  {
    homeBtn.hide();
    newGameBtn.hide();
  }
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
        error = GetString("intervalError");
        return;
      }
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
      error = GetString("numberOfPlayersError");
    }
    
  }
  else
  {
    for(int i = 0; i < numberOfPlayers; ++i)
      if(playersNamesAndKeys[i*2+1].getText().equals(""))
       {
         error = GetString("keysError");
         return;
       }
    error = "";
    setupScreen = false;
    setupScreenControls(false);
    createGames();
    playGameScreen = true;
    for(int i = 0; i < numberOfPlayers; i++){
      int playerKey = -1; 
      String[] keys = specialKeys.keyArray();
      for(int k = 0; k < keys.length; ++k)
        if(playersNamesAndKeys[i*2+1].getText().equals(specialKeys.get(keys[k]))){
          playerKey = parseInt(keys[k]);
          break;
        }
      if(playerKey == -1)
        playerKey = (int)(playersNamesAndKeys[i*2+1].getText().charAt(0));
      players[i] = new Player(playersNamesAndKeys[i*2].getText(), playerKey);
    }
    correspondingBtn = new int[numberOfPlayers];
    for(int i = 0; i < numberOfPlayers; ++i)
      correspondingBtn[i] = 0;
    currentGame = 0;
  }
}

//called when number of players is known
//calculates positions of player's buttons
public void setPressBtnPositions()
{
  pressBtnPositionsX = new float[numberOfPlayers];
  int diff = 50;
  pressBtnHeight = height/30;
  pressBtnWidth = (width*0.95f - (numberOfPlayers+1)*diff)/numberOfPlayers;
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
public void mousePressed()
{
  for(int i = 0; i < numberOfPlayers * 2; i+=2)
      if(playersNamesAndKeys[i].isFocus() && playersNamesAndKeys[i].getText().equals(GetString("Name")+i/2))
         playersNamesAndKeys[i].setText("");
}

//returns which text filed is in focus
public int textFiledInFocus() 
{
    for (int i = 1; i < numberOfPlayers*2; i+=2)
      if (playersNamesAndKeys[i].isFocus())
        return i;
    return -1;
}

//for entering key controls in  setupScreen
//for refreshing player's buttons to blue while playing
public void keyReleased() 
{
  if(setupScreen)
  {
    int index = textFiledInFocus();
    String keyText = specialKeys.get(Integer.toString(keyCode));
    if(keyText == null)
      keyText = str(key).toUpperCase();
    playersNamesAndKeys[index].setText(keyText);
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
public void keyPressed()
{
  if(playGameScreen)
  {
    for(int i = 0; i < numberOfPlayers; ++i)
    {
      if(players[i].myKey == keyCode)
      {
        int tmp = games.get(currentGame).score(i);
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
class Colors
{
  int[] myColors;
  String[] names;
  int numberOfColors = 10;
  
  Colors()
  {
    myColors = new int[numberOfColors];
    names = new String[numberOfColors];
    
    myColors[0] = color(255, 0, 0);
    myColors[1] = color(0, 255, 0);
    myColors[2] = color(0, 0, 255);
    myColors[3] = color(0,0,0);
    myColors[4] = color(255, 255, 255);
    myColors[5] = color(255, 255, 51);
    myColors[6] = color(128, 0, 128);
    myColors[7] = color(255, 165, 0);
    myColors[8] = color(255, 192, 203);
    myColors[9] = color(165, 42, 42);
    
    names[0] = "red";
    names[1] = "green";
    names[2] = "blue";
    names[3] = "black";
    names[4] = "white";
    names[5] = "yellow";
    names[6] = "pruple";
    names[7] = "orange";
    names[8] = "pink";
    names[9] = "brown";
   
  }
  
  public int getRandomColor()
  {
    return myColors[(int)random(0, numberOfColors)];
  }
}
class Drawer
{
  PFont myFont;
  
  //constructor creates initial font
  Drawer()
  {
    myFont = createFont("Arial", 16, true);
  }
  
  //method draws text with chosen size, color, position
  public void drawText(String text, int fontSize,
                  int fontColor, float centerX, float centerY)
  {
    setFont(fontSize, fontColor);
    textAlign(CENTER);
    text(text, centerX, centerY);
  }
  
   //method draws text with chosen size, color, position
  public void drawTextByColor(String text, int fontSize,
                  int fontColor, float centerX, float centerY)
  {
    textFont(myFont, fontSize);
    fill(fontColor);
    textAlign(CENTER);
    text(text, centerX, centerY);
  }
  
  //method changes font size and color
  public void setFont(int fontSize, int fontColor)
  {
    textFont(myFont,fontSize);
    fill(fontColor);
  }
  
  public PFont getButtonFont(int fontSize)
  {
    textFont(myFont,fontSize);
    return myFont;      
  }
  
  public ControlFont getControlFont(int fontSize)
  {
    return new ControlFont(myFont, fontSize);
  }
  
}
class Equation extends Game
{

  int gameFontSize = 25;
  String equation;
  boolean result;

  public boolean initializeRound()
  {

    int firstNumber;
    int secondNumber;
    int solution;
    int range = 4;

    // If int is less then 1 we make addition equation, between 1 and 2 subtraction,
    // and more then 2 multiplication.
    float operation = random(0,3);

    if(operation < 1)
    {
      firstNumber = PApplet.parseInt(random(3,47));
      secondNumber = PApplet.parseInt(random(3,48));
      if(random(0,1) > 0.5f)
        solution = firstNumber + secondNumber;
      else
        solution = PApplet.parseInt(random(firstNumber + secondNumber - range, firstNumber + secondNumber + range));
      result = (firstNumber + secondNumber == solution);
      equation = str(firstNumber) + " + " + str(secondNumber) + " = " + str(solution);
    }
    else if(operation < 2)
    {
      firstNumber = PApplet.parseInt(random(3,47));
      secondNumber = PApplet.parseInt(random(3,48));
      if(random(0,1) > 0.5f)
        solution = firstNumber - secondNumber;
      else
        solution = PApplet.parseInt(random(firstNumber - secondNumber - range, firstNumber - secondNumber + range));
      result = (firstNumber - secondNumber == solution);
      equation = str(firstNumber) + " - " + str(secondNumber) + " = " + str(solution);
    }
    else
    {
      firstNumber = PApplet.parseInt(random(3,13));
      secondNumber = PApplet.parseInt(random(3,13));
      if(random(0,1) > 0.5f)
        solution = firstNumber * secondNumber;
      else
        solution = PApplet.parseInt(random(firstNumber * secondNumber - range, firstNumber * secondNumber + range));
      result = (firstNumber * secondNumber == solution);
      equation = str(firstNumber) + " * " + str(secondNumber) + " = " + str(solution);
    }

    return true;

  }

  public Equation(int numberOfRounds, int numberOfPlayers)
  {
    super("Equation", Quickly.GetString("equationHelp"), 5, numberOfRounds, numberOfPlayers);
    initializeRound();
  }

  public boolean checkSolution()
  {
    return result;
  }


  public boolean drawCurrentRound()
  {
    Drawer drawer = new Drawer();
    drawer.drawText(equation, gameFontSize, 0, width/2, height/2);
    return true;
  }

}
class FiveDifferent extends Game
{
  PImage[] images;
  IntList imagesOnScreen;
  int frame = 60;
  FloatList xPosition;
  FloatList yPosition;
  
  public FiveDifferent(int numberOfRounds, int numberOfPlayers)
  {
    super("FiveDifferent", Quickly.GetString("FiveHelp"), 12, numberOfRounds, numberOfPlayers);
    images = new PImage[5];
    for(int i = 0; i < images.length; ++i)
      images[i] = loadImage("images/image" + i + ".png");
    imagesOnScreen = new IntList();
    xPosition = new FloatList();
    yPosition = new FloatList();
    initializeRound();
  }
  
  public boolean initializeRound()
  {
    imagesOnScreen.clear();
    xPosition.clear();
    yPosition.clear();
    return true;
  }
  
  private void addNewImage()
  {
    imagesOnScreen.append((int)random(0, images.length)); 
    xPosition.append(random(0.2f * width, .8f * width));
    yPosition.append(random(0.3f*height, 0.7f * height));
  }
  
  public boolean checkSolution()
  {
    int image0 = 0, image1 = 0, image2 = 0, image3 = 0, image4 = 0;
    for(int i = 0; i < imagesOnScreen.size(); ++i)
    {
      switch(imagesOnScreen.get(i))
      {
        case 0:
          image0++;
          break;
        case 1:
          image1++;
          break;
        case 2: 
          image2++;
          break;
        case 3: 
          image3++;
          break;
        case 4:
          image4++;
          break;
      }
    }
    if(image0 > 0 && image1 > 0 && image2 > 0 && image3 > 0 && image4 > 0)
      return true;
    return false;
  }
  
  public boolean drawCurrentRound()
  {
    if(passedFrames % frame == 0)
      addNewImage();
    for(int i = 0; i < imagesOnScreen.size(); ++i)
      image(images[imagesOnScreen.get(i)], xPosition.get(i), yPosition.get(i), 150, 150);
    return true;
  }
}
/**
 * Abstraction for creating games. Each game that want to inherite this class
 * needs to implemet 3 functions characteristic for those games.
 * This class take care of waiting before round starts, end round and
 * users clicks.
 */
abstract class Game
{
  // Game name that will be displayed.
  String gameName;
  // Additional help message that could be displayed.
  String helpMessage;
  // Size of font for game name;
  int gameNameFontSize = 40;
  // Size of font for help message.
  int helpMessageFontSize = 25;
  // Number of iteration each game will be played.
  int numberOfRounds;
  // Number of players playing game, needed for array scoreForPlayer.
  int numberOfPlayers;
  // Number of score each player achieved during game (could be negative).
  int[] scoreForPlayers;
  // Number of current round.
  int roundNumber;
  // Number of passed frames from round start.
  int passedFrames;
  // Boolean if all rounds are finished.
  boolean gameOver;
  // Boolean that says if game has started.
  boolean startPlaying;
  // Number of seconds before round finish.
  int numberOfSecondsPerRound;
  // Number of frames per round (numberOfSceondsPerRound * frameRate)
  int numberOfFramesPerRound;
  // Number of frames before round starts.
  int numberOfFramesBeforeStart = 30;
  // Bolean that says if game just started so we need to print instructions.
  boolean justStarted;
  // Number of seconds instruction screen will be shown;
  float numberOfSecondsForInstructionScreen = 1;
  // Number of frames instruction screen will be shown;
  int numberOfFramesForInstructionScreen;
  
  /**
   * Initialize everything specific game needs.
   * Function is called every time at the start of new round.
   * @return Boolean true if there was no error, false otherwise.
   */
  public abstract boolean initializeRound();
  /**
   * Check if user clicked in the right time and return true if she is, else false.
   * @return Boolean true if click happend when result of game was positive, else false.
   */
  public abstract boolean checkSolution();
  /**
   * Draw everything round in game needs.
   * Function is called on every frame durring game after round started
   * and players buttons activated. 
   * @return Boolean true if there was no error, false otherwise.
   */
  public abstract boolean drawCurrentRound();
  
  
  /**
   * Constructor initialize all game non specific elements.
   * @param gameName                    Name of game.
   * @param helpMessage                 Text that will be shown to users for hint in playing game.
   * @param numberOfSecondsPerRound     Maximal duration in seconds for each round of game.
   * @param numberOfRounds              Number of round this game will be played.
   * @param numberOfPlayers             Number of players playing game.
   */
  public Game(String gameName, String helpMessage, int numberOfSecondsPerRound, int numberOfRounds, int numberOfPlayers)
  {
    this.gameName = gameName;
    this.helpMessage = helpMessage;
    this.numberOfRounds = numberOfRounds;
    this.numberOfPlayers = numberOfPlayers;
    this.scoreForPlayers = new int[numberOfPlayers];
    
    roundNumber = 0;
    gameOver = false;
    startPlaying = false;
    passedFrames = 0;
    numberOfFramesPerRound = PApplet.parseInt(frameRate * numberOfSecondsPerRound);
    justStarted = true;
    numberOfFramesForInstructionScreen = PApplet.parseInt(numberOfSecondsForInstructionScreen * frameRate);
    //initializeRound();
  }
  
  public boolean printInstructions()
  {
    passedFrames++;
    
    Drawer drawer = new Drawer();
    drawer.drawText(Quickly.GetString(helpMessage), 30, color(255, 0, 0), width*0.95f/2, height/2);
    
    if(passedFrames > numberOfFramesForInstructionScreen)
    {
      justStarted = false;
      passedFrames = 0;
    }
    return true;
  }


  /**
   * Auxiliary function that do cleaning work at the end of each round.
   */
  public boolean endRound()
  {
    startPlaying = false;
    passedFrames = 0;
    roundNumber++;
    if(roundNumber == numberOfRounds)
      gameOver = true;
    else
        initializeRound();

    return true;
  }


  /**
   * Calculate if player pressed button on right time,
   * and depending on that return -1,0 or 1.
   * @param player Number of player in list of all players.
   * @return -1 if player clicked button in wrong time,
   *          0 if player clicked button before game started.
   *          1 if player clicked button at right time first.
   */
  public int score(int player)
  {
    // If round hasn't started or is over, or game is over nothing happens.
    if(startPlaying == false || gameOver)
      return 0;

    // If round is active and white screen havent appered.
    boolean solution = checkSolution();
    if(solution == false)
    {
      scoreForPlayers[player]--;
      return -1;
    }
    else
    {
      endRound();
      scoreForPlayers[player]++;
      return 1;
    }
  }


  /**
   * Draw screen for current game.
   * @return Boolean false if some error happened, else true.
   */
  public boolean drawState()
  {
    passedFrames++;

    if(passedFrames > numberOfFramesPerRound)
      return endRound();

    if(gameOver)
      return false;

    if(passedFrames > numberOfFramesBeforeStart && startPlaying == false)
      startPlaying = true;


    if(startPlaying)
      return drawCurrentRound();


    return true;
  }

  /**
   * Return if game is over including all iterations (rounds).
   * If it returns true new, different game will be started.
   * @return Boolean true if all iterations are finished, else false.
   */
  public boolean endOfGame()
  {
      return gameOver;
  }

   
  /**
   * Function that return current score for each player in this kind of game. 
   * @return integer array of score for each player in this game.
   */
  public int[] finalScore()
  {
    return scoreForPlayers;
  }

}
class HitBeaver extends Game
{
  PShape[] animals;
  
  float secondsOfAnimalMin = 1;
  float secondsOfAnimalMax = 2;
  
  final int numberOfAnimals = 3;
  final int numberOfHoles = 3;
  int holePositionsX[];
  int holePositionY;
  int holeSize;
  
  int framesOfAnimal;
  int animalPosition;
  // 0 if animal is beaver, else >0 .
  int animalType;
  int framesOfAnimalPassed;

  int imageSize;
  
  boolean solution;
  
  
  public HitBeaver(int numberOfRounds, int numberOfPlayers)
  {
    super("Hit beaver", Quickly.GetString("BeaverHeplp"), 8, numberOfRounds, numberOfPlayers);
    
    holeSize = PApplet.parseInt((min(width, height)*0.9f-(numberOfHoles+1)*50)/numberOfHoles);

    int betweenHoles = 50;
    int startEnd = (width - holeSize*(numberOfHoles-1) - betweenHoles*numberOfHoles)/2;
    int holeBetweenHole = betweenHoles + holeSize;
    
    holePositionY = height/2;
    holePositionsX = new int[numberOfHoles];
    for(int i=0; i<numberOfHoles; i++)
      holePositionsX[i] = i*holeBetweenHole + startEnd;
      
    animals = new PShape[numberOfAnimals];
    animals[0] = loadShape("images/beaver.svg");
    animals[1] = loadShape("images/mouse.svg");
    animals[2] = loadShape("images/catCyborg.svg");
    
    initializeRound();
  }
  
  public boolean newAnimal()
  {
    framesOfAnimal = PApplet.parseInt(random(secondsOfAnimalMin, secondsOfAnimalMax)*frameRate);
    framesOfAnimalPassed = 0;
        
    if(random(0,1) < 0.7f) {
      animalType = PApplet.parseInt(random(0,numberOfAnimals));
      animalPosition = PApplet.parseInt(random(0,numberOfHoles));
    }
    else
      animalType = -1;
      
    return true;
  }
  
  public boolean initializeRound()
  {
    return newAnimal();
  }  
  
   
  public boolean checkSolution()
  {
    return (animalType == 0);
  }
  
  public void drawHoles()
  {
    ellipseMode(CENTER);
    fill(0);
    for(int i=0; i<numberOfHoles; i++)
      ellipse(holePositionsX[i], holePositionY, holeSize, holeSize);
  }
  
  public void drawAnimal()
  {
    shapeMode(CENTER);
    if (animalType != -1)
      shape(animals[animalType],holePositionsX[animalPosition],holePositionY,holeSize,holeSize);
  
  }
    
  public boolean drawCurrentRound()
  {
    framesOfAnimalPassed++;
    if(framesOfAnimalPassed > framesOfAnimal)
        newAnimal();
    
    drawHoles();
    drawAnimal();
    return true;
  }
  
}
class HittingObjects extends Game
{
  boolean hidden;

  public float increment1, increment2;
  RShape object1, object2;
  int c1, c2;
  Colors c = new Colors();

  
  public boolean initializeRound()
  {
    increment1 = random(3, 5);
    increment2 = random(3, 5);
    object1 = createRandomShape(random(0.05f*width, 0.12f*width));
    object2 = createRandomShape(random(0.65f*width, 0.75f*width));
    c1 = c.getRandomColor();
    c2 = c.getRandomColor();
    
    return true;
  }

  public RShape createRandomShape(float x)
  {
    float imageWidth = 0.1f*width;
    float imageHeight = 0.1f*width;
    RShape object;
    switch((int)random(0, 5))
    {
      case 0:
        object = RShape.createEllipse(x, width*0.2f, imageWidth, imageHeight);
        break;
      case 1:
        object = RShape.createRectangle(x, width*0.2f, imageWidth, imageHeight);
        break;
      case 2:
        object = RShape.createStar(x, width*0.2f, imageWidth, imageWidth, 8);
        break;
      case 3:
        object = RShape.createStar(x, width*0.2f, imageWidth, imageWidth, 5);
        break;
      case 4:
        object = RShape.createStar(x, width*0.2f, imageWidth, imageWidth, 6);
        break;
      default:
        object = RShape.createRectangle(x, width*0.2f, imageWidth, imageWidth);
    }
    return object;
  }
  

  public HittingObjects(int numberOfRounds, int numberOfPlayers, boolean hidden)
  {
    super("HittingObjects Game", Quickly.GetString("ObjectsHelp"), 5, numberOfRounds+1, numberOfPlayers);
    this.hidden = hidden;
    initializeRound();
  }

  public boolean checkSolution()
  {
    if(object2.intersects(object1))
      return true;
      
    return false;
  }
  
  /**
   * Draw everything round in game needs.
   * Function is called on every frame durring game after round started
   * and players buttons activated. 
   * @return Boolean true if there was no error, false otherwise.
   */
  public boolean drawCurrentRound()
  {
    boolean visible = false;
    if(object2.getX() - object1.getX() > width*0.3f
            || !hidden)
      visible = true;
    if(visible)
    {
      fill(c1);
      object1.draw();
    }
    object1.translate(increment1, 0);

    if(visible)
    {
      fill(c2);
      object2.draw();
    }
    object2.translate(-increment2, 0);
    return true;
  }

 
}
class MatchCityState extends Game
{
  
  String city;
  String state;
  boolean solution;
  
  int textFontSize = 40;
  
  int numberOfCities;
  String[] cities = {"New York", "London", "Dublin", "Abu Dhabi", "Tokyo", "Los Angeles", "Paris", "Sao Paulo", "Shanghai",
                       "Melbourne", "Singapore", "Mumbai", "Karachi", "Lagos", "Athens", "Baghdad", "Bangkok", "Sinj"};
  String[] states = {"United States", "United Kingdom", "Ireland", "United Arab Emirates", "Japan", "United States", "France", 
                        "Brazil", "China", "Australia", "Singapore", "India", "Pakistan", "Nigeria", "Greece", "Iraq", "Thailand", "Croatia"};
  
  public MatchCityState(int numberOfRounds, int numberOfPlayers)
  {
    super("Match city with state", Quickly.GetString("CityStateHelp"), 4, numberOfRounds, numberOfPlayers);
    initializeRound();
  }
  
  
  public boolean initializeRound()
  {
    int index = PApplet.parseInt(random(0, states.length));
    city = cities[index];
    solution = (random(0,1) < 0.5f);
    if(solution)
      state = states[index];
    else { 
      int newIndex = PApplet.parseInt(random(0, states.length));        
      state = states[newIndex];

      if (newIndex == index) {
        solution = true;
      }
    }
    
    return true;
  }

  public boolean drawCurrentRound()
  {
    Drawer drawer = new Drawer();
    drawer.drawText(city, textFontSize, 0, width/2, height/2);
    drawer.drawText(state, textFontSize, 0, width/2, height/2 + textFontSize);
    return true;
  }
  
  public boolean checkSolution() {
    return solution;
  }

  
}
class MatchColorText extends Game
{
  
  int color1;
  String word1;
  int color2;
  String word2;
  boolean solution;
  int textFontSize = 40;
  Colors c = new Colors();

  
  public MatchColorText(int numberOfRounds, int numberOfPlayers)
  {
    super("Match color and text", Quickly.GetString("ColorTextHelp"), 6, numberOfRounds, numberOfPlayers);
    initializeRound();
  }
  
  
  public boolean initializeRound()
  {
    int index1 = PApplet.parseInt(random(0,c.numberOfColors));
    int index2 = PApplet.parseInt(random(0,c.numberOfColors));
    int index3 = PApplet.parseInt(random(0,c.numberOfColors));
    
    color1 = c.myColors[index1];
    color2 = c.myColors[index2];
    word1 = c.names[index3];
    
    solution = (random(0,1) < 0.5f);
    if(solution) {
      word2 = c.names[index1];
    }
    else { 
      int newIndex = PApplet.parseInt(random(0,c.numberOfColors));        
      word2 = c.names[newIndex];

      if (newIndex == index1) {
        solution = true;
      }
    }
    
    return true;
  }

  public boolean drawCurrentRound()
  {
    Drawer drawer = new Drawer();
    drawer.drawTextByColor(word1, textFontSize, color1, width/2, height/2);
    drawer.drawTextByColor(word2, textFontSize, color2, width/2, height/2 + textFontSize);
    return true;
  }
  
  public boolean checkSolution() {
    return solution;
  }

  
}
class MatchStatesByPopulation extends Game
{
  
  String text;
  boolean solution;
  
  int textFontSize = 40;
  
  int numberOfCities;
  int[] populations = {325207, 65110, 4757, 9856, 126920, 66842, 206865, 1380570, 24306, 5607, 1309600, 195165, 186988, 10858, 36787, 68145, 4190};
  String[] states = {"United States", "United Kingdom", "Ireland", "United Arab Emirates", "Japan", "France", 
                        "Brazil", "China", "Australia", "Singapore", "India", "Pakistan", "Nigeria", "Greece", "Iraq", "Thailand", "Croatia"};
  
  public MatchStatesByPopulation(int numberOfRounds, int numberOfPlayers)
  {
    super("Match states by population", Quickly.GetString("StatePopulationHelp"), 4, numberOfRounds, numberOfPlayers);
    initializeRound();
  }
  
  
  public boolean initializeRound()
  {
    int index1 = PApplet.parseInt(random(0, states.length));
    
    int index2 = PApplet.parseInt(random(0, states.length));
    while (index1 == index2)
      index2 = PApplet.parseInt(random(0, states.length));
    
    solution = (populations[index1] > populations[index2]);
    text = states[index1] + " > " + states[index2];
    
    return true;
  }

  public boolean drawCurrentRound()
  {
    Drawer drawer = new Drawer();
    drawer.drawText(text, textFontSize, 0, width/2, height/2);

    return true;
  }
  
  public boolean checkSolution() {
    return solution;
  }

  
}
class Player
{
  int myKey;
  String name;
  int score;
  
  public Player(String name, int myKey)
  {
    this.myKey = myKey;
    this.name = name;
    score = 0;
  }
  
  
  
}
class PlusMinus extends Game
{
  
  final float secondsBeforeMorePlusMin = 0.3f;
  final float secondsBeforeMorePlusMax = 0.7f;
  
  int framesOfPlus;
  int framesOfPlusPassed;

  
  final int numberOfRows = 15;
  final int numberOfColumns = 20;
  
  int imageSize;
  float tableX, tableY;
  
  PShape[] signs; 
  boolean[][] array;
  
  int numberOfPlus;
  boolean solution;
  
  
  public PlusMinus(int numberOfRounds, int numberOfPlayers)
  {
    super("More plus than minus", Quickly.GetString("PlusMinusHelp"), 8, numberOfRounds, numberOfPlayers);
    
    signs = new PShape[2];
    signs[0] = loadShape("images/minus.svg");
    signs[1] = loadShape("images/plus.svg");
    
    array = new boolean[numberOfRows][numberOfColumns];
   
    imageSize = min((width-400)/numberOfColumns, (height-600)/numberOfRows);
   
    tableX = width*0.95f/2 - (numberOfColumns*imageSize)/2;
    tableY = height/7 + 100;
    initializeRound();
  }
  
  public boolean morePlus()
  {
    framesOfPlus = PApplet.parseInt(random(secondsBeforeMorePlusMin, secondsBeforeMorePlusMax)*frameRate);
    framesOfPlusPassed = 0;
    
    float randomPlus = random(0.2f,0.4f);
    for(int i=0; i<numberOfRows; i++)
      for(int j=0; j<numberOfColumns; j++) {
        if(random(0,1) < randomPlus && array[i][j] == false) {
          array[i][j] = true;
          numberOfPlus++;
        }
        if(random(0,1) < 0.2f && array[i][j] == true) {
          array[i][j] = false;
          numberOfPlus--;
        }
      
      }

        
    if(numberOfPlus > numberOfRows*numberOfColumns/2)
      solution = true;
    
    return true;
  }
  
  
  public boolean initializeRound()
  {
    solution = false;
    numberOfPlus = 0;
    for(int i=0; i<numberOfRows; i++)
      for(int j=0; j<numberOfColumns; j++)
        array[i][j] = false;

    return morePlus();
  }
    
  public boolean checkSolution()
  {
    return solution;
  }
  
  public boolean drawCurrentRound()
  {
    framesOfPlusPassed++;
    if(framesOfPlusPassed > framesOfPlus)
      morePlus();
      
    for(int i = 0; i < numberOfRows; ++i)
      for(int j = 0; j < numberOfColumns; ++j)
      {
        if(array[i][j])
          shape(signs[1], tableX + j * imageSize, tableY + i *imageSize, imageSize, imageSize);
        else
          shape(signs[0], tableX + j * imageSize, tableY + i *imageSize, imageSize, imageSize);
      }
  
    return true;
  }
  
  
  
}




/**
 * Class loader used only to load resources in typical Processing setup.
 * Default class loaders look in class path, ie. Processing libs and where the class files are,
 * typically in a randomly named build folder in system's temp dir.
 * This class loader looks in the sketch's data folder instead, because that's where
 * they are likely to be put and will be kept in an export.
 */
public class ProcessingClassLoader extends ClassLoader
{
  private PApplet m_pa;

  public ProcessingClassLoader(PApplet pa)
  {
    super();
    m_pa = pa;
  }

  @Override
  public URL getResource(String name)
  {
    String textURL = "file:///" + m_pa.dataPath(name);
    println("getResource " + textURL);
    URL url = null;
    try
    {
      url = new URL(textURL);
    }
    catch (java.net.MalformedURLException e)
    {
      System.out.println("ProcessingClassLoader - Incorrect URL: " + textURL);
    }
    return url;
  }

  // Not necessary, mostly there to see if it is used...
  /*
  @Override
  public Class loadClass(String name, boolean resolve)
  throws ClassNotFoundException
  {
    System.out.println("loadClass: " + name);
    return findSystemClass(name);
  }
  */
}
 
class SadFace extends Game
{
  int sadFaceTime;
  int sadFacePosition;
  int numberOfRows, numberOfColumns;
  RShape[] happy, sad;
  float[] angles;
  int[] happyType;
  int sadType;
  int imageSize;
  float tableX, tableY;
  int frame = 60;
  
  public SadFace(int numberOfRounds, int numberOfPlayers)
  {
    super("SadFace gama", Quickly.GetString("SadFaceHelp"), 8, numberOfRounds+1, numberOfPlayers);
    numberOfRows = 7;
    numberOfColumns = 7;
    happy = new RShape[4];
    sad = new RShape[4];
    imageSize = min((width-400)/numberOfColumns, (height-600)/numberOfRows);
    happyType = new int[numberOfRows * numberOfColumns];
    for(int i = 0; i < 4; ++i)
    {
      happy[i] = RG.loadShape("images/happy" + i + ".svg");
      sad[i] = RG.loadShape("images/sad" + i + ".svg");
    }
    angles = new float[]{PI/2, -PI/2, PI, 0, 0, 3*PI/2};
    tableX = width*0.95f/2 - (numberOfColumns*imageSize)/2;
    tableY = height/7 + 100;
    initializeRound();
  }
  
  public boolean initializeRound()
  {
    for(int i = 0; i < happyType.length; ++i)
      happyType[i] = (int)random(0, happy.length);
    sadType = (int)random(0, sad.length);
    sadFaceTime = (int)random(1, 6) * frame;
    sadFacePosition = (int)random(0, numberOfRows * numberOfColumns);
    return true;
  }
  
  public void changeFaces()
  {
    for(int i = 0; i < happyType.length; ++i)
      happyType[i] = (int)random(0, happy.length);
    sadType = (int)random(0, sad.length);
  }
  
  public boolean checkSolution()
  {
    if(passedFrames > sadFaceTime && passedFrames < sadFaceTime + frame*2 && roundNumber > 0)
      return true;
    return false;
  }
  
  public boolean drawCurrentRound()
  {
    if(passedFrames % frame == 0)
      changeFaces();
    for(int i = 0; i < numberOfRows; ++i)
      for(int j = 0; j < numberOfColumns; ++j)
      {
        if(passedFrames > sadFaceTime && passedFrames < sadFaceTime + frame*2 &&  sadFacePosition == i * numberOfRows + j)
          RG.shape(sad[sadType], tableX + j * imageSize, tableY + i *imageSize, imageSize, imageSize);
        else
          RG.shape(happy[happyType[i * numberOfRows +j]], tableX + j * imageSize, tableY + i *imageSize, imageSize, imageSize);
      }
    return true;
  }
  
  
  
}
class WhiteScreen extends Game
{
  boolean afterWhiteScreen;
  int numberOfFramesBeforeWhite;
  
  public boolean initializeRound()
  {
    afterWhiteScreen = false;
    numberOfFramesBeforeWhite = PApplet.parseInt(frameRate * random(3,6));
 
    return true;
  }
  
  public WhiteScreen(int numberOfRounds, int numberOfPlayers)
  {
    super("True reaction", Quickly.GetString("WhiteHelp"), 8, numberOfRounds, numberOfPlayers);
    initializeRound();
  }

  public boolean drawCurrentRound()
  {
    
    if(afterWhiteScreen == false && passedFrames > numberOfFramesBeforeWhite)
    {
      //println("usao u if nacrtaj bijeli");
      afterWhiteScreen = true;
    }
        
    if(afterWhiteScreen)
    {
      rectMode(CENTER);
      fill(255, 0, 0);
      rect(width/2, height/2, 0.3f*width, 0.3f*height);
    }
    //delay(1000);
    return true;
  }
  
  public boolean checkSolution() {
    return afterWhiteScreen;
  }

}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Quickly" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
