class MatchCityState extends Game
{
  
  String city;
  String state;
  boolean solution;
  
  int textFontSize = 40;
  
  int numberOfCities;
  String[] cities = {"New York", "London", "Dublin", "Abu Dhabi", "Tokyo", "Los Angeles", "Paris", "Sao Paulo", "Shanghai",
                       "Melbourne", "Singapore", "Mumbai", "Karachi", "Lagos", "Athens", "Baghdad", "Bangkok", "Sinj"};
  String[] states = {"United States", "United Kingdom", "Ireland", "United Arab Emirates", "Japan", "United States", "France", 
                        "Brazil", "China", "Australia", "Singapore", "India", "Pakistan", "Nigeria", "Greece", "Iraq", "Thailand", "Croatia"};
  
  public MatchCityState(int numberOfRounds, int numberOfPlayers)
  {
    super("Match city with state", Quickly.GetString("CityStateHelp"), 4, numberOfRounds, numberOfPlayers);
    initializeRound();
  }
  
  
  public boolean initializeRound()
  {
    int index = int(random(0, states.length));
    city = cities[index];
    solution = (random(0,1) < 0.5);
    if(solution)
      state = states[index];
    else { 
      int newIndex = int(random(0, states.length));        
      state = states[newIndex];

      if (newIndex == index) {
        solution = true;
      }
    }
    
    return true;
  }

  public boolean drawCurrentRound()
  {
    Drawer drawer = new Drawer();
    drawer.drawText(city, textFontSize, 0, width/2, height/2);
    drawer.drawText(state, textFontSize, 0, width/2, height/2 + textFontSize);
    return true;
  }
  
  public boolean checkSolution() {
    return solution;
  }

  
}