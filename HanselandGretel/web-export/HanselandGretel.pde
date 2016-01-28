import fisica.*;
import processing.video.*;

Maze m;
static FWorld world;
Player character;
Player2 helper;
Masker mask;
boolean endFlag = false;
boolean titleFlag = true;
Snow[] snow = new Snow[30];

Movie mu;
void setup() {
  frameRate(32);
  mu = new Movie (this, "MELODIOU.wav");
  mu.loop();
  mu.speed(0.45);
  size(1024, 768);
  m = new Maze(13, width/2+15, height/2 -20, 550, 700);
  m.generateMaze(5, 5, m);

  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 600);
  character = new Player();
  helper = new Player2();
  m.compound();

  for (int i = 0; i < snow.length; i++) {
    snow[i] = new Snow(random(width), random(height), random(-0.3, 0.3), random(7)+ 5);
  }
}

float i = 0;
void draw() {
  background(35);
  
  if (titleFlag) {
    pushMatrix();
    translate(212, 9);
    PImage img;
    img = loadImage("cover.png");
    image(img, 0, 0);
    if (keyPressed) {
      if (key == ' ') {
        titleFlag = false;
      }
    }
    popMatrix();
  }

  if (keyPressed) {
    if (key == ' ') {

      m = new Maze(13, width/4+30, height/2 -20, 550, 700);
      m.generateMaze(5, 5, m);

      Fisica.init(this);
      world = new FWorld();
      world.setGravity(0, 600);
      character = new Player();
      helper = new Player2();
      m.compound();

      endFlag = false;
    }
    if (key == ENTER) {
      titleFlag = true;
    }
  }

  if (!titleFlag) {
    if (!endFlag) {
      pushMatrix();
      translate(212, 9);
      background(35);
      world.step();
      world.draw(this);
      
      
      character.update();
      
      

      //Check winning or losing condition
      if (character.fuel <= 0) {
        endFlag = true;
      }
      if (character.player.getY() >= height-3 || character.player.getX() <= 0) {
        endFlag = true;
      }
      popMatrix();
      
      if (mousePressed) {
        helper.mousePressed();
      }
      
      mask = new Masker(character, helper);
      mask.draw();
      helper.update();
    } else {
      pushMatrix();
      translate(212, 9);
      background(35);
      world.step();
      world.draw(this);
      
      character.update();
      helper.update();
      popMatrix();
      
      textAlign(CENTER);
      if (character.fuel <= 0) {
        fill(255);
        textSize(50);
        text("GURL, YOU STARVED !!!!\n press ENTER to restart", width/2, height/2);
      }
      if (character.player.getY() >= height-3 || character.player.getX() <= 30) {
        fill(255);
        textSize(50); 
        text("HANSEL IS HOME AGAIN!\n press ENTER to restart", width/2, height/2);
      }
      
    }
  }

  for (int i = 0; i < snow.length; i++) {
    snow[i].y += 0.75;
    snow[i].x -= 0.5;
    if (snow[i].y > height) {
      snow[i].y = -1;
    }
    if (snow[i].x < 0) {
      snow[i].x = width+1;
    }
    snow[i].spin();
    snow[i].display();
  }
}

void keyPressed() {
  if (!titleFlag) {
    character.keyPressed();
  }
}

void keyReleased() {
  if (!titleFlag) {
    character.keyReleased();
  }
}
void mouseMoved() {
  helper.mouseMoved();
}

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

class Masker {
  PGraphics mask;
  float x, y;
  Player2 p2;

  Masker(Player p, Player2 q) {
    x = p.player.getX();
    y = p.player.getY();
    p2 = q;
  }

  void draw() {
    drawMask();
    maskPixels();
  }

  void drawMask() {
    mask = createGraphics(width, height);
    mask.beginDraw();
    mask.background(0);
    mask.noStroke();
    mask.ellipseMode(RADIUS);
    if(p2.fuel > 0){
      mask.ellipse(mouseX, mouseY, 110, 110);
    }
    mask.ellipse(x+212, y+9, 55, 55);
    mask.endDraw();
  }

