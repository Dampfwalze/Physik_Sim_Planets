static class SenarioLoader {
  public static PApplet p;
  
  public static float ScaleFactor;
  
  public static Senario loadFromXML(String path){
    return getFromXML(p.loadXML(path));
  }
  
  public static Senario parseFromXML(String xml){
    return getFromXML(p.parseXML(xml));
  }
  
  public static Senario getFromXML(XML xml){
    
    XML scF = xml.getChild("ScaleFactor");
    if(scF != null)
      ScaleFactor = scF.getFloatContent();
    else
      ScaleFactor = 1;
    println("ScaleFactor:", ScaleFactor);
    
    
    Senario senario = ((Physik_Sim_Planets)p).new Senario();
    
    senario.G_const = ((Physik_Sim_Planets)p).G_const*ScaleFactor;
    
    XML simS = xml.getChild("SimulationSpeed");
    if(simS != null)
      senario.simSpeed = simS.getFloatContent()/60;
    else
      senario.simSpeed = 1/60;
    ((Physik_Sim_Planets)p).slider.set(senario.simSpeed);
    
    loadObjects(xml, senario);
    
    ((Physik_Sim_Planets)p).cam.reset();
    
    senario.setup();
    return senario;
  }
  
  private static void loadObjects(XML xml, Senario senario){
    
    // load Planets
    
    for(XML planetData : xml.getChild("Objects").getChildren("Planet")){
      if(planetData.getChildCount() > 0){
        float mass = planetData.getFloat("mass") * ScaleFactor;
        float radius = planetData.getFloat("radius") * ScaleFactor;
        
        PVector pos = getVector(planetData.getString("pos")).mult(ScaleFactor);
        PVector vel = getVector(planetData.getString("vel")).mult(ScaleFactor);
        
        float r_speed = planetData.getFloat("rot_speed");
        
        Planet planet = ((Physik_Sim_Planets)p).new Planet(pos, vel, mass, radius);
        
        planet.name = planetData.getContent();
        planet.r_speed = r_speed;
        
        senario.objects.add(planet);
        
        println(planet, r_speed);
      }
    }
    for(XML satelliteData : xml.getChild("Objects").getChildren("Satellite")){
      if(satelliteData.getChildCount() > 0){
        float mass = satelliteData.getFloat("mass") * ScaleFactor;
        float size = satelliteData.getFloat("size");
        
        PVector pos = getVector(satelliteData.getString("pos")).mult(ScaleFactor);
        PVector vel = getVector(satelliteData.getString("vel")).mult(ScaleFactor);
        
        Satellite satellite = ((Physik_Sim_Planets)p).new Satellite(pos, vel, mass, size);
        
        satellite.name = satelliteData.getContent();
        
        senario.objects.add(satellite);
        
        println(satellite);
      }
    }
    
    // load Textures
    
    for(XML textureData : xml.getChild("Drawing").getChild("Textures").getChildren()){
      if(textureData.getChildCount() > 0){
        String name = textureData.getName();
        for(PhysiksObject planet : senario.objects){
          if(planet.name.equals(name)){
            planet.setTexture(p.loadImage(textureData.getContent()));
            println(textureData.getContent());
            break;
          }
        }
      }
    }//*/
  }
  
  
  private static PVector getVector(String txt){
    PVector v = new PVector();
    
    int index = txt.indexOf(',');
    v.x = float(txt.substring(0, index));
    txt = txt.substring(index+1);
    
    index = txt.indexOf(',');
    v.y = float(txt.substring(0, index));
    txt = txt.substring(index+1);
    
    v.z = float(txt);
    
    return v;
  }
}
