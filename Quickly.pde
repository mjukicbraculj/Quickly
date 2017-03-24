import geomerative.*;    //library used in HittingObjects game
import java.util.ResourceBundle;
import java.util.PropertyResourceBundle;
import java.util.Locale;
import java.util.Enumeration;

Drawer drawer;        // class for drawing text
GUI controls;    //for adding controls
Button forwardBtn, backBtn, homeBtn, newGameBtn;
//RadioButton gameType;
ArrayList<CheckBox> gameType;
CheckBox loadPlayersFromFile;
TextBox numberOfPlayersTF;
TextBox[] playersNamesAndKeys;    
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
boolean fileForPlayersExist = true;

static Locale locale;
static ResourceBundle res;
String bundleName = "language";
static ResourceBundle readPlayers;
String bundleNamePlayers = "players";

StringDict specialKeys;

char defaultPressingButtons[] = {'Q', 'P', 'Y', 'M', 'A', 'L', 'Z', 'H', 'B', '1', '9'};
int playersKeysCodes[] = {int('Q'), int('P'), int('Y'), int('M'), int('A'), int('L'), int('Z'), int('H'), int('B'), int('1'), int('9')};


void fileWithPlayersExist() 
{
  try {
    readPlayers = ResourceBundle.getBundle(bundleNamePlayers, Locale.getDefault(), new ProcessingClassLoader(this));
  }
  catch(Exception e) {
    fileForPlayersExist = false;
  }
}

void setup()
{
  fullScreen();
  frameRate(60);
  //res = ResourceBundle.getBundle(bundleName, Locale.getDefault(), new ProcessingClassLoader(this));
  res = ResourceBundle.getBundle(bundleName, new Locale("hr"), new ProcessingClassLoader(this));
  fileWithPlayersExist();
  //size(1500, 1000);
  drawer = new Drawer();
  controls = new GUI();
  gameType = new ArrayList<CheckBox>();
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
//called when number of is known
public void createGames()
{
  if(gameType.get(0).isChecked())
    games.add(new Equation(4, numberOfPlayers));
  if(gameType.get(1).isChecked())
    games.add(new HittingObjects(4, numberOfPlayers, false));
  if(gameType.get(2).isChecked())
    games.add(new MatchCityState(4, numberOfPlayers));
  if(gameType.get(3).isChecked())
    games.add(new MatchColorText(4, numberOfPlayers));
  if(gameType.get(4).isChecked())
    games.add(new MatchStatesByPopulation(4, numberOfPlayers));
  if(gameType.get(5).isChecked())
    games.add(new SadFace(4, numberOfPlayers));
  if(gameType.get(6).isChecked())
    games.add(new WhiteScreen(4, numberOfPlayers));
  if(gameType.get(7).isChecked())
    games.add(new HitBeaver(4, numberOfPlayers));
  if(gameType.get(8).isChecked())
    games.add(new PlusMinus(4, numberOfPlayers));
  if(gameType.get(9).isChecked())
    games.add(new FiveDifferent(4, numberOfPlayers));
  
}

void draw()
{
  background(150, 150, 150);
  controls.show();
  if(wellcomeScreen)
  {
    drawHeading();
    if(loadPlayersFromFile.isChecked())
      numberOfPlayersTF.setVisible(false);
    else {
      numberOfPlayersTF.setVisible(true);
      drawer.drawText(GetString("numberOfPlayers"), 25, color(0, 0, 0), width/2, height/2.2);
    }
    drawer.drawText(error, 25, color(255, 0, 0), width/2, height*6/7);
  }
  else if(setupScreen)
  {
    drawer.drawText(GetString("playersName"), 25, color(0, 0, 0), width/2 - 350, height/6);
    drawer.drawText(GetString("gameType"), 25, color(0, 0, 0), width/2 + 350, height/6);
    drawer.drawText(error, 25, color(255, 0, 0), width/2, height*6/7);
  }
  else if(playGameScreen)
  {
    drawer.drawText(games.get(currentGame).helpMessage, 25, color(255, 0, 0), width/2, height/7);
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
                                      20, color(0, 0, 0), width/2, (height/1.4 -height/5)/10*i + height/5);
    endOfGameScreenControls(true);
  }
    
}

