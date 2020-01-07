class PhysiksObject {
  
  // Physiks Stuff
  
  PVector pos;
  PVector vel;
  PVector acc;
  
  float mass;
  
  float radius;
  
  // Drawing Stuff
  
  String name = "Unnamed";
  
  PhysiksObject(PVector pos, PVector vel, float mass) {
    this.pos = pos;
    this.vel = vel;
    this.mass = mass;
    this.acc = new PVector();
  }
  
  public void update(float timestep, Senario parent){
    pos.add(vel.add(acc.mult(timestep)).copy().mult(timestep));
    acc = new PVector();
  }
  
  public void addForce(PVector fce){
    acc.add(fce.copy().div(mass));
  }
  
  public void setTexture(PImage tex){
    
  }
  
  public void draw(){
    PVector screenPosAbs = new PVector(screenX(pos.x, pos.y, pos.z), screenY(pos.x, pos.y, pos.z), screenZ(pos.x, pos.y, pos.z));
    PVector screenPos = screenPosAbs.copy().sub(new PVector(width/2, height/2));
    if(screenPos.x > width/2 || screenPos.x < -width/2 || screenPos.y > height/2 || screenPos.y < -height/2){
      
      int site = round(constrain(screenPos.x, -1, 1));
      float y = screenPos.y * (site*(width-20)/2/screenPos.x) + height/2;
      float x = width/2+site*(width/2-20);
      
      GUI.textAlign((site < 0)? LEFT : RIGHT, CENTER);
      
      if(abs(y-height/2) > height/2 -20){
        site = round(constrain(screenPos.y, -1, 1));
        y = height/2+site*(height/2-20);
        x = screenPos.x * (site*(height-20)/2/screenPos.y) + width/2;
        GUI.textAlign(CENTER, (site < 0)? TOP : BOTTOM);
      }
      
      //float dist = screenPosAbs.dist(screenPos);
      
      GUI.fill(255);
      GUI.text(name, x, y);
    }
    else{
      //GUI.ellipse(screenPosAbs.x, screenPosAbs.y, 20, 20);
      float d = screenPos.dist(new PVector());
      float s = d * tan(cameraFOV/2) * 2;
      //println(map(radius, 0, s, 0, width), s, d);
    }
  }
}
