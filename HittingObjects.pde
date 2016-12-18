class HittingObjects
{
  int resourcesNum;
  int iterationNum;
  int currentIteration;
  Iteration[] iterations;
  boolean gameOver;
  String gameName;
  float imageWidth, imageHeight;

  class Iteration
  {
    public int start1, start2,  increment1, increment2;
    public int score;
    PShape object1, object2;
    
    public Iteration(int object1, int object2, int start1, int start2, int increment1, int increment2, int score)
    {
      this.object1 = loadShape("images/HittingObjects/resource"+object1+".svg");
      this.object2 = loadShape("images/HittingObjects/resource"+object2+".svg");
      this.start1 = start1;
      this.start2 = start2;
      this.increment1 = increment1;
      this.increment2 = increment2;
      this.score = score;
    }
  }
  
  public HittingObjects()
  {
    gameOver = false;
    resourcesNum = 10;
    iterationNum = 5;
    iterations = new Iteration[iterationNum];
    for(int i = 0; i < iterationNum; ++i)
      iterations[i] = new Iteration((int)random(0, resourcesNum), (int)random(0, resourcesNum), 
                                        (int)random(0.05*width, 0.12*width), (int)random(0.65*width, 0.75*width), 
                                          (int)random(3, 5), (int)random(3, 5), 1);
    currentIteration = 0;
    gameName = "HittingObjecs";
    imageWidth = 0.1*width;
    imageHeight = 0.1*width;
  }
  
  public void drawState()
  {
    shape(iterations[currentIteration].object1, iterations[currentIteration].start1,0.2*height, imageWidth, imageHeight);
    shape(iterations[currentIteration].object2, iterations[currentIteration].start2, 0.2*height,  imageWidth, imageHeight); 
    if(iterations[currentIteration].start1  > iterations[currentIteration].start2)
    {
      currentIteration++;
      if(currentIteration > 4)
        gameOver = true;
    }
    else
    {
      iterations[currentIteration].start1 += iterations[currentIteration].increment1;
      iterations[currentIteration].start2 -= iterations[currentIteration].increment2;
    }
    
  }
  
  public boolean endOfGame()
  {
    return gameOver;
  }
  
  //returns 1 if right timing
  //returns -1 if it's not
  //returns 0 if someone was faser and won in current iteration 
  //or when new iteration is just started
  public int score()
  {
    if(iterations[currentIteration].start1 + imageHeight > iterations[currentIteration].start2)
    {
      int tmp = iterations[currentIteration].score;
      iterations[currentIteration].score = 0;
      return tmp;
    }
    else if(iterations[currentIteration].start1 < iterations[currentIteration].start2 - 0.5 * width)
      return 0;
    else 
      return -1;
  }
}