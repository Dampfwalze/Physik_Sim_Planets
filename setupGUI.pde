PImage checkboxTex;
SpeedSlider slider;
DropDown dropDown;

void setupGUI() {
  
  checkboxTex = loadImage("data/textures/checkmark.png");
  checkboxTex.resize(20, 20);
  
  {
    Button b = new Button(width-130, height-50, 100, 20, "Reset")
      .setEventHoverOrDown("hover")
      .setEventNothing("notHover")
      .setEventUp("resetSenario", this);
    guiElements.add(b);
  }
  {
    CheckBox b = new CheckBox(30, height-50, "enable test");
    b.b.setEventHoverOrDown("hover");
    b.b.setEventNothing("notHover");
    guiElements.add(b);
  }
  {
    dropDown = new DropDown(30, 50, 150, 20)
      .setEventChange("changeSenario");
    
    if(senarios != null && senarios.length > 0){
      for(String t : senarios){
        dropDown.addContent(t.replace('_', ' ').substring(0, t.lastIndexOf(".")));
      }
      dropDown.mainB.text = dropDown.entryB.get(0).text;
    }
    guiElements.add(dropDown);
  }
  {
    slider = new SpeedSlider();
    guiElements.add(slider);
  }
}

void drawGUI() {
  for(GUIElement e : guiElements){
    e.update();
  }
  for(GUIElement e : guiElements){
    e.draw();
  }
}

void hover(Integer id, Integer state){
  cam.setActive(false);
}

void notHover(Integer id, Integer state){
  cam.setActive(true);
}
