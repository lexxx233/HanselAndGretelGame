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
    mask.ellipse(x, y, 55, 55);
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

