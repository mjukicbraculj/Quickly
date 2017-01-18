class Colors
{
  color[] myColors;
  String[] names;
  int numberOfColors = 10;
  
  Colors()
  {
    myColors = new color[numberOfColors];
    names = new String[numberOfColors];
    
    myColors[0] = color(255, 0, 0);
    myColors[1] = color(0, 255, 0);
    myColors[2] = color(0, 0, 255);
    myColors[3] = color(0,0,0);
    myColors[4] = color(255, 255, 255);
    myColors[5] = color(255, 255, 51);
    myColors[6] = color(128, 0, 128);
    myColors[7] = color(255, 165, 0);
    myColors[8] = color(255, 192, 203);
    myColors[9] = color(165, 42, 42);
    
    names[0] = "red";
    names[1] = "green";
    names[2] = "blue";
    names[3] = "black";
    names[4] = "white";
    names[5] = "yellow";
    names[6] = "pruple";
    names[7] = "orange";
    names[8] = "pink";
    names[9] = "brown";
   
  }
  
  public color getRandomColor()
  {
    return myColors[(int)random(0, numberOfColors)];
  }
}