class TextBox extends GUIElement{
  
  int numberOfLettersToShow;
  String textToShow = "";
  
  public TextBox(String name){
    super(name);
  }
  
  public void calcNumberOfLettersToShow(){
    textFont(textFont, fontSize);
    float letterWidth = textWidth('a');
    numberOfLettersToShow = int((width - 20)/letterWidth);
    print(numberOfLettersToShow +" " + width + " " + letterWidth);
  }
  
  
  public void show(){
    if(isVisible){
      fill(backgroundColor);
      rect(x, y, width, height);
      fill(fontColor);
      textAlign(CENTER, CENTER);
      textFont(textFont, fontSize);
      text(textToShow, x + width/2, y + height/2);
    }
  
  }
  
  public void setChar(char key){
    if(key == BACKSPACE){
      if(text.length() > 1)
        text = text.substring(0, text.length()-1);
      else
        text = "";
    }
    else if(Character.isDigit(key) || Character.isLetter(key) || key == ' ') //ooor if(key != CODED)
      text += key;
    if(text.length() > numberOfLettersToShow)
      textToShow = text.substring(text.length() - numberOfLettersToShow);
    else
      textToShow = text;
  }
  
  public TextBox setText(String text){
    super.setText(text);
    textToShow = text;
    return this;
  }
  
  public TextBox setSize(float width, float height){
    super.setSize(width, height);
    return this;
  }
  
  public TextBox setPosition(float x, float y){
    super.setPosition(x, y);
    return this;
  }
  
  public TextBox setImage(PImage image){
    super.setImage(image);
    return this;
  }
  
  public TextBox setVisible(boolean visible){
    super.setVisible(visible);
    return this;
  }
  
  public TextBox setBackgroundColor(color c){
    super.setBackgroundColor(c);
    return this;
  }
  
  public TextBox setFontColor(color c){
    super.setFontColor(c);
    return this;
  }
  
  public TextBox setFont(PFont font){
    super.setFont(font);
    return this;
  }
    
}