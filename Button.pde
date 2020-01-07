import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;

class Button extends GUIElement {
  
  PVector size;
  
  public String text;
  
  private int preStateFrame;
  private int preStateChange;
  
  private float animCount = 0;
  
  public int id = 0;
  
  private color[] cols = {
      color(200, 200, 200), 
      color(180, 180, 180), 
      color(150, 150, 150)
  };
  
  
  public int state;
  
  public Method methodDown;
  public Method methodUp;
  public Object classUp;
  public Method methodPressed;
  public Method methodHover;
  public Method methodHoverOrDown;
  public Method methodNotPressed;
  public Method methodNothing;
  
  public Button setID(int id){
    this.id = id;
    return this;
  }
  
  Button(float posX, float posY, float sizeX, float sizeY, String text){
    pos = new PVector(posX, posY);
    size = new PVector(sizeX, sizeY);
    this.text = text;
  }
  
  public void draw(){
    draw(GUI, state);
  }
  
  public void draw(PGraphics g, int state)
  {
    if(preStateFrame != state) {
      preStateChange = preStateFrame;
      animCount = 0;
    }
    
    g.stroke(34, 35, 209);
    
    int x = (int)pos.x;
    int y = (int)pos.y;
    int sizeX = (int)size.x;
    int sizeY = (int)size.y;
    
    color c = cols[preStateChange];
    g.fill(c);
    g.strokeWeight(1);
    g.rect(x, y, sizeX, sizeY);
    
    c = cols[state];
    g.fill(c, animCount*255);
    g.rect(x ,y, sizeX, sizeY);
    
    g.textAlign(3, 3);
    g.fill(0);
    g.textSize(15);
    g.text(text, x+sizeX/2, y+sizeY/2-2);
    
    animCount = PApplet.min(1, animCount + 10f/frameRate);
    
    preStateFrame = state;
  }
  
  private boolean preMousePressed = false;
  private boolean startedOn = false;
  public void update(){
    if(mousePressed) {
      if(mousePressed != preMousePressed) {
        if(hover()) {
          startedOn = true;
          call(methodDown, id, 2);
        }
        else {
          startedOn = false;
        }
      }
      if(hover()) {
        state = (startedOn)? 2 : 1;
        if(startedOn)
          call(methodPressed, id, state);
        call(methodHoverOrDown, id, state);
      }
      else {
        state = (startedOn)? 1 : 0;
      }
    }
    else {
      call(methodNotPressed, id, 0);
      if(hover()) {
        state = 1;
        call(methodHoverOrDown, id, 1);
        call(methodHover, id, 1);
      }
      else {
        state = 0;
        call(methodNothing, id, 0);
      }
      if(mousePressed != preMousePressed) {
        if(hover())
          call(methodUp, id, 0, classUp);
      }
    }
    
  
    preMousePressed = mousePressed;
    
  }
  private boolean hover()
  {
    return (mouseX < pos.x + size.x &&
            mouseX > pos.x &&
            mouseY < pos.y + size.y && 
            mouseY > pos.y);
  }
  
  private void call(Method m, int id, int state)
  {
    if(m != null) {
      try {
        m.invoke(SenarioLoader.p, id, state);
      }
      catch(Exception e) {
        println(e);
        return;
      }
    }
  }
  private void call(Method m, int id, int state, Object c)
  {
    if(m != null) {
      try {
        m.invoke(c, id, state);
      }
      catch(Exception e) {
        println(e, "Button");
        return;
      }
    }
  }
  
  public Button setEventDown(String m) {methodDown = setMethod(m); return this;}
  public Button setEventUp(String m, Object c) {methodUp = setMethod(m, c.getClass()); classUp = c; return this;}
  public Button setEventPressed(String m) {methodPressed = setMethod(m); return this;}
  public Button setEventHover(String m) {methodHover = setMethod(m); return this;}
  public Button setEventHoverOrDown(String m) {methodHoverOrDown = setMethod(m); return this;}
  public Button setEventNotPressed(String m) {methodNotPressed = setMethod(m); return this;}
  public Button setEventNothing(String m) {methodNothing = setMethod(m); return this;}
  
  private Method setMethod(String n)
  {
    try {
      Method m = SenarioLoader.p.getClass().getMethod(n, Integer.class, Integer.class);
      return m;
    }
    catch(Exception e) {
      PApplet.println(e);
      return null;
    }
  }
  private Method setMethod(String n, Class c)
  {
    try {
      Method m = c.getMethod(n, Integer.class, Integer.class);
      return m;
    }
    catch(Exception e) {
      PApplet.println(e);
      return null;
    }
  }
}
