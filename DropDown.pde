class DropDown extends GUIElement {
  
  Method changeMethod;
  
  PVector size;
  
  Button mainB;
  ArrayList<Button> entryB = new ArrayList<Button>();
  
  public boolean open = false;
  
  DropDown(float posX, int posY, int sizeX, int sizeY){
    pos = new PVector(posX, posY);
    size = new PVector(sizeX, sizeY);
    mainB = new Button(posX, posY, sizeX, sizeY, "")
      .setEventUp("pressed", this)
      .setEventHoverOrDown("hover")
      .setEventNothing("notHover");
  }
  
  public DropDown setContent(String[] c){
    
    for(int i = 0; i < c.length; i++){
      addContent(c[i]);
    }
    
    return this;
  }
  
  public DropDown setEventChange(String m){
    try{
      changeMethod = SenarioLoader.p.getClass().getMethod(m, Integer.class);
    }
    catch(Exception e){
      println(e);
    }
    
    return this;
  }
  
  public void draw(){
    mainB.draw();
    if(open){
      for(Button b : entryB){
        b.draw();
      }
    }
  }
  public void update(){
    mainB.update();
    if(open){
      for(Button b : entryB){
        b.update();
      }
    }
  }
  
  public DropDown addContent(String c){
    entryB.add(new Button(pos.x, (entryB.size()+1) * (size.y+1) + pos.y +1, size.x, size.y, c)
      .setEventHoverOrDown("hover")
      .setEventNothing("notHover")
      .setEventUp("pressed", this)
      .setID(entryB.size()+1));
    
    return this;
  }
  
  public void pressed(Integer id, Integer state){
    if(id == 0){
      open = !open;
    }
    else{
      mainB.text = entryB.get(id-1).text;
      open = false;
      call(changeMethod, id-1);
    }
  }
  
  private void call(Method m, int id)
  {
    if(m != null) {
      try {
        m.invoke(SenarioLoader.p, id);
      }
      catch(InvocationTargetException e){
        println(e.getCause());
      }
      catch(Exception e) {
        println(e, "DropDown");
        return;
      }
    }
  }
}
