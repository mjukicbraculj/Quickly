/**
 * Abstraction for creating games. Each game that want to inherite this class
 * needs to implemet 3 functions characteristic for those games.
 * This class take care of waiting before round starts, end round and
 * users clicks.
 */
abstract class TrueFalseAbstract extends Game
{

  int numberOfSecondsPerRound;
  int numberOfFramesPerRound;
  int numberOfFramesBeforeStart = 30;


  public abstract boolean initializeRound();
  public abstract boolean checkSolution();
  public abstract boolean drawCurrentRound();

  public TrueFalseAbstract(String gameName, String helpMessage, int numberOfSecondsPerRound, int numberOfRounds, int numberOfPlayers)
  {
    super(gameName, helpMessage, numberOfRounds, numberOfPlayers);
    roundNumber = 0;
    gameOver = false;
    startPlaying = false;
    passedFrames = 0;
    numberOfFramesPerRound = int(frameRate * numberOfSecondsPerRound);
    initializeRound();
  }


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


}