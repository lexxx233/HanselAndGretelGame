/**
 * Maze and maze generator
 * Author: Thanh Le | txl252@psu.edu
 *
 * x, y - position of maze
 * w, h - width and height of maze
 **/

class Maze {

  //Constants
  final int N = 1; 
  final int S = 2; 
  final int E = 4; 
  final int W = 8;
  HashMap<Integer, Integer> DX = new HashMap<Integer, Integer>();
  HashMap<Integer, Integer> DY = new HashMap<Integer, Integer>();
  HashMap<Integer, Integer> OPPOSITE = new HashMap<Integer, Integer>();

  FastMatrix maze, wall;
  float x, y, w, h;
  FCompound wallCompound;

  public Maze(int mSize, float xMaze, float yMaze, float wMaze, float hMaze) {
    maze = new FastMatrix(mSize, mSize);
    wall = new FastMatrix(mSize*2+1, mSize*2+1);
    wall.flip();
    x = xMaze;
    y = yMaze;
    w = wMaze;
    h = hMaze;

    DX.put(E, 1); 
    DX.put(W, -1); 
    DX.put(N, 0); 
    DX.put(S, 0);

    DY.put(E, 0); 
    DY.put(W, 0); 
    DY.put(N, -1); 
    DY.put(S, 1);

    OPPOSITE.put(N, S);
    OPPOSITE.put(S, N);
    OPPOSITE.put(E, W);
    OPPOSITE.put(W, E);
  }

  //Generate a random maze using recursive backtracking algorithm
  public void generateMaze(int cx, int cy, Maze _maze) {
    int[] temp = {
      N, S, E, W
    };
    int[] directions = this.randArray(temp);
    directions = randArray(directions);
    for (int direction : directions) {
      int nx = cx + DX.get(direction);
      int ny = cy + DY.get(direction);

      if (ny >= 0 && ny <= _maze.maze.m.length-1 && nx >= 0 && nx <= _maze.maze.m[ny].length-1 && _maze.maze.m[ny][nx] == 0) {
        _maze.maze.m[cy][cx] = this.bOR(int(_maze.maze.m[cy][cx]), direction);
        _maze.maze.m[ny][nx] = this.bOR(int(_maze.maze.m[ny][nx]), OPPOSITE.get(direction));

        int iy = (cy > ny)? ny : cy;
        int iyh = (cy > ny)? cy : ny;
        int ix = (cx > nx)? nx : cx;
        int ixh = (cx > nx)? cx : nx;

        for (int i = iy*2+1; i <= iyh*2+1; i++) {
          wall.m[i][ix*2+1] = 0;
        }

        for (int i = ix*2+1; i <= ixh*2+1; i++) {
          wall.m[iy*2+1][i] = 0;
        }
        generateMaze(nx, ny, _maze);
      }
    }
    wall.m[0][1] = 0;
    wallCompound = new FCompound();
  }

  public void compound() {
    float numRow = float(wall.m.length);
    int fidx = 0;
    for (int i = 0; i < numRow; i++) {
      for (int j = 0; j < numRow; j++) { 

        int incr_i = i+1;
        incr_i = constrain(incr_i, 0, int(numRow)-1);
        int incr_j = j+1;
        incr_j = constrain(incr_j, 0, int(numRow)-1);

        if (wall.m[i][j] == 1.0 &&  wall.m[i][incr_j] == 1.0) {
          FLine tempLine = new FLine(w/numRow * i - w/2 + x, h/numRow * j - h/2 + y, w/numRow * i - w/2 + x, h/numRow * (incr_j) - h/2 + y);
          tempLine.setStroke(random(100, 200),random(100, 200),0);
          tempLine.setStrokeWeight(1);
          tempLine.setRestitution(0.1);
          tempLine.setFriction(100);
          wallCompound.addBody(tempLine);
          FLine tempLine2 = new FLine(w/numRow * i - w/2 + x-0.1, h/numRow * (incr_j) - h/2 + y, w/numRow * i - w/2 + x-0.1, h/numRow * j - h/2 + y); // Sketchy ass fix for the physics engine... I hope you don't see this :(
          tempLine2.setStroke(random(100, 200),random(100, 200),0);
          tempLine2.setStrokeWeight(1);
          tempLine2.setRestitution(0.1);
          tempLine2.setFriction(100);
          wallCompound.addBody(tempLine2);
        }

        if (wall.m[i][j] == 1.0 && wall.m[incr_i][j] == 1.0) {
          //line(w/numRow * i - w/2, h/numRow * j - h/2, w/numRow * (incr_i) - w/2, h/numRow * j - h/2);
          FLine tempLine = new FLine(w/numRow * i - w/2 + x-0.1, h/numRow * j - h/2 + y, w/numRow * (incr_i) - w/2 + x + 0.1, h/numRow * j - h/2 + y);
          tempLine.setStroke(0, random(100, 200),random(100, 200));
          tempLine.setStrokeWeight(1);
          tempLine.setRestitution(0.5);
          tempLine.setFriction(100);
          wallCompound.addBody(tempLine);
          FLine tempLine2 = new FLine( w/numRow * (incr_i) - w/2 + x+0.1, h/numRow * j - h/2 + y+0.1, w/numRow * i - w/2 + x - 0.1, h/numRow * j - h/2 + y+0.1);
          tempLine2.setStroke(0, random(100, 200),random(100, 200));
          tempLine2.setStrokeWeight(1);
          tempLine2.setRestitution(0.5);
          tempLine2.setFriction(100);
          wallCompound.addBody(tempLine2);
        }
      }
    }
    HanselandGretel.world.add(wallCompound);
  }
  
  private int[] index(String s) {
    return new int[] {
      int(s.split("-"))[0], int(s.split("-"))[1]
    };
  }

  private int bOR(int a, int b) {
    boolean r1 = (a == 0)? false : true;
    boolean r2 = (b == 0)? false : true;
    int res = (r1 || r2)? 1 : 0;
    return res;
  }

  private int[] randArray(int[] arr) {
    int[] res = new int[arr.length];
    ArrayList<Integer> idx = new ArrayList();
    for (int i = 0; i < arr.length; i++) {
      idx.add(int(random(0, idx.size())), i);
    }
    for (int i = 0; i < idx.size (); i++) {
      res[i] = arr[idx.get(i)];
    }
    return res;
  }

  private ArrayList<String> shuffleArray(ArrayList<String> arr) {
    ArrayList<String> res = new ArrayList();
    ArrayList<Integer> idx = new ArrayList();
    //Randomize index sequence
    for (int i = 0; i < arr.size (); i++) {
      idx.add(int(random(0, idx.size())), i);
    }
    for (int i = 0; i < idx.size (); i++) {
      res.add(arr.get(idx.get(i)));
    }
    return res;
  }
}

