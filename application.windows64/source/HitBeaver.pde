class HitBeaver extends Game
{
  PShape[] animals;
  
  float secondsOfAnimalMin = 1;
  float secondsOfAnimalMax = 2;
  
  final int numberOfAnimals = 3;
  final int numberOfHoles = 3;
  int holePositionsX[];
  int holePositionY;
  int holeSize;
  
  int framesOfAnimal;
  int animalPosition;
  // 0 if animal is beaver, else >0 .
  int animalType;
  int framesOfAnimalPassed;

  int imageSize;
  
  boolean solution;
  
  
  public HitBeaver(int numberOfRounds, int numberOfPlayers)
  {
    super("Hit beaver", Quickly.GetString("BeaverHeplp"), 8, numberOfRounds, numberOfPlayers);
    
    holeSize = int((min(width, height)*0.9-(numberOfHoles+1)*50)/numberOfHoles);

    int betweenHoles = 50;
    int startEnd = (width - holeSize*(numberOfHoles-1) - betweenHoles*numberOfHoles)/2;
    int holeBetweenHole = betweenHoles + holeSize;
    
    holePositionY = height/2;
    holePositionsX = new int[numberOfHoles];
    for(int i=0; i<numberOfHoles; i++)
      holePositionsX[i] = i*holeBetweenHole + startEnd;
      
    animals = new PShape[numberOfAnimals];
    animals[0] = loadShape("images/beaver.svg");
    animals[1] = loadShape("images/mouse.svg");
    animals[2] = loadShape("images/catCyborg.svg");
    
    initializeRound();
  }
  
  public boolean newAnimal()
  {
    framesOfAnimal = int(random(secondsOfAnimalMin, secondsOfAnimalMax)*frameRate);
    framesOfAnimalPassed = 0;
        
    if(random(0,1) < 0.7) {
      animalType = int(random(0,numberOfAnimals));
      animalPosition = int(random(0,numberOfHoles));
    }
    else
      animalType = -1;
      
    return true;
  }
  
  public boolean initializeRound()
  {
    return newAnimal();
  }  
  
   
  public boolean checkSolution()
  {
    return (animalType == 0);
  }
  
  public void drawHoles()
  {
    ellipseMode(CENTER);
    fill(0);
    for(int i=0; i<numberOfHoles; i++)
      ellipse(holePositionsX[i], holePositionY, holeSize, holeSize);
  }
  
  public void drawAnimal()
  {
    shapeMode(CENTER);
    if (animalType != -1)
      shape(animals[animalType],holePositionsX[animalPosition],holePositionY,holeSize,holeSize);
  
  }
    
  public boolean drawCurrentRound()
  {
    framesOfAnimalPassed++;
    if(framesOfAnimalPassed > framesOfAnimal)
        newAnimal();
    
    drawHoles();
    drawAnimal();
    return true;
  }
  
}