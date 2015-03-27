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
    player.setDensity(0.1);
    player.setFriction(100);
    player.setGrabbable(false);
    player.setStrokeWeight(0);
    player.setFill(230);
    HanselandGretel.world.add(player);
  }

  void draw() {
    fill(100);
    rect(30, 10, 200*2.75, 12);

    fill(244, 76, 0);
    noStroke();
    rect(30, 10, fuel*2.75, 12);

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

