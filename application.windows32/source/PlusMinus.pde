class PlusMinus extends Game
{
  
  final float secondsBeforeMorePlusMin = 0.3;
  final float secondsBeforeMorePlusMax = 0.7;
  
  int framesOfPlus;
  int framesOfPlusPassed;

  
  final int numberOfRows = 15;
  final int numberOfColumns = 20;
  
  int imageSize;
  float tableX, tableY;
  
  PShape[] signs; 
  boolean[][] array;
  
  int numberOfPlus;
  boolean solution;
  
  
  public PlusMinus(int numberOfRounds, int numberOfPlayers)
  {
    super("More plus than minus", Quickly.GetString("PlusMinusHelp"), 8, numberOfRounds, numberOfPlayers);
    
    signs = new PShape[2];
    signs[0] = loadShape("images/minus.svg");
    signs[1] = loadShape("images/plus.svg");
    
    array = new boolean[numberOfRows][numberOfColumns];
   
    imageSize = min((width-400)/numberOfColumns, (height-600)/numberOfRows);
   
    tableX = width*0.95/2 - (numberOfColumns*imageSize)/2;
    tableY = height/7 + 100;
    initializeRound();
  }
  
  public boolean morePlus()
  {
    framesOfPlus = int(random(secondsBeforeMorePlusMin, secondsBeforeMorePlusMax)*frameRate);
    framesOfPlusPassed = 0;
    
    float randomPlus = random(0.2,0.4);
    for(int i=0; i<numberOfRows; i++)
      for(int j=0; j<numberOfColumns; j++) {
        if(random(0,1) < randomPlus && array[i][j] == false) {
          array[i][j] = true;
          numberOfPlus++;
        }
        if(random(0,1) < 0.2 && array[i][j] == true) {
          array[i][j] = false;
          numberOfPlus--;
        }
      
      }

        
    if(numberOfPlus > numberOfRows*numberOfColumns/2)
      solution = true;
    
    return true;
  }
  
  
  public boolean initializeRound()
  {
    solution = false;
    numberOfPlus = 0;
    for(int i=0; i<numberOfRows; i++)
      for(int j=0; j<numberOfColumns; j++)
        array[i][j] = false;

    return morePlus();
  }
    
  public boolean checkSolution()
  {
    return solution;
  }
  
  public boolean drawCurrentRound()
  {
    framesOfPlusPassed++;
    if(framesOfPlusPassed > framesOfPlus)
      morePlus();
      
    for(int i = 0; i < numberOfRows; ++i)
      for(int j = 0; j < numberOfColumns; ++j)
      {
        if(array[i][j])
          shape(signs[1], tableX + j * imageSize, tableY + i *imageSize, imageSize, imageSize);
        else
          shape(signs[0], tableX + j * imageSize, tableY + i *imageSize, imageSize, imageSize);
      }
  
    return true;
  }
  
  
  
}