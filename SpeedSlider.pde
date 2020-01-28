class SpeedSlider extends GUIElement {
  
  public boolean extended = false;
  
  public float anim = 1;
  
  PImage texl;
  PImage texr;
  
  float min = -3;
  float max = 20;
  
  float value = 1;
  float snap = 0;
  
  SpeedSlider(){
    //this.pos = new PVector(width/2, 0);
    imageMode(CORNER);
    texl = loadImage("data/textures/edge.png");
    texr = createImage(texl.width, texl.height, RGB);
    texl.loadPixels();
    texr.loadPixels();
    //println(texl.pixels.length, texr.pixels.length);
    for(int i = 0; i < texl.width; i++){
      for(int j = 0; j < texl.height; j++){
        texl.pixels[texl.width * j + i] = color(100, alpha(texl.pixels[texl.width * j + i]));
        texr.pixels[texl.width * j + (texl.width-i)-1] = texl.pixels[texl.width * j + i];
      }
    }
    texl.updatePixels();
    texr.updatePixels();
    //tex.resize(-tex.width, tex.height);
  }
  
  public void set(float v){
    value = log(v*60) / log(2);
    snap = value;
    max = value * 3;
  }
  
  public void update(){
    int size = width/3;
    if((mouseY < (1-anim) * (texl.height-7) +7 && mouseX > width/2 - width/6 && mouseX < width/2 + width/6) || (mousePressed && extended)){
      anim = max(0, anim-0.05);
      extended = true;
      if(mousePressed){
        value = min(max, max(min, map(mouseX-width/2, -size/2, size/2, min, max)));
      }
    }
    else{
      anim = min(1, anim+0.05);
      extended = false;
    }
    if(extended && mousePressed){
      cam.setActive(false);
      int mid = width/2 - size/2 + int(size * map(-min, 0, max - min, 0, 1));
      if(abs(mouseX - mid) < 10)
        value = 0;
      else if(abs(mouseX - (width/2 - size/2 + int(map(snap, min, max, 0, size)))) < 10)
        value = snap;
      else
        value = min(max, max(min, map(mouseX-width/2, -size/2, size/2, min, max)));
      currentSenario.simSpeed = (value == min)? 0 : pow(2, value)/60;
    }
  }
  
  public void draw(){
    int size = width/3;
    
    int y = int(-anim * (texl.height-7)) + texl.height;
    drawPlane(y, 200, 30);
    GUI.fill(255);
    GUI.textSize(20);
    if(value > min){
      GUI.text(format(currentSenario.simSpeed*60) + " : sec", width/2, y+15);
    }
    else{
      GUI.rect(width/2 - 7, y+5, 5, 20);
      GUI.rect(width/2 + 7, y+5, -5, 20);
    }
    
    drawPlane(int(-anim * (texl.height-7)), size, texl.height);
    
    int mid = int(size * map(-min, 0, max - min, 0, 1));
    GUI.stroke(0, 255, 0, 70);
    GUI.strokeWeight((1-anim)*(texl.height-7)*1.5f + 4);
    GUI.strokeCap((anim == 1)? ROUND : SQUARE);
    GUI.line(width/2 - size/2, 2, width/2 - size/2 + mid, 2);
    GUI.stroke(255, 0, 0, 70);
    GUI.line(width/2 - size/2 + mid, 2, width/2 + size/2, 2);
    
    GUI.stroke(0, 255, 0);
    GUI.line(width/2 - size/2, 2, width/2 - size/2 + map(min(0, value), min, max, 0, 1)*size, 2);
    if(value > 0){
      GUI.stroke(255, 0, 0);
      GUI.line(width/2 - size/2 + mid, 2, width/2 - size/2 + map(value, min, max, 0, 1)*size, 2);
    }
    GUI.strokeWeight(1);
    int x = width/2 - size/2 + int(map(snap, min, max, 0, size));
    GUI.stroke((value > snap)? color(170, 0, 0) : color(255, 0, 0));
    GUI.line(x, 0, x, (1-anim)*(texl.height-7)*0.75f + 4);
  }
  
  private void drawPlane(int y, int size, int sizeY){
    GUI.image(texl, width/2 - texl.width - size/2, y, texl.width, sizeY);
    GUI.image(texr, width/2 + size/2, y, texl.width, sizeY);
    GUI.noStroke();
    GUI.fill(100);
    GUI.rect(width/2 - size/2, y, size, sizeY);
  }
  
  private String format(float v){
    String end = "s";
    if(v / 60 >= 1){
      v /= 60;
      end = "min";
      if(v / 60 >= 1){
        v /= 60;
        end = "h";
        if(v / 24 >= 1){
          v /= 24;
          end = "d";
          if(v / 365 >= 1){
            v /= 365;
            end = "y";
            if(v / 1000 >= 1){
              v /= 1000;
              end = "ky";
            }
          }
        }
      }
    }
    return nf(v, 0, 2) + end;
  }
}
