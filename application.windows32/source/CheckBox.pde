class CheckBox extends GUIElement {

  color checkedColor = color(0, 255, 0);
  boolean isChecked = false;
  String textPosition = "right";

  public CheckBox(String name) {
    super(name);
  }


  public void setCheckedColor(color c) {
    checkedColor = c;
  }

  public void setChecked() {
    if (isChecked)
      isChecked = false;
    else
      isChecked = true;
  }

  public boolean isChecked() {
    return isChecked;
  }

  public void show() {
    if (isVisible) {
      if (isChecked) {
        fill(checkedColor);
        rect(x, y, width, height);
        line(x, y, x + width, y + height);
        line(x + width, y, x, y + height);
      }
      else {
        fill(backgroundColor);
        rect(x, y, width, height);
      }
      fill(fontColor);
      textFont(textFont, fontSize);
      if (textPosition.equals("down")) {
        textAlign(CENTER, CENTER);
        text(text, x + 20, y + height + 40);
      } else {
        textAlign(LEFT, CENTER);
        text(text, x + width + 20, y + height/2);
      }
    }
  }


  public CheckBox setSize(float width, float height) {
    super.setSize(width, height);
    return this;
  }

  public CheckBox setPosition(float x, float y) {
    super.setPosition(x, y);
    return this;
  }

  public CheckBox setImage(PImage image) {
    super.setImage(image);
    return this;
  }

  public CheckBox setVisible(boolean visible) {
    super.setVisible(visible);
    return this;
  }

  public CheckBox setText(String text) {
    super.setText(text);
    return this;
  }
}