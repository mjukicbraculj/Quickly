class MatchColorText extends Game
{
  
  color color1;
  String word1;
  color color2;
  String word2;
  boolean solution;
  int textFontSize = 40;
  Colors c = new Colors();

  
  public MatchColorText(int numberOfRounds, int numberOfPlayers)
  {
    super("Match color and text", Quickly.GetString("ColorTextHelp"), 6, numberOfRounds, numberOfPlayers);
    initializeRound();
  }
  
  
  public boolean initializeRound()
  {
    int index1 = int(random(0,c.numberOfColors));
    int index2 = int(random(0,c.numberOfColors));
    int index3 = int(random(0,c.numberOfColors));
    
    color1 = c.myColors[index1];
    color2 = c.myColors[index2];
    word1 = c.names[index3];
    
    solution = (random(0,1) < 0.5);
    if(solution) {
      word2 = c.names[index1];
    }
    else { 
      int newIndex = int(random(0,c.numberOfColors));        
      word2 = c.names[newIndex];

      if (newIndex == index1) {
        solution = true;
      }
    }
    
    return true;
  }

  public boolean drawCurrentRound()
  {
    Drawer drawer = new Drawer();
    drawer.drawTextByColor(word1, textFontSize, color1, width/2, height/2);
    drawer.drawTextByColor(word2, textFontSize, color2, width/2, height/2 + textFontSize);
    return true;
  }
  
  public boolean checkSolution() {
    return solution;
  }

  
}