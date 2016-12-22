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



  public Game(String gameName, String helpMessage, int numberOfRounds, int numberOfPlayers)
  {
    this.gameName = gameName;
    this.helpMessage = helpMessage;
    this.numberOfRounds = numberOfRounds;
    this.numberOfPlayers = numberOfPlayers;
    this.scoreForPlayers = new int[numberOfPlayers];
  }

  public int[] finalScore()
  {
    return scoreForPlayers;
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
   * Calculate if player pressed button on right time,
   * and depending on that return -1,0 or 1.
   * @param player Number of player in list of all players.
   * @return -1 if player clicked button in wrong time,
   *          0 if player clicked button before game started.
   *          1 if player clicked button at right time first.
   */
  public abstract int score(int player);

  /**
   * Draw screen for current game.
   * @return Boolean false if some error happened, else true.
   */
  public abstract boolean drawState();


}
