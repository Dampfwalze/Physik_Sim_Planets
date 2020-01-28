class Senario {
  float G_const = 6.673e-11;
  
  ArrayList<PhysiksObject> objects = new ArrayList<PhysiksObject>();
  
  float simSpeed = 1;
  
  public int id;
  
  PhysiksObject lookAt = null;
  
  Senario() {
    
  }
  
  public void update(){
    
    for(int i = 0; i < objects.size()-1; i++){
      for(int j = i+1; j < objects.size(); j++){
        calcGravity(objects.get(i), objects.get(j));
      }
    }
    for(PhysiksObject o : objects){
      o.update(simSpeed, this);
    }
    if(lookAt != null){
      cam.lookAt(lookAt.pos.x, lookAt.pos.y, lookAt.pos.z, cam.getDistance(), (long)0);
      //cam.setActive(true);
    }
  }
  
  public void setup(){
    for(PhysiksObject o : objects){
      o.calcOrbitingObjects(this);
      println(o.orbiting);
    }
  }
  
  public void calcGravity(PhysiksObject o1, PhysiksObject o2){
    float fce = calcGravityForce(o1, o2);
    PVector dir = o1.pos.copy().sub(o2.pos).normalize();
    o2.addForce(dir.copy().mult( fce));
    o1.addForce(dir.copy().mult(-fce));
  }
  
  public float calcGravityForce(PhysiksObject o1, PhysiksObject o2){
    float r = o1.pos.dist(o2.pos) / SenarioLoader.ScaleFactor;
    return G_const * (o1.mass * o2.mass / ((r*r)*SenarioLoader.ScaleFactor));
  }
  
  private boolean prePressed = false;
  public void draw(){
    for(PhysiksObject o : objects){
      o.draw();
    }
    
    
    boolean hover = false;
    for(int i = 0; i < objects.size(); i++){
      
      PhysiksObject o = objects.get(i);
      
      GUI.noStroke();
      if(mouseX < width-440 && mouseX > width-610 &&
        mouseY < (i+1)*60 +30 && mouseY > i*60 +30){
        
        hover = true;
        if(mousePressed){
          GUI.fill(200);
        }
        else {
          if(prePressed != mousePressed){
            lookAt = o;
            //cam.lookAt(o.pos.x, o.pos.y, o.pos.z);
          }
          GUI.fill(100);
        }
        GUI.rect(width-610, i*60 +30, 150, 60);
        
      }
      
      
      //GUI.textFont(font30);
      GUI.textAlign(LEFT, TOP);
      GUI.fill(255);
      GUI.textSize(20);
      GUI.text(o.name + ":", width-600, i*60 +30);
      
      
      GUI.pushMatrix();
      GUI.translate(width-450, i*60 +30);
      drawVector(o.vel.copy().div(SenarioLoader.ScaleFactor), "m/s");
      GUI.translate(0, 30);
      drawVector(o.pos.copy().div(SenarioLoader.ScaleFactor), "m");
      GUI.popMatrix();
    }
    if(hover){
      cam.setActive(false);
    }
    
    prePressed = mousePressed;
  }
  private void drawVector(PVector v, String additional){
    GUI.pushMatrix();
    drawValue(v.x, additional);
    GUI.translate(150, 0);
    drawValue(v.y, additional);
    GUI.translate(150, 0);
    if(v.z != 0)
      drawValue(v.z, additional);
    GUI.popMatrix();
  }
  private void drawValue(float v, String additional){
    String txt = (nf(abs(v), 0, 1));
    int indexx = txt.indexOf(',');
    txt = (indexx >= 0)? txt.substring(0, indexx) : txt;
    int index = min(3, txt.length());
    txt = txt.substring(0, index) + ((index < 3)? "" : "e" + (txt.length()-3));
    //float w = GUI.textWidth(txt.substring(0, txt.indexOf(',')));
    //println(w, txt.substring(txt.indexOf(',')));
    if(v < 0)
      GUI.text("-", -GUI.textWidth("-"), 0);
    GUI.text(txt + additional, 0, 0);
  }
}
