abstract class Game
{
  // Number of iteration each game will be played.
  int numberOfRounds;
  // Number of players playing game, needed for array scoreForPlayer.
  int numberOfPlayers;
  // Number of score each player achieved during game (could be negative).
  int[] scoreForPlayers;

  public Game(int numberOfRounds, int numberOfPlayers)
  {
    this.numberOfRounds = numberOfRounds;
    this.numberOfPlayers = numberOfPlayers;
    this.scoreForPlayers = new int[numberOfPlayers];
  }

  public int[] finalScore()
  {
    return scoreForPlayers;
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
   * Return if game is over including all iterations (rounds).
   * If it returns true new, different game will be started.
   * @return Boolean true if all iterations are finished, else false.
   */
  public abstract boolean endOfGame();
  /**
   * Draw screen for current game.
   * @return Boolean false if some error happened, else true.
   */
  public abstract boolean drawState();


}
