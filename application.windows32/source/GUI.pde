class GUI{

  ArrayList<GUIElement> elements;
  public GUIElement controlInFocus;
  
  public GUI(){
    elements = new ArrayList(); 
  }
  
  public void keyPressed(){
    if(controlInFocus != null){
      if(controlInFocus instanceof TextBox){
        TextBox box = (TextBox)controlInFocus;
        box.setChar(key);
      }
      
    }
  }
  
  public Button addButton(String name){
    Button button = new Button(name);
    elements.add(button);
    return button;
  }
  
  public CheckBox addCheckBox(String name){
    CheckBox checkbox = new CheckBox(name);
    elements.add(checkbox);
    return checkbox;
  }
  
  public TextBox addTextBox(String name){
    TextBox textbox = new TextBox(name);
    elements.add(textbox);
    return textbox;
  }
  public void show(){
    for(int i = 0; i < elements.size(); ++i)
      elements.get(i).show();
  }
  
  public GUIElement processClick(){
    GUIElement element;
    for(int i = 0; i < elements.size(); ++i){
      element = elements.get(i);
      if(element.isPressed()){
        if(element instanceof CheckBox){
          CheckBox box = (CheckBox)element;
          box.setChecked();
        }
        //else if(element instanceof TextBox){
        //  TextBox box = (TextBox)element;
        //  controlInFocus = box;
        //}
        controlInFocus = element;
        return element;
      }
    }
    return null;
  }
  
  
  public GUIElement getElement(String name){
    for(int i = 0; i < elements.size(); ++i)
      if(elements.get(i).name.equals(name))
        return elements.get(i);
    return null;
  }
  
  
  
  

}