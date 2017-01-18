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
    images = new PImage[5];
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
    int image0 = 0, image1 = 0, image2 = 0, image3 = 0, image4 = 0;
    for(int i = 0; i < imagesOnScreen.size(); ++i)
    {
      switch(imagesOnScreen.get(i))
      {
        case 0:
          image0++;
          break;
        case 1:
          image1++;
          break;
        case 2: 
          image2++;
          break;
        case 3: 
          image3++;
          break;
        case 4:
          image4++;
          break;
      }
    }
    if(image0 > 0 && image1 > 0 && image2 > 0 && image3 > 0 && image4 > 0)
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