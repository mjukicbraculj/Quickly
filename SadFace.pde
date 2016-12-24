class SadFace extends Game
{
  int sadFaceTime;
  int sadFacePosition;
  int numberOfRows, numberOfColumns;
  RShape[] happy, sad;
  float[] angles;
  int[] happyType;
  int sadType;
  int imageSize;
  float tableX, tableY;
  int frame = 60;
  
  public SadFace(int numberOfRounds, int numberOfPlayers)
  {
    super("SadFace gama", "Click when you see sad face.", 8, numberOfRounds+1, numberOfPlayers);
    numberOfRows = 7;
    numberOfColumns = 7;
    happy = new RShape[4];
    sad = new RShape[4];
    imageSize = min((width-400)/numberOfColumns, (height-600)/numberOfRows);
    happyType = new int[numberOfRows * numberOfColumns];
    for(int i = 0; i < 4; ++i)
    {
      happy[i] = RG.loadShape("images/happy" + i + ".svg");
      sad[i] = RG.loadShape("images/sad" + i + ".svg");
    }
    angles = new float[]{PI/2, -PI/2, PI, 0, 0, 3*PI/2};
    tableX = width*0.95/2 - (numberOfColumns*imageSize)/2;
    tableY = height/7 + 100;
    initializeRound();
  }
  
  public boolean initializeRound()
  {
    for(int i = 0; i < happyType.length; ++i)
      happyType[i] = (int)random(0, happy.length);
    sadType = (int)random(0, sad.length);
    sadFaceTime = (int)random(1, 6) * frame;
    sadFacePosition = (int)random(0, numberOfRows * numberOfColumns);
    return true;
  }
  
  public void changeFaces()
  {
    for(int i = 0; i < happyType.length; ++i)
      happyType[i] = (int)random(0, happy.length);
    sadType = (int)random(0, sad.length);
  }
  
  public boolean checkSolution()
  {
    if(passedFrames > sadFaceTime && passedFrames < sadFaceTime + frame*2 && roundNumber > 0)
      return true;
    return false;
  }
  
  public boolean drawCurrentRound()
  {
    if(roundNumber == 0)
    {
      Drawer drawer = new Drawer();
      drawer.drawText(helpMessage, 30, color(255, 0, 0), width*0.95/2, height/2);
    }
    else
    {
      if(passedFrames % frame == 0)
        changeFaces();
      for(int i = 0; i < numberOfRows; ++i)
        for(int j = 0; j < numberOfColumns; ++j)
        {
          if(passedFrames > sadFaceTime && passedFrames < sadFaceTime + frame*2 &&  sadFacePosition == i * numberOfRows + j)
            RG.shape(sad[sadType], tableX + j * imageSize, tableY + i *imageSize, imageSize, imageSize);
          else
            RG.shape(happy[happyType[i * numberOfRows +j]], tableX + j * imageSize, tableY + i *imageSize, imageSize, imageSize);
        }
    }
    return true;
  }
  
  
  
}