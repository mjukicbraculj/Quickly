abstract class GUIElement{
  String name;
  float x, y;
  String text = "";
  color backgroundColor = color(0 ,34, 99);
  color fontColor = color(255, 255, 255);
  boolean isVisible = true;
  float width, height;
  int fontSize = 22;
  PFont textFont = createFont("Arial", fontSize, true);
  PImage backgroundImage;
  

  
  public GUIElement(String name){
    this.name = name;
  }
  
  public abstract void show();
  
  public GUIElement setPosition(float x, float y){
    this.x = x;
    this.y = y;
    return this;
  }
  
  
  public GUIElement setFontSize(int fontSize){
    this.fontSize = fontSize;
    adjustTextBox();
    return this;
  }
  
  public GUIElement setFont(PFont font){
    textFont = font;
    adjustTextBox();
    return this;
  }
  
  public GUIElement setBackgroundColor(color c){
    backgroundColor = c;
    return this;
  }
  
  public GUIElement setFontColor(color c){
    fontColor = c;
    return this;
  }

  
  public GUIElement setText(String text){
    this.text = text;
    return this;
  }
  
  public String getText(){
    return text;
  }
  

  public GUIElement setSize(float width, float height){
   this.height = height;
   this.width = width;
   adjustTextBox();
   return this;
  }
 
  
  
  public boolean isPressed(){
    if(mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height && isVisible)
      return true;
    return false;
  }
  
  public GUIElement setVisible(boolean visibility){
    isVisible = visibility;
    return this;
  }
  
  
  private void adjustTextBox(){
    if(this instanceof TextBox){
      TextBox box = (TextBox)this;
      box.calcNumberOfLettersToShow();
    }
  }
  
  public GUIElement setImage(PImage image){
    backgroundImage = image;
    return this;
  }
  
  public String getName(){
    return name;
  }
  
  public boolean isFocus(GUI controls){
    if(controls.controlInFocus == this)
      return true;
    return false;
  }

}