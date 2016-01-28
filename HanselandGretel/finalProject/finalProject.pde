/**
 * ART Final Project
 * @author Thanh Le | College of Information Science and Technology | PennState University
 * txl252@psu.edu
 *
 *
 * A variety of libraries were used in this project
 * @Library : JavaParser | MIT License
 **/

static int BG_COLOR = 40;
static int BG_WIDTH = 1200;
static int BG_HEIGHT = 800;

ColorChooser c;
TextInput i;
static Parser p;

void setup() {
  size(BG_WIDTH, BG_HEIGHT);
  i = new TextInput(20, height-20, 10);
  c = new ColorChooser();
  p = new Parser("/Users/txl252/Desktop/finalProject.java");
  println("\n\n\n===TREE LOGIC TEST===\n");
  TreeNode t = new TreeNode(1);
  t = t.addNode(1, 2);
  t = t.addNode(2, 3);
  t = t.addNode(3, 9);
  t = t.addNode(2, 4);
  t = t.addNode(2, 5);
  t = t.addNode(5, 6);
  t = t.addNode(6, 7);
  t = t.addNode(6, 8);
  t.printNode(8);
  
  println("\n");
  
  t = new TreeNode("ROOT");
  t = t.addNode("ROOT", "R_L");
  t = t.addNode("ROOT", "R_R");
  t = t.addNode("R_L", "R_L_L");
  t = t.addNode("R_L", "R_L_R");
  t = t.addNode("R_R", "R_R_L");
  t = t.addNode("R_R", "R_R_R");
  t.printNode("R_R_R");
  println("");
  
}

void draw() {
  background(BG_COLOR);
  
  c.draw();
  i.draw();
}

void mouseMoved() {
  i.mouseMoved();
}

void mousePressed() {
  i.mousePressed();
}

void keyPressed() {
  i.keyPressed();
}

