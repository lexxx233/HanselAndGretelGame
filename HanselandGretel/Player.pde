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