  void maskPixels() {
    loadPixels();
    for (int i=0; i < mask.pixels.length; ++i) {
      int maskPixel = mask.pixels[i];
      if (maskPixel != color(255)) {
        pixels[i] = color(25);
      }
    }
    updatePixels();
  }
}

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

class Player {
  float x = 515;
  float y = 490;
  FCircle player;
  float fuel = 200;

  boolean[] keys;

  Player() {
    player = new FCircle(30);
    player.setPosition(width/2-35, height-115);
    player.setDamping(0);
    player.setDensity(0.1);
    player.setFriction(100);
    player.setGrabbable(false);
    player.setStrokeWeight(0);
    player.setFill(244, 76, 0);
    keys = new boolean[3];
    keys[0] = false; //up
    keys[1] = false; //left
    keys[2] = false; //right
    HanselandGretel.world.add(player);
  }

  void update() {
    player.setFill(244, 76, 0, 255 * (1 - (200 - fuel)/220));
    //Self maintenance fuel depletion
    fuel -= 0.0075;
    fuel = constrain(fuel, 0, 200);

    if (keys[0] == true && fuel > 0) {
      player.addImpulse(0, -4);
      fuel -= 0.275;
    }
    if (keys[1] == true && fuel > 0) {
      player.addImpulse(-4, 0);
      fuel -= 0.075;
    }
    if (keys[2] == true && fuel > 0) {
      player.addImpulse(4, 0);
      fuel -= 0.075;
    }
  }

  void keyPressed() {
    if (keyCode == UP) {
      keys[0] = true;
    }
    if (keyCode == LEFT) {
      keys[1] = true;
    }
    if (keyCode == RIGHT) {
      keys[2] = true;
    }
  }

  void keyReleased() {
    if (keyCode == UP) {
      keys[0] = false;
    }
    if (keyCode == LEFT) {
      keys[1] = false;
    }
    if (keyCode == RIGHT) {
      keys[2] = false;
    }
  }
}

class Player2{
  float fuel = 200;
  FCircle[] crumbs = new FCircle[500];
  
  int inx = 0;
  
  private void upi(){
     inx = (inx+1) % crumbs.length;
     HanselandGretel.world.remove(crumbs[inx]);
     
  }
  
  void update(){
      noFill();
      stroke(0, 147, 207, 255 * (1 - (200 - (fuel-20))/200));
      ellipseMode(RADIUS);
      strokeWeight(15);
      ellipse(mouseX, mouseY, 110, 110);
      strokeWeight(7.5);
      ellipse(mouseX, mouseY, 110, 110);
      strokeWeight(3.75);
      ellipse(mouseX, mouseY, 110, 110);
      strokeWeight(1.25);
      ellipse(mouseX, mouseY, 110, 110);
  }
  
  
  
  void mouseMoved(){
    fuel -= 0.1;
    fuel = constrain(fuel, 0, 200);
  }
  
  void mousePressed(){
    if(fuel > 0){
      crumbs[inx] = new FCircle(4);
      crumbs[inx].setPosition(mouseX-212, mouseY-9);
      crumbs[inx].setDensity(0.001);
      crumbs[inx].setStrokeWeight(0);
      crumbs[inx].setFill(random(203-20, 203+20), random(178-20, 178+20),random(51-20,51+20));
      HanselandGretel.world.add(crumbs[inx]);  
      upi();
      fuel -= 0.3;
    }
  }
  
}
class Snow {

  float x, y;  
  float theta;
  float speed; 
  float w;    

  Snow(float tempX, float tempY, float tempSpeed, float tempW) {
    x = tempX;
    y = tempY;
    // Angle is always initialized to 0
    theta = 0; 
    speed = tempSpeed;
    w = tempW;
  }

  void spin() {
    theta += speed;
  }

  void display() {
    rectMode(CENTER);
    stroke(0);
    noStroke();
    fill(255, 100*(height - y)/height);
    pushMatrix();
    translate(x+random(-0.75, 0.75), y+random(-0.75, 0.75));
    rotate(theta);
    rect(0, 0, w, w);
    popMatrix();
  }
}

