/**
 * Paints are born here :D
 * @author Thanh Le | College of Information Science and Technology | PennState University
 * txl252@psu.edu
 **/


class Paint {
  String cName;
  float x, y, vx, vy, vr;
  ArrayList<PaintConstruct> cParts;

  Paint(String iName, float ix, float iy) {
    cName = iName;
    x = ix;
    y = iy;
    vx = 0;
    vy = 0;
    vr = 0;
    cParts = new ArrayList();
  }

  //Set velocity
  void setV(float ix, float iy) {
    vx = ix;
    vy = iy;
  }

  //Set rotational velocity for loop
  void setR(float ir) {
    vr = ir;
  }

  /**
   * use ConditionalVisitor(); MethodVisitor(); LoopVisitor(); VariableVisitor()
   * to create parts 
   **/
  void buildPaint() {
  }

  void update() {
    //TODO: Update text position

    //TODO: Update Paint position
  }

  void draw() {
  }
}


/**
 * Paint constructs are body parts of the Paint. 
 * All Paint construct extends abastract class PaintConstruct
 **/
abstract class PaintConstruct {
  float x, y;
  ArrayList<float[]> units;
  PaintConstruct(float ix, float iy) {
    x = ix; 
    y = iy;
    units = new ArrayList();
  }

  abstract void draw();
  abstract void animate();
}

class CStatement extends PaintConstruct {
  CStatement(float ix, float iy) {
    super(ix, iy);
  }

  public void draw() {
  }

  public void animate() {
  }
}

class CLoop extends PaintConstruct {

  CLoop(float ix, float iy) {
    super(ix, iy);
  }

  public void draw() {
  }

  public void animate() {
  }
}

class CConditional extends PaintConstruct {
  CConditional(float ix, float iy) {
    super(ix, iy);
  }

  public void draw() {
  }

  public void animate() {
  }
}

class CStructure extends PaintConstruct {
  CStructure(float ix, float iy) {
    super(ix, iy);
  }

  public void draw() {
  }

  public void animate() {
  }
}

