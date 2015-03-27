
class FastVector {

  float[] v;

  public FastVector() {
    v = new float[1];
  }

  public FastVector(int size) {
    v = new float[size];
    for (int i = 0; i < v.length; i++) {
      v[i] = 0.0;
    }
  }

  public int size() {
    return v.length;
  }

  public FastVector(float[] _v) {
    v = _v;
  }

  public float get(int i) {
    return v[i];
  }

  public FastVector(float[][] _v) {
    v = new float[_v.length];
    for (int i = 0; i < _v.length; i++) {
      v[i] = _v[i][0];
    }
  }

  public float dotProduct(FastVector fv) {
    float res = 0.0;
    FastVector temp = new FastVector(fv.size());

    if (fv.size() != this.size()) {
      println("Size of vector doesn't agree, cant do dot product");
      exit();
    }

    for (int i = 0; i < this.size(); i++) {
      temp.v[i] = this.get(i) * fv.get(i);
    }
    
    return temp.sum();
  }

  public float sum() {
    float res = 0.0;
    for (int i = 0; i < v.length; i++) {
      res += v[i];
    }
    return res;
  }

  public FastVector scale(float val) {
    float[] temp = new float[v.length];
    for (int i = 0; i < v.length; i++) {
      temp[i] = v[i] * val;
    }
    return new FastVector(temp);
  }

  public FastVector multiply(float val) {
    return this.scale(val);
  }
  
}