//adds buttons, textFields and all other controls...
void addControls()
{
  //controls.setFont(drawer.getControlFont(20));
  forwardBtn = controls.addButton("forward")
                    .setSize(width/15, height/15)
                    .setPosition(width/2 + 400, height/1.3)
                    .setImage(loadImage("images/forward.png"))
                    .setVisible(false);
  backBtn = controls.addButton("back")
                    .setSize(width/15, height/15)
                    .setPosition(width/2 - 500, height/1.3)
                    .setImage(loadImage("images/back.png"))
                    .setVisible(false);  
  
  newGameBtn = controls.addButton(GetString("newGame"))
                       .setSize(width/15, height/15)
                       .setPosition(width/2 - 200 - width/15 , 4*height/5)
                       .setVisible(false)
                       .setText(GetString("newGame"));
  homeBtn = controls.addButton(GetString("home"))
                       .setSize(width/15, height/15)
                       .setPosition(width/2 + 200, 4*height/5)
                       .setVisible(false)
                       .setText(GetString("home"));
  numberOfPlayersTF = controls.addTextBox("")
                               .setSize(width/15, height/20)
                               .setPosition(width/2 - width/30, height/2)
                               .setBackgroundColor(color(255, 255, 255))
                               .setFontColor(color(0, 0, 0))
                               .setVisible(false);
                               
  loadPlayersFromFile = controls.addCheckBox(GetString("LoadPlayersFromFile"));
  loadPlayersFromFile.textPosition = "down";
  loadPlayersFromFile.setSize(width/30, width/30)
                     .setPosition(width/2 - 30, height/1.3)
                     .setVisible(false)
                     .setText(GetString("LoadPlayersFromFile"))
                     .setChecked();
  
  gameType.add(controls.addCheckBox(GetString("Equation")));
  gameType.add(controls.addCheckBox(GetString("Hitting_objects")));
  gameType.add(controls.addCheckBox(GetString("Match_city_state")));
  gameType.add(controls.addCheckBox(GetString("Match_color_text")));
  gameType.add(controls.addCheckBox(GetString("Match_state_by_population")));
  gameType.add(controls.addCheckBox(GetString("Sad_face")));
  gameType.add(controls.addCheckBox(GetString("White_screen")));
  gameType.add(controls.addCheckBox(GetString("Hit_Beaver")));
  gameType.add(controls.addCheckBox(GetString("Plus_and_Minus")));
  gameType.add(controls.addCheckBox(GetString("Five_different")));
  
  for(int i = 0; i < gameType.size(); ++i)
    gameType.get(i).setSize(30, 30)
                   .setPosition(width/2 + 250, height/5 + i * 35)
                   .setVisible(false)
                   .setText(gameType.get(i).getName())
                   .setChecked();
  
  wellcomeScreenControls(true);                             
  
}

//adds textfields for entering players names and keys
void addTextfields()
{
  playersNamesAndKeys = new TextBox[maxPlayersNum*2];
  float pomak = (height/1.4 -height/5)/10;
  for(int i = 0; i < maxPlayersNum*2; i+=2)
  {
    playersNamesAndKeys[i] = controls.addTextBox(GetString("Player")+i/2)
                                     .setSize(width/10, height/30)
                                     .setPosition(width/2 - width/10-400, height/5 + pomak * i / 2)
                                     .setBackgroundColor(color(255, 255, 255))
                                     .setFontColor(color(0, 0, 0))
                                     .setVisible(false)
                                     .setText(GetString("Name")+(i/2+1));
                                     
     playersNamesAndKeys[i+1] = controls.addTextBox("Key"+i)
                                       .setSize(width/10, height/30)
                                       .setPosition(width/2 - 300, height/5 + pomak * i / 2)
                                       .setBackgroundColor(color(255, 255, 255))
                                       .setFontColor(color(0, 0, 0))
                                       .setText(str(defaultPressingButtons[i/2]))
                                       .setVisible(false);
  }
}



//draws images for creating heading
void drawHeading()
{
  /////!!0.95 FIX!!why!
  float startPosition = (width - 6 * headingImg[0].width / 1.5 - headingImg[0].width) / 2;
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
//void controlEvent(ControlEvent theEvent)
//{
//  if(theEvent.getName().equals("forward"))
//    forwardBtnClick();
//  else if(theEvent.getName().equals("back"))
//    backBtnClick();
//  else if(theEvent.getName().equals(GetString("home")))
//    homeBtnClick();
//  else if(theEvent.getName().equals(GetString("newGame")))
//    newGameBtnClick();
//}

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
  if(fileForPlayersExist)
    loadPlayersFromFile.setVisible(visible);
  else
    loadPlayersFromFile.isChecked = false;
  //gameType.setVisible(visible);
  //if(!visible)
  //{
  //  forwardBtn.hide();
  //  backBtn.hide();
  //}
}

