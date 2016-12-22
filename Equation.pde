class Equation extends Game
{

  int gameFontSize = 25;
  String equation;
  boolean result;

  public boolean initializeRound()
  {

    int firstNumber;
    int secondNumber;
    int solution;
    int range = 4;

    // If int is less then 1 we make addition equation, between 1 and 2 subtraction,
    // and more then 2 multiplication.
    float operation = random(0,3);

    if(operation < 1)
    {
      firstNumber = int(random(3,47));
      secondNumber = int(random(3,48));
      if(random(0,1) > 0.5)
        solution = firstNumber + secondNumber;
      else
        solution = int(random(firstNumber + secondNumber - range, firstNumber + secondNumber + range));
      result = (firstNumber + secondNumber == solution);
      equation = str(firstNumber) + " + " + str(secondNumber) + " = " + str(solution);
    }
    else if(operation < 2)
    {
      firstNumber = int(random(3,47));
      secondNumber = int(random(3,48));
      if(random(0,1) > 0.5)
        solution = firstNumber - secondNumber;
      else
        solution = int(random(firstNumber - secondNumber - range, firstNumber - secondNumber + range));
      result = (firstNumber - secondNumber == solution);
      equation = str(firstNumber) + " - " + str(secondNumber) + " = " + str(solution);
    }
    else
    {
      firstNumber = int(random(3,13));
      secondNumber = int(random(3,13));
      if(random(0,1) > 0.5)
        solution = firstNumber * secondNumber;
      else
        solution = int(random(firstNumber * secondNumber - range, firstNumber * secondNumber + range));
      result = (firstNumber * secondNumber == solution);
      equation = str(firstNumber) + " * " + str(secondNumber) + " = " + str(solution);
    }

    return true;

  }

  public Equation(int numberOfRounds, int numberOfPlayers)
  {
    super("Equation", "Click if given equation is true.", 5, numberOfRounds, numberOfPlayers);
  }

  public boolean checkSolution()
  {
    return result;
  }


  public boolean drawCurrentRound()
  {
    Drawer drawer = new Drawer();
    drawer.drawText(equation, gameFontSize, 0, width/2, height/2);
    return true;
  }

}