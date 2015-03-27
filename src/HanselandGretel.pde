import fisica.*;

Maze m;
static FWorld world;
Player character;
Player2 helper;
Masker mask;
boolean endFlag = false;
boolean titleFlag = true;
Snow[] snow = new Snow[30];

void setup() {
  frameRate(40);
  size(600, 750);
  m = new Maze(13, width/2+15, height/2 -20 , 550, 700);
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

  if (titleFlag) {
    background(35);
    textSize(40);
    fill(255);
    textAlign(CENTER);
    text("HANSEL & GRETEL", width/2, height/4);
    textSize(20);
    fill(244, 76, 0);
    text("Hansel: You are trying to get home at night.\n You have very limited vision & limited health.\n Use keypad to move & follow the breadcrumbs \n before you starve", width/2, height/4 * 1.25);
    fill(0, 147, 207);
    text("Gretel: You have much better vision\n your energy depletes as you move \n and drop breadcrumbs (with left click)\n Help Hansel to get home", width/2, height/4 * 2);
    fill(255);
    textSize(30);
    text("press SPACE to begin", width/2, height/4 * 2.95);
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
      character.update();
      helper.update();


      if (keyPressed) {
        character.keyPressed();
        if (key == ' ') {
          frameRate(40);
          size(600, 800);
          
          m = new Maze(13, width/2+15, height/2 -20 , 550, 700);
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
      character.update();
      helper.update();
      if (character.fuel <= 0) {
        fill(255);
        textSize(50);
        text("GURL, YOU STARVED !!!!\n press SPACE to restart", width/2, height/2);
      }
      if (character.player.getY() >= height-3 || character.player.getX() <= 30) {
        fill(255);
        textSize(50); 
        text("HANSEL IS HOME AGAIN!\n press SPACE to restart", width/2, height/2);
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

void mouseMoved() {
  helper.mouseMoved();
}