public void setupScreenControls(boolean visible)
{
  for(int i = 0; i < numberOfPlayers*2; ++i)
    playersNamesAndKeys[i].setVisible(visible);
  forwardBtn.setVisible(visible);
  backBtn.setVisible(visible); 
  for(int i = 0; i < gameType.size(); ++i)
    gameType.get(i).setVisible(visible);
}

public void endOfGameScreenControls(boolean visible)
{
  homeBtn.setVisible(visible);
  newGameBtn.setVisible(visible);
}


private boolean readNumberOfPlayers()
{
  try {
    String value = readPlayers.getString("numberOfPlayers");
    numberOfPlayers = Integer.parseInt(value);
  }
  catch (Exception e)
  {
    error = GetString("FilePlayerNumberError");
    return false;
  }
  
  return true;    
}

private String loadPlayerName(int playerNumber)
{
  String value = null;
  try
  {
    value = readPlayers.getString("player" + playerNumber);
  }
  catch (Exception e)
  {
    value = GetString("player")+playerNumber;
  }
  return value; 
}

private String loadPlayerKey(int playerNumber)
{
  String value = null;
  try
  {
    value = readPlayers.getString("button" + playerNumber);
    value = value.toUpperCase();
    if(value.length() > 1)
      value = str(value.charAt(0));
  }
  catch (Exception e)
  {
    value = str(defaultPressingButtons[playerNumber]);
  }
  return value; 
}


private boolean loadPlayers()
{
  if(readNumberOfPlayers() == false)
    return false;
  if(numberOfPlayers < 1 || numberOfPlayers > 10)
  {
    numberOfPlayers = 0;
    error = GetString("intervalError");
    return false;
  }
  players = new Player[numberOfPlayers];
  int playerNumber = 1;
  for(int i = 0; i<numberOfPlayers * 2; i+=2) {
    playersNamesAndKeys[i].setText(loadPlayerName(playerNumber));
    playersNamesAndKeys[i+1].setText(loadPlayerKey(playerNumber));   
    playerNumber++;
  }    
  
  return true;
}

//method hides first screen and drows second(setup)
//or hides second and drows third(playing)
public void forwardBtnClick()
{
  if(wellcomeScreen)
  {
    if(loadPlayersFromFile.isChecked()) {
      fileWithPlayersExist();
      if(loadPlayers()) {
        error = "";
        wellcomeScreen = false;
        wellcomeScreenControls(false);
        setupScreen = true;
        setPressBtnPositions();
        setupScreenControls(true);
      }
    }
    else {
      try
      {
        numberOfPlayers = Integer.parseInt(numberOfPlayersTF.getText());
        if(numberOfPlayers < 1 || numberOfPlayers > 10)
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
  }
  else
  {
    StringList usedKeys = new StringList();
    for(int i = 0; i < numberOfPlayers; ++i) {
      if(playersNamesAndKeys[i*2+1].getText().equals(""))
       {
         error = GetString("keysError");
         return;
       }
       if(usedKeys.hasValue(playersNamesAndKeys[i*2+1].getText())){
         error = GetString("keyInUse");
         return;
       }
       usedKeys.append(playersNamesAndKeys[i*2+1].getText());
    }
    error = "";
    setupScreen = false;
    setupScreenControls(false);
    createGames();
    playGameScreen = true;
    for(int i = 0; i < numberOfPlayers; i++){
      players[i] = new Player(playersNamesAndKeys[i*2].getText(), int(playersNamesAndKeys[i*2+1].getText().charAt(0)));
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
  pressBtnWidth = (width - (numberOfPlayers+1)*diff)/numberOfPlayers;
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
  GUIElement pressedElement = controls.processClick();
  if(pressedElement != null){
    if(pressedElement.getName().equals("forward"))
      forwardBtnClick();
    else if(pressedElement.getName().equals("back"))
      backBtnClick();
    else if(pressedElement.getName().equals(GetString("home")))
      homeBtnClick();
    else if(pressedElement.getName().equals(GetString("newGame")))
      newGameBtnClick();
    try
    {
      if(pressedElement.getText().substring(0, 2).equals(GetString("Name").substring(0, 2))){
        pressedElement.setText("");
      }
    }
    catch(Exception e){}
  }
  
}

//returns which text filed is in focus
int textFiledInFocus() 
{
    for (int i = 1; i < numberOfPlayers*2; i+=2)
      if (playersNamesAndKeys[i].isFocus(controls))
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
    if(index != -1){
      String keyText = specialKeys.get(Integer.toString(keyCode));
      if(keyText == null)
        keyText = str(key).toUpperCase();      
      playersNamesAndKeys[index].setText(keyText);
      playersKeysCodes[index/2] = keyCode;
      print(index/2 + "dobio " + keyCode);
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
  controls.keyPressed();
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