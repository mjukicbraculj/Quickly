class FiveDifferent extends Game
{
  PImage[] images;
  IntList imagesOnScreen;
  int frame = 60;
  FloatList xPosition;
  FloatList yPosition;
  
  public FiveDifferent(int numberOfRounds, int numberOfPlayers)
  {
    super("FiveDifferent", Quickly.GetString("FiveHelp"), 12, numberOfRounds, numberOfPlayers);
    images = new PImage[6];
    for(int i = 0; i < images.length; ++i)
      images[i] = loadImage("images/image" + i + ".png");
    imagesOnScreen = new IntList();
    xPosition = new FloatList();
    yPosition = new FloatList();
    initializeRound();
  }
  
  public boolean initializeRound()
  {
    imagesOnScreen.clear();
    xPosition.clear();
    yPosition.clear();
    return true;
  }
  
  private void addNewImage()
  {
    imagesOnScreen.append((int)random(0, images.length)); 
    xPosition.append(random(0.2 * width, .8 * width));
    yPosition.append(random(0.3*height, 0.7 * height));
  }
  
  public boolean checkSolution()
  {
    int[] counterOfImages = new int[images.length];
    for(int i = 0; i < counterOfImages.length; ++i)
      counterOfImages[i] = 0;
    for(int i = 0; i < imagesOnScreen.size(); ++i)
    {
      counterOfImages[imagesOnScreen.get(i)]++;
    }
    int positiveNumberOfImagesType = 0;
    for(int i = 0; i < counterOfImages.length; ++i)
      if(counterOfImages[i] > 0)
        positiveNumberOfImagesType++;
    if(positiveNumberOfImagesType > 4)
      return true;
    return false;
  }
  
  public boolean drawCurrentRound()
  {
    if(passedFrames % frame == 0)
      addNewImage();
    for(int i = 0; i < imagesOnScreen.size(); ++i)
      image(images[imagesOnScreen.get(i)], xPosition.get(i), yPosition.get(i), 150, 150);
    return true;
  }
}