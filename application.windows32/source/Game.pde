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
    numberOfFramesPerRound = int(frameRate * numberOfSecondsPerRound);
    justStarted = true;
    numberOfFramesForInstructionScreen = int(numberOfSecondsForInstructionScreen * frameRate);
    //initializeRound();
  }
  
  public boolean printInstructions()
  {
    passedFrames++;
    
    Drawer drawer = new Drawer();
    drawer.drawText(Quickly.GetString(helpMessage), 30, color(255, 0, 0), width*0.95/2, height/2);
    
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