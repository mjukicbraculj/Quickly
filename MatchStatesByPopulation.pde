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
    int index1 = int(random(0, states.length));
    
    int index2 = int(random(0, states.length));
    while (index1 == index2)
      index2 = int(random(0, states.length));
    
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