class Satellite extends PhysiksObject {
  
  PImage texture;
  
  Satellite(PVector pos, PVector vel, float mass, float size){
    super(pos, vel, mass);
    radius = size;
  }
  
  public void setTexture(PImage tex){
    texture = tex;
    //texture.resize((int)radius, (int)radius);
  }
  
  public void draw(){
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    stroke(255, 0, 0);
    strokeWeight(1);
    //if(vel.mag() >= 1){
      PVector v = vel.copy().normalize().mult(radius*3);
      line(0, 0, 0, v.x, v.y, v.z);
    //}
    float[] rot = cam.getRotations();
    rotateX(rot[0]);
    rotateY(rot[1]);
    rotateZ(rot[2]);
    imageMode(CENTER);
    image(texture, 0, 0, radius * ((float)texture.width/texture.height), radius);
    //rect(0, 0, 10000, 10000);
    popMatrix();
    
    super.draw();
  }
  
  public String toString(){
    return name + ": { pos: " + pos + ",  vel: " + vel + ",  mass: " + mass + ",  radius: " + radius + " }"; 
  }
}
