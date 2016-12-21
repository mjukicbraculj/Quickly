class Equation extends Game
{
  int fontSize = 30;
  int roundNumber;
  boolean gameOver;
  boolean startPlaying;
  int passedFrames;
  int numberOfFramesBeforeEndRound;
  
  String[] operations;
  int[] firstNumbers;
  int[] secondNumbers;
  int[] results;
  boolean[] solutions;
  
  public void initializeEquations()
  {
    operations = new String[numberOfRounds];
    firstNumbers = new int[numberOfRounds];
    secondNumbers = new int[numberOfRounds];
    results = new int[numberOfRounds];
    solutions = new boolean[numberOfRounds];
    int range = 4;
    for (int i=0; i<numberOfRounds; i++)
    {
      if(i%3 == 0)
      {
        operations[i] = "+";
        firstNumbers[i] = int(random(3,47));
        secondNumbers[i] = int(random(3,48));
        if(random(0,1) > 0.5)
          results[i] = firstNumbers[i] + secondNumbers[i];
        else
        results[i] = int(random(firstNumbers[i] + secondNumbers[i] + range, firstNumbers[i] + secondNumbers[i] + range));
        solutions[i] = (firstNumbers[i] + secondNumbers[i] == results[i]);
      }
      else if(i%3 == 1)
      {
        operations[i] = "-";
        firstNumbers[i] = int(random(3,47));
        secondNumbers[i] = int(random(3,48));
        if(random(0,1) > 0.5)
          results[i] = firstNumbers[i] - secondNumbers[i];
        else
          results[i] = int(random(firstNumbers[i] - secondNumbers[i] + range, firstNumbers[i] - secondNumbers[i] + range));
        solutions[i] = (firstNumbers[i] - secondNumbers[i] == results[i]);
      }
      else if(i%3 == 2)
      {
        operations[i] = "*";
        firstNumbers[i] = int(random(3,13));
        secondNumbers[i] = int(random(3,13));
        if(random(0,1) > 0.5)
          results[i] = firstNumbers[i] * secondNumbers[i];
        else
          results[i] = int(random(firstNumbers[i] * secondNumbers[i] + range, firstNumbers[i] * secondNumbers[i] + range));
        solutions[i] = (firstNumbers[i] * secondNumbers[i] == results[i]);
      }
      
     }
  }
  
  public Equation(int numberOfRounds, int numberOfPlayers)
  {
    super(numberOfRounds, numberOfPlayers);
    roundNumber = 0;
    gameOver = false;
    startPlaying = false;
    passedFrames = 0;
    numberOfFramesBeforeEndRound = int(frameRate * 5);
    initializeEquations();
  }
  
  
  public boolean endRound()
  {
    startPlaying = false;
    passedFrames = 0;
    roundNumber++;
    if(roundNumber == numberOfRounds)
      gameOver = true;

    return true;
  }
  
  
  public int score(int player)
  {
    // If round hasn't started or is over, or game is over nothing happens.
    if(startPlaying == false || gameOver)
      return 0;
    
    // If round is active and white screen havent appered.
    if(solutions[roundNumber] == false)
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
  
  public boolean drawEquation()
  {
    String wholeEquation;
    Drawer drawer = new Drawer();     
    wholeEquation = str(firstNumbers[roundNumber]) + operations[roundNumber] + str(secondNumbers[roundNumber]) + " = " + str(results[roundNumber]);
    drawer.drawText(wholeEquation, fontSize, 0, width/2, height/2);
    return true;
  }

  public boolean drawState()
  {
    passedFrames++;
    
    if(passedFrames > numberOfFramesBeforeEndRound)
      return endRound();
    
    if(gameOver)
      return false;
      
    if(passedFrames > 30 && startPlaying == false)
      startPlaying = true;    
    
    
    if(startPlaying)
      return drawEquation();
    
    
    return true;
  }
  

  
  public boolean endOfGame()
  {
    return gameOver;
  }  
  
}