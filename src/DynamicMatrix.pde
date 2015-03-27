
class DynamicMatrix {

  ArrayList<ArrayList<Float>> m;

  public DynamicMatrix() {
    m = new ArrayList();
  }

  public DynamicMatrix(int numRow, int numCol) {
    m = new ArrayList();
    for (int i = 0; i < numRow; i++) {
      float[] temp = new float[numCol];
      for (int j = 0; j < numCol; j++) {
        temp[j] = 0.0;
      }
      m.add(arrayToArrayList(temp));
    }
  }

  public DynamicMatrix(float[][] a) {
    m = new ArrayList();
    for (int i = 0; i < a.length; i++) {
      addRow(a[i]);
    }
  }

  public DynamicMatrix(DynamicMatrix _m) {
    m = _m.m;
  }

  public DynamicMatrix(FastMatrix _m) {
    m = new ArrayList();
    for (int i = 0; i < _m.m.length; i++) {
      addRow(_m.m[i]);
    }
  }

  public float get(int i, int j) {
    return m.get(i).get(j);
  }

  void addRow(float[] _row) {
    ArrayList<Float> row = arrayToArrayList(_row); 
    if (m.size() == 0) {
      m.add(row);
    } else {
      if (m.get(0).size() != row.size()) {
        print("Inconsistent column, Can't add row"); 
        exit();
      }
      m.add(row);
    }
  }

  void addCol(float[] _col) {
    if (m.size() == 0) {
      for (int i = 0; i < _col.length; i++) {
        m.add(new ArrayList<Float>()); 
        ArrayList<Float> temp = m.get(i);
        temp.add(_col[i]);
        m.set(i, temp);
      }
    } else {
      if (m.size() != _col.length) {
        print("Inconsistent row, Can't add columns"); 
        exit();
      }
      for (int i = 0; i < _col.length; i++) {
        ArrayList<Float> temp = m.get(i);
        temp.add(_col[i]);
        m.set(i, temp);
      }
    }
  }

  public void inspectMatrix() {
    if (m.size() == 0) {
      return;
    }
    for (int i = 0; i < m.size (); i++) {
      for (int j = 0; j < m.get (0).size(); j++) {
        print(m.get(i).get(j)); 
        print("\t");
      }
      print("\n");
    }
  }
  
    private ArrayList<Float> arrayToArrayList(float[] arr) {
    ArrayList<Float> res = new ArrayList(); 
    for (int i = 0; i < arr.length; i++) {
      res.add(arr[i]);
    }
    return res;
  }
}

