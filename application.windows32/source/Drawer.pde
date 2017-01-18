class Drawer
{
  PFont myFont;
  
  //constructor creates initial font
  Drawer()
  {
    myFont = createFont("Arial", 16, true);
  }
  
  //method draws text with chosen size, color, position
  void drawText(String text, int fontSize,
                  int fontColor, float centerX, float centerY)
  {
    setFont(fontSize, fontColor);
    textAlign(CENTER);
    text(text, centerX, centerY);
  }
  
   //method draws text with chosen size, color, position
  void drawTextByColor(String text, int fontSize,
                  color fontColor, float centerX, float centerY)
  {
    textFont(myFont, fontSize);
    fill(fontColor);
    textAlign(CENTER);
    text(text, centerX, centerY);
  }
  
  //method changes font size and color
  void setFont(int fontSize, int fontColor)
  {
    textFont(myFont,fontSize);
    fill(fontColor);
  }
  
  PFont getButtonFont(int fontSize)
  {
    textFont(myFont,fontSize);
    return myFont;      
  }
  
  ControlFont getControlFont(int fontSize)
  {
    return new ControlFont(myFont, fontSize);
  }
  
}