class Colors
{
  color[] myColors;
  
  Colors()
  {
    myColors = new color[10];
    myColors[0] = color(255, 0, 0);
    myColors[1] = color(0, 255, 0);
    myColors[2] = color(0, 0, 255);
    myColors[3] = color(255, 51, 255);
    myColors[4] = color(51, 255, 255);
    myColors[5] = color(51, 255, 255);
    myColors[6] = color(153, 255, 51);
    myColors[7] = color(102, 102, 0);
    myColors[8] = color(102, 0, 102);
    myColors[9] = color(255, 153, 153);
  }
  
  public color getRandomColor()
  {
    return myColors[(int)random(0, myColors.length)];
  }
}