class Planet extends PhysiksObject {
  
  // Physiks Stuff
  
  
  // Drawing Stuff
  
  PImage texture;
  PShape shape;
  
  float r_speed = 0;
  float rot = 0;
  
  Planet(PVector pos, PVector vel, float mass, float radius){
    super(pos, vel, mass);
    this.radius = radius;
    noStroke();
    shape = createShape(SPHERE, radius);
    shape.rotateX(-HALF_PI);
    shape.setTexture(defaultTexture);
  }
  
  public void update(float timestep, Senario s){
    super.update(timestep, s);
    
    rot += r_speed*timestep;
    if(rot > TWO_PI)
      rot = rot % TWO_PI;
  }
  
  public void draw(){
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    stroke(255, 0, 0);
    strokeWeight(1);
    if(vel.mag() >= 0.000001){
      PVector v = vel.copy().normalize().mult(radius*3);
      line(0, 0, 0, v.x, v.y, v.z);
    }
    rotateZ(rot);
    shape(shape);
    popMatrix();
    
    super.draw();
  }
  
  public void setTexture(PImage tex){
    texture = tex;
    shape.setTexture(tex);
  }
  
  public String toString(){
    return name + ": { pos: " + pos + ",  vel: " + vel + ",  mass: " + mass + ",  radius: " + radius + " }"; 
  }
}
