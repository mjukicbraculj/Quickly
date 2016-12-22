class WhiteScreen extends Game
{
  boolean afterWhiteScreen;
  int numberOfFramesBeforeWhite;
  
  public boolean initializeRound()
  {
    afterWhiteScreen = false;
    numberOfFramesBeforeWhite = int(frameRate * random(3,6));
 
    return true;
  }
  
  public WhiteScreen(int numberOfRounds, int numberOfPlayers)
  {
    super("True reaction", "Click when object appears.", 8, numberOfRounds, numberOfPlayers);
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
      rect(width/2, height/2, 0.3*width, 0.3*height);
    }
    //delay(1000);
    return true;
  }
  
  public boolean checkSolution() {
    return afterWhiteScreen;
  }

}