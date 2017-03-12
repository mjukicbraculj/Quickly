class ImageButton extends GUIElement{
  
  PImage backgroudImage;

  public ImageButton(String name){
    super(name);
  }

  public void show(){
    if(isVisible){
      fill(backgroundColor);
      image(backgroudImage, x, y);
      fill(fontColor);
      textAlign(CENTER);
      textFont(textFont, fontSize);
      text(text, x + width/2, y + height/2);
    }
  }
  
  public ImageButton setImage(PImage image){
    backgroudImage = image;
    return this;
  }
  
  
}