/**
 * Complementary color chooser
 * Inspired by the code of Geoff Ellis code from Open processing
 * But this code is my own work
 **/
class ColorChooser {
  int SHADE = 0;
  int TINT = 1;
  int segs = 12;
  int steps = 40;
  String RGBString = "";

  public color[] getCompColor(int numTone) {


    return new color[3];
  }

  void draw() {
    createWheel(width/2, height/2);

    if (mousePressed) {
      color c1, c2, c3, c4;
      
      int qx = abs(mouseX - width/2);
      int qy = abs(mouseY - height/2);
      
      c1 = get(width/2 - qx-10, height/2 - qy+30);
      c2 = get(width/2 - qx-30, height/2 + qy+10);
      c3 = get(width/2 + qx+10, height/2 - qy-30);
      c4 = get(width/2 + qx+30, height/2 + qy-10);
      
      ellipseMode(RADIUS);
      fill(255, 150);
      ellipse(width/2 - qx-10, height/2 - qy, 5, 5);
      ellipse(width/2 - qx-30, height/2 + qy, 5, 5);
      ellipse(width/2 + qx+10, height/2 - qy, 5, 5);
      ellipse(width/2 + qx+30, height/2 + qy, 5, 5);
      
      stroke(0, 150);
      strokeWeight(10);
      fill(c1);
      ellipse(450, 730, 40, 40);
      fill(c2);
      ellipse(550, 730, 40, 40);
      fill(c3);
      ellipse(650, 730, 40, 40);
      fill(c4);
      ellipse(750, 730, 40, 40);
      
    }
  }

  void createWheel(int x, int y) {
    float rotAdjust, segWidth, interval, nsteps, nsegs;
    float radius = 250.0;
    noStroke();
    nsteps = steps;
    nsegs = segs;
    rotAdjust = radians(360.0 / nsegs / 2.0);
    segWidth = radius / nsteps;
    interval = TWO_PI / nsegs;
    for (int j = 0; j < nsteps; j++) {
      color[] cols = {
        color(255-(255/nsteps)*j, 255-(255/nsteps)*j, 0), 
        color(255-(255/nsteps)*j, (255/1.5)-((255/1.5)/nsteps)*j, 0), 
        color(255-(255/nsteps)*j, (255/2)-((255/2)/nsteps)*j, 0), 
        color(255-(255/nsteps)*j, (255/2.5)-((255/2.5)/nsteps)*j, 0), 
        color(255-(255/nsteps)*j, 0, 0), 
        color(255-(255/nsteps)*j, 0, (255/2)-((255/2)/nsteps)*j), 
        color(255-(255/nsteps)*j, 0, 255-(255/nsteps)*j), 
        color((255/2)-((255/2)/nsteps)*j, 0, 255-(255/nsteps)*j), 
        color(0, 0, 255-(255/nsteps)*j), 
        color(0, 255-(255/nsteps)*j, (255/2.5)-((255/2.5)/nsteps)*j), 
        color(0, 255-(255/nsteps)*j, 0), 
        color((255/2)-((255/2)/nsteps)*j, 255-(255/nsteps)*j, 0)
      };
      for (int i = 0; i < nsegs; i++) {
        fill(cols[i]);
        arc(x, y, radius, radius, interval*i+rotAdjust, interval*(i+1)+rotAdjust);
      }
      radius -= segWidth;
    }
  }
}

