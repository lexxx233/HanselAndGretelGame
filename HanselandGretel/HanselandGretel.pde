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
