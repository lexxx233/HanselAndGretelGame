class Player {
  //draw attributes
  float x = 515;
  float y = 490;
  FCircle player;
  float fuel = 200;

  Player() {
    player = new FCircle(30);
    player.setPosition(width/2-35, height-120);
    player.setDamping(0);
    player.setDensity(0.1);
    player.setFriction(100);
    player.setGrabbable(false);
    player.setStrokeWeight(0);
    player.setFill(244, 76, 0);
    HanselandGretel.world.add(player);
  }

  void update() {
    player.setFill(244, 76, 0, 255 * (1 - (200 - fuel)/220));
    //Self maintenance fuel depletion
    fuel -= 0.0075;
    fuel = constrain(fuel, 0, 200);    
  }

  void keyPressed() {
    int savedTime = 0;
    if (keyCode == UP) {
      if (fuel > 0 && player.getForceY() > -10) {
        player.addImpulse(0, -4);
        fuel -= 0.3;
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
        fuel -= 0.1;
      }
    }
    if (keyCode == RIGHT) {
      if (fuel > 0) {
        player.addImpulse(4, 0);
        fuel -= 0.1;
      }
    }
  }
}

