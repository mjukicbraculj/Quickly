class WhiteScreen extends Game
{
  
  int roundNumber;
  boolean gameOver;
  boolean afterWhiteScreen;
  boolean startPlaying;
  int passedFrames;
  int numberOfFramesBeforeWhite;
  
  public WhiteScreen(int numberOfRounds, int numberOfPlayers)
  {
    super(numberOfRounds, numberOfPlayers);
    roundNumber = 0;
    gameOver = false;
    afterWhiteScreen = false;
    startPlaying = false;
    passedFrames = 0;
    numberOfFramesBeforeWhite = 9999;
  }
  
  
  //TODO: mozda startPlaying je viska, malo razmisliti.
  public int score(int player)
  {
    // If round hasn't started or is over, or game is over nothing happens.
    if(startPlaying == false || gameOver)
      return 0;
    
    // If round is active and white screen havent appered.
    if(afterWhiteScreen == false)
    { 
      scoreForPlayers[player]--;
      return -1;
    }
    
    // If round is active and white screen already appered.
    //println("Stisnuo klik", roundNumber, numberOfRounds);
    startPlaying = false;
    afterWhiteScreen = false;
    passedFrames = 0;
    roundNumber++;
    if(roundNumber == numberOfRounds)
      gameOver = true;
      
    scoreForPlayers[player]++; 
    return 1;
  }
  
  public boolean drawWhiteScreen()
  {
    //TODO: tu mozda jos nesto nacrtati/napisati
    //background(255);
    rectMode(CENTER);
    fill(255, 0, 0);
    rect(width/2, height/2, 0.3*width, 0.3*height);
    //delay(1000);
    return true;
  }

  public boolean drawState()
  {
    passedFrames++;
    //print(" ",passedFrames);
    
    if(gameOver)
      return false;
      
    if(passedFrames > 20 && startPlaying == false)
    {
      numberOfFramesBeforeWhite = int(frameRate * random(3,6));  
      startPlaying = true;
      //println("Usao u if startplaying");
    }
    
    
    if(afterWhiteScreen == false && passedFrames > numberOfFramesBeforeWhite)
    {
      //println("usao u if nacrtaj bijeli");
      afterWhiteScreen = true;      
      
    }
    if(afterWhiteScreen)
    {
      return drawWhiteScreen();
    }
    
    return true;
  }
  

  
  public boolean endOfGame()
  {
    return gameOver;
  }  
  
}