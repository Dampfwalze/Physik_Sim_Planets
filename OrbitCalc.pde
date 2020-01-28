static class OrbitCalc {
  
  public static PVector[] calcOrbit(PhysiksObject center, PVector pos1, PVector pos2, PVector pos3, PVector pos4){
    ArrayList<PVector> points = transformToPlane(getNormal(center.pos, pos1, pos2), center.pos, pos1, pos2);
    DVector ce = new DVector(center.pos); //points.get(0);
    DVector p1 = new DVector(pos1); //points.get(1);
    DVector p2 = new DVector(pos2); //points.get(2);
    DVector p3 = new DVector(pos3); 
    DVector p4 = new DVector(pos4); 
    
    //println(center.pos, pos1, pos2);
    //println(ce, p1, p2);
    
    /*
    double a = ce.dist(p1);
    double b = ce.dist(p3);
    double c = p3.dist(p1);
    double d = ce.dist(p2);
    double e = ce.dist(p4);
    double f = p2.dist(p4);
    
    float alpha = acos((float)((b*b + c*c - a*a) / (2*c*b)));
    float beta  = acos((float)((a*a + c*c - b*b) / (2*a*c)));
    
    
    
    //println(alpha, beta);
    
    DVector dir = p2.copy().sub(p1).normalize();
    
    DVector v1 = new DVector(dir.y, -dir.x).mult(sin(beta));
    DVector v2 = dir.copy().mult(-cos(beta));
    DVector d1 = v1.add(v2).normalize();
    
    DVector e1 = new DVector(dir.y, -dir.x).mult(sin(PI-alpha));
    DVector e2 = dir.copy().mult(-cos(PI-alpha));
    DVector d2 = e1.add(e2).normalize();
    //*/
    
    DVector d1 = getDir(ce, p1, p3);
    DVector d2 = getDir(ce, p4, p2);
    
    PVector c2 = intersect(p1, p1.copy().add(d1), p2, p2.copy().add(d2));
    
    
    PVector cen = d1.copy().sub(d2).mult(0.5f).toPVector();
    float len1 = (ce.dist(p1) + c2.dist(p1.toPVector())) / 2;
    float len2 = cen.dist(c2);
    float w = sqrt(len1*len1 + len2*len2)*2;
    
    println(c2);
    
    return new PVector[] {d2.toPVector(), d1.toPVector(), c2};
  }
  
  private static DVector getDir(DVector ce, DVector p1, DVector p2){
    double a = ce.dist(p1);
    double b = ce.dist(p2);
    double c = p2.dist(p1);
    
    float beta  = acos((float)((a*a + c*c - b*b) / (2*a*c)));
    
    DVector dir = p2.copy().sub(p1).normalize();
    
    DVector v1 = new DVector(dir.y, -dir.x).mult(sin(beta));
    DVector v2 = dir.copy().mult(-cos(beta));
    DVector d1 = v1.add(v2).normalize();
    
    return d1;
  }
  
  public static ArrayList<PVector> transformToPlane(PVector normal, PVector... points){
    ArrayList<PVector> list = new ArrayList<PVector>();
    
    PVector u = points[0].copy().sub(points[1]).normalize();
    PVector v = u.copy().cross(normal).normalize();
    
    for(PVector p : points){
      list.add(new PVector(p.dot(u), p.dot(v)));
    }
    
    return list;
  }

  
  
  public static PVector getNormal(PVector v1, PVector v2, PVector v3){
    
    return v2.copy().sub(v1).cross(v3.copy().sub(v1)).normalize();
  }
  
  public static PVector intersect(DVector A, DVector B, DVector C, DVector D) 
  { 
    // Line AB represented as a1x + b1y = c1 
    double a1 = B.y - A.y; 
    double b1 = A.x - B.x; 
    double c1 = a1*(A.x) + b1*(A.y); 
  
    // Line CD represented as a2x + b2y = c2 
    double a2 = D.y - C.y; 
    double b2 = C.x - D.x; 
    double c2 = a2*(C.x)+ b2*(C.y); 
  
    double determinant = a1*b2 - a2*b1; 
  
    if (determinant == 0) 
    { 
      // The lines are parallel. This is simplified 
      // by returning a pair of FLT_MAX 
      return null;
    } else
    { 
      double x = (b2*c1 - b1*c2)/determinant; 
      double y = (a1*c2 - a2*c1)/determinant; 
      return new PVector((float)x, (float)y);
    }
  }
  
  static class DVector {
    
    double x;
    double y;
    double z;
    
    DVector(PVector v){
      this.x = v.x;
      this.y = v.y;
      this.z = v.z;
    }
    DVector(double x, double y, double z){
      this.x = x;
      this.y = y;
      this.z = z;
    }
    DVector(double x, double y){
      this.x = x;
      this.y = y;
      this.z = 0;
    }
    
    public DVector add(DVector v){
      x += v.x;
      y += v.y;
      z += v.z;
      return this;
    }
    public DVector sub(DVector v){
      x -= v.x;
      y -= v.y;
      z -= v.z;
      return this;
    }
    public DVector mult(double v){
      x *= v;
      y *= v;
      z *= v;
      return this;
    }
    public DVector div(double v){
      x /= v;
      y /= v;
      z /= v;
      return this;
    }
    
    public float dist(DVector v){
      return sqrt((float)(sq(v.x-x) + sq(v.y-y) + sq(v.z-z)));
    }
    
    private double sq(double v){
      return v*v;
    }
    
    public void set(double x, double y, double z){
      this.x = x;
      this.y = y;
      this.z = z;
    }
    public void set(double x, double y){
      this.x = x;
      this.y = y;
      this.z = 0;
    }
    
    public DVector normalize(){
      double m = mag();
      this.x = 1/m * this.x;
      this.y = 1/m * this.y;
      this.z = 1/m * this.z;
      return this;
    }
    
    public DVector copy(){
      return new DVector(x, y, z);
    }
    public double mag(){
      return dist(new DVector(0, 0, 0));
    }
    
    public PVector toPVector(){
      return new PVector((float)x, (float)y, (float)z);
    }
  }
}
