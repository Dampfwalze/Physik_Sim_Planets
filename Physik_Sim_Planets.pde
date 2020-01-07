import peasy.*;

PeasyCam cam;

PImage defaultTexture;

Senario currentSenario;

PGraphics GUI;

int starCount = 100;
PShape skyBox;

float cameraFOV = 60 * DEG_TO_RAD;

ArrayList<GUIElement> guiElements = new ArrayList<GUIElement>();

String[] senarios;

void settings(){
  fullScreen(P3D);
  //size(1000, 700, P3D);
  SenarioLoader.p = this;
}

void setup(){
  
  
  GUI = createGraphics(width, height, JAVA2D);
  
  defaultTexture = loadImage("data/textures/sun.jpg");
  
  //currentSenario = SenarioLoader.loadFromXML("data/Senarios/Sun_Earth.xml");
  
  cam = new PeasyCam(this, 0 ,0, 0, (height/2.0) / tan(PI*30.0 / 180.0));
  
  generateStars();
  perspective();
  
  getSenarios();
  setupGUI();
  
  changeSenario(0);
}

void draw(){
  background(0);
  GUI.beginDraw();
  GUI.clear();
  drawStars();
  
  //hint(ENABLE_STROKE_PERSPECTIVE);
  hint(ENABLE_DEPTH_MASK);
  currentSenario.update();
  currentSenario.draw();
  hint(DISABLE_DEPTH_MASK);
  
  drawGUI();
  
  GUI.endDraw();
  cam.beginHUD();
  imageMode(CORNER);
  image(GUI, 0, 0);
  cam.endHUD();
}


void getSenarios(){
  File file = new File(savePath("data/Senarios"));
  senarios = file.list();
}

void changeSenario(Integer id){
  if(senarios != null && senarios.length > 0){
    println("load Senario", id);
    currentSenario = SenarioLoader.loadFromXML("data/Senarios/" + senarios[id]);
    currentSenario.id = id;
  }
  else{
    println("No Senarios found");
  }
}

void drawStars(){
  pushMatrix();
  float[] pos = cam.getPosition();
  translate(pos[0], pos[1], pos[2]);
  shape(skyBox);
  popMatrix();
}

void generateStars(){
  PGraphics tex = createGraphics(500, 500, JAVA2D);
  tex.beginDraw();
  for(int i = 0; i < starCount; i++){
    tex.stroke(255);
    tex.point(random(0, 500), random(0, 500));
  }
  tex.endDraw();
  
  skyBox = createShape(BOX, 2000);
  skyBox.setTexture(tex);
}

public void perspective() {
  
  float cameraX = width / 2.0f;
  float cameraY = height / 2.0f;
  float cameraZ = cameraY / ((float) Math.tan(cameraFOV / 2.0f));
  float cameraNear = cameraZ / 500.0f;
  float cameraFar = cameraZ * 30.0f;
  float cameraAspect = (float) width / (float) height;
  
  perspective(cameraFOV, cameraAspect, cameraNear, cameraFar);
}

public void perspective(float fov, float aspect, float zNear, float zFar) {
  float ymax = zNear * (float) Math.tan(fov / 2);
  float ymin = -ymax;
  float xmin = ymin * aspect;
  float xmax = ymax * aspect;
  frustum(xmin, xmax, ymin, ymax, zNear, zFar);
  //println("frustum(" + xmin + ", " + xmax + ", " + ymax + ", " + zNear + ", " + zFar + ")");
}

void resetSenario(Integer id, Integer state){
  changeSenario(currentSenario.id);
}

void mouseDragged(MouseEvent e){
  if(e.getButton() == 3){
    currentSenario.lookAt = null;
  }
}
