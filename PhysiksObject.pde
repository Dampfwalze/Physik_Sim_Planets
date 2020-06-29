class PhysiksObject {
  
  // Physiks Stuff
  
  PVector pos;
  PVector vel;
  PVector acc;
  
  PVector prePos;
  
  float mass;
  
  PhysiksObject orbiting;
  
  float radius;
  
  
  int trackCount = 100;
  
  // Drawing Stuff
  
  String name = "Unnamed";
  
  LinkedList<PVector> track = new LinkedList<PVector>();
  
  PhysiksObject(PVector pos, PVector vel, float mass) {
    this.pos = pos;
    this.vel = vel;
    this.mass = mass;
    this.acc = new PVector();
  }
  
  public void update(float timestep, Senario parent){
    if(true || timestep != 0){
      prePos = pos.copy();
      track.add(pos.copy());
      if(track.size() > 200){
        track.remove(0);
      }
    }
    pos.add(vel.add(acc.mult(timestep)).copy().mult(timestep));
    
    calcOrbit();
    
    acc = new PVector();
  }
  
  public void addForce(PVector fce){
    acc.add(fce.copy().div(mass));
  }
  
  public void calcOrbit(){
    if(orbiting == null || track.size() <= 2 || true)
      return;
    PVector pPos = track.getFirst();
    PVector[] v = OrbitCalc.calcOrbit(orbiting, pos, pPos, prePos, track.get(1));
    PVector p = orbiting.pos;
    if(v[2] != null){
    GUI.pushMatrix();
    GUI.translate(width/2, height/2);
    pushMatrix();
    translate(v[2].x, v[2].y, v[2].z);
    sphere(20);
    popMatrix();
    //line(p.x, p.y, p.z, pos.x, pos.y, pos.z);
    line(pos.x, pos.y, pos.z, pos.x + v[0].x*100, pos.y + v[0].y*100, pos.z);
    line(pPos.x, pPos.y, pPos.z, pPos.x + v[1].x*100, pPos.y + v[1].y*100, pPos.z);
    //GUI.line(0, 0, 100, 0);
    //GUI.line(0, 0, v.x*100, -v.y*100);
    GUI.popMatrix();
    }
    
    line(p.x, p.y, p.z, pos.x, pos.y, pos.z);
    line(p.x, p.y, p.z, pPos.x, pPos.y, pPos.z);
    //println(v);
  }
  
  public void calcOrbitingObjects(Senario parrent){
    
    ArrayList<PhysiksObject> orbiting = new ArrayList<PhysiksObject>();
    for(PhysiksObject o : parrent.objects){
      if(o != this){
        float v = parrent.calcGravityForce(o, this);
        if(v / mass > v / o.mass){
          orbiting.add(o);
        }
        println(v/mass);
      }
    }
    if(orbiting.size() > 1){
      float max = 0;
      for(PhysiksObject o : orbiting){
        float v = parrent.calcGravityForce(o, this);
        if(v > max){
          this.orbiting = o;
          max = v;
        }
      }
    }
    else if(orbiting.size() <= 0)
      return;
    else
      this.orbiting = orbiting.get(0);
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
    line(pos.x, pos.y, pos.z, prePos.x, prePos.y, prePos.z);
    
    beginShape();
    noFill();
    stroke(#03FFFF);
    for(PVector p : track){
      vertex(p.x, p.y, p.z);
    }
    endShape();
  }
}
