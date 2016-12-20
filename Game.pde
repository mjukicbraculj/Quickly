abstract class Game
{
  int numberOfRounds;
  int numberOfPlayers;
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

  public abstract int score(int player);
  public abstract boolean endOfGame();
  public abstract boolean drawState();
  
  
}