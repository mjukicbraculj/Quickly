class Button extends GUIElement{
  
  

  public Button(String name){
    super(name);
  }

  public void show(){
    if(isVisible){
      if(backgroundImage != null)
        image(backgroundImage, x, y);
      else{
        fill(backgroundColor);
        rectMode(CORNER);
        rect(x, y, width, height);
      }
      fill(fontColor);
      textAlign(CENTER, CENTER);
      textFont(textFont, fontSize);
      text(text, x + width/2, y + height/2);
    }
  }
  
  public Button setSize(float width, float height){
    super.setSize(width, height);
    return this;
  }
  
  public Button setPosition(float x, float y){
    super.setPosition(x, y);
    return this;
  }
  
  public Button setImage(PImage image){
    super.setImage(image);
    return this;
  }
  
  public Button setVisible(boolean visible){
    super.setVisible(visible);
    return this;
  }
  
  public Button setText(String text){
    super.setText(text);
    return this;
  }
  
  
  
}