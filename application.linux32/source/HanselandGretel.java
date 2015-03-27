import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import fisica.*; 

import org.jbox2d.util.nonconvex.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.dynamics.controllers.*; 
import org.jbox2d.dynamics.contacts.*; 
import fisica.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.pooling.arrays.*; 
import org.jbox2d.common.*; 
import org.jbox2d.pooling.stacks.*; 
import org.jbox2d.util.sph.*; 
import org.jbox2d.util.blob.*; 
import org.jbox2d.pooling.*; 
import org.jbox2d.collision.*; 
import org.jbox2d.dynamics.joints.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class HanselandGretel extends PApplet {



Maze m;
static FWorld world;
Player character;
Player2 helper;
Masker mask;
boolean endFlag = false;
boolean titleFlag = true;
Snow[] snow = new Snow[30];

public void setup() {
  frameRate(40);
  size(600, 800);
  m = new Maze(13, width/2+15, height/2+50, 550, 700);
  m.generateMaze(5, 5, m);

  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 600);
  character = new Player();
  helper = new Player2();
  m.compound();

  for (int i = 0; i < snow.length; i++) {
    snow[i] = new Snow(random(width), random(height), random(-0.3f, 0.3f), random(7)+ 5);
  }
}

float i = 0;
public void draw() {

  if (titleFlag) {
    background(35);
    textSize(40);
    fill(255);
    textAlign(CENTER);
    text("HANSEL & GRETEL", width/2, height/4);
    textSize(20);
    fill(244, 76, 0);
    text("Hansel: You are trying to get home at night.\n You have very limited vision & limited health.\n Use keypad to move & follow the breadcrumbs \n before you starve", width/2, height/4 * 1.25f);
    fill(0, 147, 207);
    text("Gretel: You have much better vision\n your energy depletes as you move \n and drop breadcrumbs (with left click)\n Help Hansel to get home", width/2, height/4 * 2);
    fill(255);
    textSize(30);
    text("press SPACE to begin", width/2, height/4 * 2.95f);
    if(keyPressed){
      if(key == ' '){
        titleFlag = false;
      } 
    }
    
  }

  if (!titleFlag) {
    if (!endFlag) {
      background(35);
      world.step();
      world.draw(this);

      mask = new Masker(character, helper);
      mask.draw();

      rectMode(CORNER);
      character.draw();
      helper.draw();


      if (keyPressed) {
        character.keyPressed();
        if (key == ' ') {
          frameRate(40);
          size(600, 800);
          m = new Maze(13, width/2+15, height/2+50, 550, 700);
          m.generateMaze(5, 5, m);

          Fisica.init(this);
          world = new FWorld();
          world.setGravity(0, 600);
          character = new Player();
          helper = new Player2();
          m.compound();

          endFlag = false;
        }
      }
      if (mousePressed) {
        helper.mousePressed();
      }

      //Check winning or losing condition
      if (character.fuel <= 0) {
        endFlag = true;
      }
      if (character.player.getY() >= height-3 || character.player.getX() <= 30) {
        endFlag = true;
      }
    } else {
      background(35);
      world.step();
      world.draw(this);
      rectMode(CORNER);
      character.draw();
      helper.draw();
      if (character.fuel <= 0) {
        fill(255);
        textSize(50);
        text("GURL, YOU LOSE !!!!\n press SPACE to restart", width/2, height/2);
      }
      if (character.player.getY() >= height-3 || character.player.getX() <= 30) {
        fill(255);
        textSize(50); 
        text("YOU WIN !!!!\n SPACE to restart", width/2, height/2);
      }
    }
  }
  for (int i = 0; i < snow.length; i++) {
    snow[i].y += 0.75f;
    snow[i].x -= 0.5f;
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

public void mouseMoved() {
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
        temp[j] = 0.0f;
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

  public void addRow(float[] _row) {
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

  public void addCol(float[] _col) {
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
        m[i][j] = 0.0f;
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
        m[i][j] = (m[i][j] == 0.0f)? 1.0f : 0.0f;
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
      v[i] = 0.0f;
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
    float res = 0.0f;
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
    float res = 0.0f;
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

  public void draw() {
    drawMask();
    maskPixels();
  }

  public void drawMask() {
    mask = createGraphics(width, height);
    mask.beginDraw();
    mask.background(0);
    mask.noStroke();
    mask.ellipseMode(RADIUS);
    if(p2.fuel > 0){
      mask.ellipse(mouseX, mouseY, 110, 110);
    }
    mask.ellipse(x, y, 55, 55);
    mask.endDraw();
  }

  public void maskPixels() {
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
        _maze.maze.m[cy][cx] = this.bOR(PApplet.parseInt(_maze.maze.m[cy][cx]), direction);
        _maze.maze.m[ny][nx] = this.bOR(PApplet.parseInt(_maze.maze.m[ny][nx]), OPPOSITE.get(direction));

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
    float numRow = PApplet.parseFloat(wall.m.length);
    int fidx = 0;
    for (int i = 0; i < numRow; i++) {
      for (int j = 0; j < numRow; j++) { 

        int incr_i = i+1;
        incr_i = constrain(incr_i, 0, PApplet.parseInt(numRow)-1);
        int incr_j = j+1;
        incr_j = constrain(incr_j, 0, PApplet.parseInt(numRow)-1);

        if (wall.m[i][j] == 1.0f &&  wall.m[i][incr_j] == 1.0f) {
          FLine tempLine = new FLine(w/numRow * i - w/2 + x, h/numRow * j - h/2 + y, w/numRow * i - w/2 + x, h/numRow * (incr_j) - h/2 + y);
          tempLine.setStroke(random(100, 200),random(100, 200),0);
          tempLine.setStrokeWeight(1);
          tempLine.setRestitution(0.1f);
          tempLine.setFriction(100);
          wallCompound.addBody(tempLine);
          FLine tempLine2 = new FLine(w/numRow * i - w/2 + x-0.1f, h/numRow * (incr_j) - h/2 + y, w/numRow * i - w/2 + x-0.1f, h/numRow * j - h/2 + y); // Sketchy ass fix for the physics engine... I hope you don't see this :(
          tempLine2.setStroke(random(100, 200),random(100, 200),0);
          tempLine2.setStrokeWeight(1);
          tempLine2.setRestitution(0.1f);
          tempLine2.setFriction(100);
          wallCompound.addBody(tempLine2);
        }

        if (wall.m[i][j] == 1.0f && wall.m[incr_i][j] == 1.0f) {
          //line(w/numRow * i - w/2, h/numRow * j - h/2, w/numRow * (incr_i) - w/2, h/numRow * j - h/2);
          FLine tempLine = new FLine(w/numRow * i - w/2 + x-0.1f, h/numRow * j - h/2 + y, w/numRow * (incr_i) - w/2 + x + 0.1f, h/numRow * j - h/2 + y);
          tempLine.setStroke(0, random(100, 200),random(100, 200));
          tempLine.setStrokeWeight(1);
          tempLine.setRestitution(0.5f);
          tempLine.setFriction(100);
          wallCompound.addBody(tempLine);
          FLine tempLine2 = new FLine( w/numRow * (incr_i) - w/2 + x+0.1f, h/numRow * j - h/2 + y+0.1f, w/numRow * i - w/2 + x - 0.1f, h/numRow * j - h/2 + y+0.1f);
          tempLine2.setStroke(0, random(100, 200),random(100, 200));
          tempLine2.setStrokeWeight(1);
          tempLine2.setRestitution(0.5f);
          tempLine2.setFriction(100);
          wallCompound.addBody(tempLine2);
        }
      }
    }
    HanselandGretel.world.add(wallCompound);
  }
  
  private int[] index(String s) {
    return new int[] {
      PApplet.parseInt(s.split("-"))[0], PApplet.parseInt(s.split("-"))[1]
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
      idx.add(PApplet.parseInt(random(0, idx.size())), i);
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
      idx.add(PApplet.parseInt(random(0, idx.size())), i);
    }
    for (int i = 0; i < idx.size (); i++) {
      res.add(arr.get(idx.get(i)));
    }
    return res;
  }
}

class Player {
  //draw attributes
  float x = 515;
  float y = 490;
  FCircle player;
  float fuel = 200;

  Player() {
    player = new FCircle(30);
    player.setPosition(width/2-35, height-45);
    player.setDamping(0);
    player.setDensity(0.1f);
    player.setFriction(100);
    player.setGrabbable(false);
    player.setStrokeWeight(0);
    player.setFill(230);
    HanselandGretel.world.add(player);
  }

  public void draw() {
    fill(100);
    rect(30, 10, 200*2.75f, 12);

    fill(244, 76, 0);
    noStroke();
    rect(30, 10, fuel*2.75f, 12);

    //Self maintenance fuel depletion
    fuel -= 0.0075f;
    fuel = constrain(fuel, 0, 200);    
  }

  public void keyPressed() {
    int savedTime = 0;
    if (keyCode == UP) {
      if (fuel > 0 && player.getForceY() > -10) {
        player.addImpulse(0, -4);
        fuel -= 0.3f;
        savedTime = millis();
      } else {
        if (millis() - savedTime > 1000) {
          player.resetForces();
        }
      }
    }
    if (keyCode == LEFT) {
      if (fuel > 0) {
        player.addImpulse(-4, 0);
        fuel -= 0.1f;
      }
    }
    if (keyCode == RIGHT) {
      if (fuel > 0) {
        player.addImpulse(4, 0);
        fuel -= 0.1f;
      }
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
  
  public void draw(){
    fill(100);
    rect(30, 24, 200*2.75f, 12);
    fill(0, 147, 207);
    noStroke();
    rect(30, 24, fuel*2.75f, 12);
  }
  
  public void mouseMoved(){
    fuel -= 0.1f;
    fuel = constrain(fuel, 0, 200);
  }
  
  public void mousePressed(){
    if(fuel > 0){
      crumbs[inx] = new FCircle(4);
      crumbs[inx].setPosition(mouseX, mouseY);
      crumbs[inx].setDensity(0.001f);
      crumbs[inx].setStrokeWeight(0);
      crumbs[inx].setFill(random(203-20, 203+20), random(178-20, 178+20),random(51-20,51+20));
      HanselandGretel.world.add(crumbs[inx]);  
      upi();
      fuel -= 0.3f;
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

  public void spin() {
    theta += speed;
  }

  public void display() {
    rectMode(CENTER);
    stroke(0);
    noStroke();
    fill(255, 100*(height - y)/height);
    pushMatrix();
    translate(x+random(-0.75f, 0.75f), y+random(-0.75f, 0.75f));
    rotate(theta);
    rect(0, 0, w, w);
    popMatrix();
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "HanselandGretel" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
