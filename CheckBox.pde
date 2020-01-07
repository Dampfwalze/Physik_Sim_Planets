class CheckBox extends GUIElement {
  
  Button b;
  
  public String text;
  
  public boolean checked = false;
  
  CheckBox(int posX, int posY, String text){
    pos = new PVector(posX, posY);
    b = new Button(posX, posY, 15, 15, "")
      .setEventUp("pressed", this);
    
    this.text = text;
  }
  
  public void draw(){
    b.draw();
    GUI.textAlign(LEFT, CENTER);
    GUI.textSize(15);
    GUI.fill(255);
    GUI.text(text, pos.x + 20, pos.y +5);
    if(checked){
      GUI.image(checkboxTex, pos.x+2, pos.y-5);
    }
  }
  
  public void update() {
    b.update();
  }
  
  public void pressed(Integer id, Integer state){
    checked = !checked;
  }
}
