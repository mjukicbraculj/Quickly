class HittingObjects extends Game
{
  int currentIteration;
  Iteration[] iterations;
  boolean gameOver;
  String gameName;
  float imageWidth, imageHeight;
  Colors c;

  class Iteration
  {
    public float increment1, increment2;
    public int score;
    RShape object1, object2;
    color c1, c2;
    
    public Iteration()
    {
      this.increment1 = random(3, 5);
      this.increment2 = random(3, 5);
      this.score = 1;
      this.object1 = createRandomShape(random(0.05*width, 0.12*width));
      this.object2 = createRandomShape(random(0.65*width, 0.75*width));
      c1 = c.getRandomColor();
      c2 = c.getRandomColor();
    }
    
    RShape createRandomShape(float x)
    {
      RShape object;
      switch((int)random(0, 5))
      {
        case 0:
          object = RShape.createEllipse(x, width*0.2, imageWidth, imageHeight);
          break;
        case 1:
          object = RShape.createRectangle(x, width*0.2, imageWidth, imageHeight);
          break;
        case 2:
          object = RShape.createStar(x, width*0.2, imageWidth, imageWidth, 8);
          break;
        case 3:
          object = RShape.createStar(x, width*0.2, imageWidth, imageWidth, 5);
          break;
        case 4:
          object = RShape.createStar(x, width*0.2, imageWidth, imageWidth, 6);
          break;
        default:
          object = RShape.createRectangle(x, width*0.2, imageWidth, imageWidth);
      }
      return object;
    }
  }
  
  public HittingObjects(int numberOfRounds, int numberOfPlayers)
  {
    super(numberOfRounds, numberOfPlayers);
    gameOver = false;
    imageWidth = 0.1*width;
    imageHeight = 0.1*width;
    c = new Colors();
    iterations = new Iteration[numberOfRounds];
    for(int i = 0; i < numberOfRounds; ++i)
      iterations[i] = new Iteration();
    currentIteration = 0;
    gameName = "HittingObjecs";
  }
  
  public boolean drawState()
  {
    fill(iterations[currentIteration].c1); 
    iterations[currentIteration].object1.translate(iterations[currentIteration].increment1, 0);
    iterations[currentIteration].object1.draw();
    fill(iterations[currentIteration].c2); 
    iterations[currentIteration].object2.translate(-iterations[currentIteration].increment2, 0);
    iterations[currentIteration].object2.draw();
    
    if(iterations[currentIteration].object1.getX() - imageWidth > iterations[currentIteration].object2.getX())
    {
      currentIteration++;
      if(currentIteration > numberOfRounds)
        gameOver = true;
    }
    return true;
  }
  
  public boolean endOfGame()
  {
    return gameOver;
  }
  
  //returns 1 if right timing
  //returns -1 if it's not
  //returns 0 if someone was faser and won in current iteration 
  //or when new iteration is just started
  public int score(int player)
  {
    if(iterations[currentIteration].object2.intersects(iterations[currentIteration].object1))
    {
      int tmp = iterations[currentIteration].score;
      iterations[currentIteration].score = 0;
      if(tmp == 1)
        scoreForPlayers[player]++;
      return tmp;
    }
    else if(iterations[currentIteration].object2.getX() - iterations[currentIteration].object1.getX() > 0.5 * width)
      return 0;
    else 
      return -1;
  }
}