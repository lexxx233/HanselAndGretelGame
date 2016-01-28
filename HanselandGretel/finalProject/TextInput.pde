/**
 * Input class take text input by activating a click button
 * @author Thanh Le | College of Information Science and Technology | PennState University
 * txl252@psu.edu
 **/

class TextInput {

  String mostRecentText;
  String iText;
  float x, y, r;
  boolean streamOn = false;
  boolean isMe = false;

  TextInput(float ix, float iy, float ir) {
    iText = "";
    x = ix;
    y = iy;
    r = ir;
  } 

  public void draw() {  
    ellipseMode(RADIUS);
    fill(color(68, 170, 72));
    noStroke();
    ellipse(x, y, r, r);
    if (isMe) {
      fill(color(254,229,63));
      ellipse(x, y, r, r);
    }
    if (streamOn) {
      fill(color(254,229,63));
      stroke(color(68, 170, 72));
      strokeWeight(3);
      ellipse(x, y, r, r);
    }
    fill(color(68, 170, 72));
    text(iText, x + 2*r, y + r - 5);
  }

  void mouseMoved() {
    isMe = (abs(mouseX - x) <= r && abs(mouseY - y) <= r)? true : false;
  }

  void mousePressed() {
    if (isMe) {
      iText = "";
      streamOn = true;
    }
  }

  void keyPressed() {
    if (streamOn) {
      if (keyCode == ENTER) {
        mostRecentText = iText;
        streamOn = false;
        iText = "";
        finalProject.p = new Parser(mostRecentText);
      } else if (keyCode == BACKSPACE) {
        if (iText.length() > 0) {
          iText = iText.substring(0, iText.length()-1);
        }
      } else if (key == ' ' || keyCode == SHIFT) {
        //
      } else {
        iText += String.valueOf(key);
      }
    }
  }
}

