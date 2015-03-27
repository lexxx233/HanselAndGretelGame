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
