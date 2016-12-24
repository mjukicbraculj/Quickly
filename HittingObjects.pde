class HittingObjects extends Game
{
  boolean hidden;

  public float increment1, increment2;
  RShape object1, object2;
  color c1, c2;
  Colors c = new Colors();

  
  public boolean initializeRound()
  {
    increment1 = random(3, 5);
    increment2 = random(3, 5);
    object1 = createRandomShape(random(0.05*width, 0.12*width));
    object2 = createRandomShape(random(0.65*width, 0.75*width));
    c1 = c.getRandomColor();
    c2 = c.getRandomColor();
    
    return true;
  }

  RShape createRandomShape(float x)
  {
    float imageWidth = 0.1*width;
    float imageHeight = 0.1*width;
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
  

  public HittingObjects(int numberOfRounds, int numberOfPlayers, boolean hidden)
  {
    super("HittingObjects Game", "Click when objects collide.", 8, numberOfRounds, numberOfPlayers);
    this.hidden = hidden;
    initializeRound();
  }

  public boolean checkSolution()
  {
    if(object2.intersects(object1))
      return true;
      
    return false;
  }
  
  /**
   * Draw everything round in game needs.
   * Function is called on every frame durring game after round started
   * and players buttons activated. 
   * @return Boolean true if there was no error, false otherwise.
   */
  public boolean drawCurrentRound()
  {
    boolean visible = false;
    if(object2.getX() - object1.getX() > width*0.3
            || !hidden)
      visible = true;
    if(visible)
    {
      fill(c1);
      object1.draw();
    }
    object1.translate(increment1, 0);

    if(visible)
    {
      fill(c2);
      object2.draw();
    }
    object2.translate(-increment2, 0);

    /*rectMode(CENTER);
      fill(255, 0, 0);
      rect(width/2, height/2, 0.3*width, 0.3*height);*/
    return true;
  }

 
}