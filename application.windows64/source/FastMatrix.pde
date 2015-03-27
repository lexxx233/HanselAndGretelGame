
public class FastMatrix {
  float[][] m;

  public FastMatrix() {
    m = new float[1][1];
  }

  public FastMatrix(float[][] _m) {
    m = _m;
  }

  public FastMatrix(FastMatrix fm) {
    m = fm.m;
  }

  public FastMatrix(int numRow, int numCol) {
    m = new float[numRow][numCol];
    for (int i = 0; i < numRow; i++) {
      for (int j = 0; j < numCol; j++) {
        m[i][j] = 0.0;
      }
    }
  }

  public FastMatrix(DynamicMatrix dm) {
    m = new float[dm.m.size()][dm.m.get(0).size()];
    for (int i = 0; i < dm.m.size (); i++) {
      for (int j = 0; j < dm.m.get (0).size(); j++) {
        m[i][j] = dm.get(i, j);
      }
    }
  }

  public FastMatrix add(float value) {
    float[][] res = new float[m.length][m[0].length];
    for (int i = 0; i < res.length; i++) {
      for (int j = 0; j < res[0].length; j++) {
        res[i][j] = m[i][j] + value;
      }
    }
    return new FastMatrix(res);
  }
  
  public void set(int i, int j, float val){
    if(i >= m.length || j >= m[0].length){
       println("index out of range, cant set");
       exit();
    } 
    m[i][j] = val; 
  }

  public void flip() {
    for (int i = 0; i < m.length; i++) {
      for (int j = 0; j < m[0].length; j++){
        m[i][j] = (m[i][j] == 0.0)? 1.0 : 0.0;
      }
    }
  }

  public FastMatrix add(FastMatrix fm) {
    FastMatrix res = new FastMatrix(this);
    if (fm.getSize() != this.getSize()) {
      println("Inconsistent matrix size, cant add");
      exit();
    }
    return res;
  }

  public FastMatrix subtract(float value) {
    return new FastMatrix(this.add(-1 * value));
  }

  public FastMatrix subtract(FastMatrix fm) {
    return new FastMatrix(this.add(fm.multiply(-1)));
  }

  public FastMatrix multiply(float value) {
    float[][] res = new float[m.length][m[0].length];
    for (int i = 0; i < res.length; i++) {
      for (int j = 0; j < res[0].length; j++) {
        res[i][j] = m[i][j] * value;
      }
    }
    return new FastMatrix(res);
  }

  public FastMatrix multiply(FastMatrix fm) {
    //Check dimension to see if multiplication is doable
    if (m[0].length != fm.m.length) {
      print("Inconsistent Matrix sizes, can't multiply");
      exit();
    }

    float[][] res = new float[m.length][fm.m[0].length];

    for (int i = 0; i < res.length; i++) {
      for (int j = 0; j < res[0].length; j++) {
        //Hi
      }
    }
    
    return new FastMatrix(res);
  }

  public void inspectMatrix() {
    for (int i = 0; i < m.length; i++) {
      for (int j = 0; j < m[0].length; j++) {
        print(m[i][j]);
        print("\t");
      } 
      print("\n");
    }
  }

  //Get size is not returning true size but rather producing an unique number so that we can compare matrices
  public int getSize() {
    return (m.length + m[0].length) * (m.length * m[0].length);
  }
}

